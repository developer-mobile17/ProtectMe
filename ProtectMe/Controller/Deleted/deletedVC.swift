//
//  deletedVC.swift
//  ProtectMe
//
//  Created by Mac on 24/08/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//


import UIKit
import SDWebImage
import AVFoundation
import AVKit
import MapKit

extension deletedVC:MKMapViewDelegate{
    
}

class deletedVC: baseVC {
    @IBOutlet weak var txtName:AIBaseTextField!{
        didSet{
            txtName.borderColor = .black
            txtName.borderWidth = 1.0
            txtName.leftViewPadding = 12
        txtName.validationType = .alphaNumeric_WithSpace
        txtName.config.textFieldKeyboardType = .name

        }
    }
    @IBOutlet weak var txtSearch:AIBaseTextField!{
          didSet{
            txtSearch.leftViewPadding = 12
            txtSearch.placeHolderColor = .lightGray
            txtSearch.config.textFieldKeyboardType = .name
          }
      }
    @IBOutlet weak var tblVideoList:UITableView!
    @IBOutlet weak var collVideogrid:UICollectionView!
   // @IBOutlet weak var Viewmap:UIView!
    @IBOutlet weak var ViewCreateFolder:UIControl!

    @IBOutlet weak var ViewVideoDetails:UIControl!
    @IBOutlet weak var ViewOptionMenu:UIControl!
    @IBOutlet weak var btnRecent:UIButton!
    @IBOutlet weak var btnDateAdded:UIButton!
    @IBOutlet weak var btnGreed:UIButton!
    @IBOutlet weak var btnlist:UIButton!
    @IBOutlet weak var lblMonthandYear:UILabel!{
        didSet{
            lblMonthandYear.text = ""
        }
    }
    var selectedIndex:IndexPath? = nil
//Detail View
    @IBOutlet weak var lblDetailType:UILabel!
    @IBOutlet weak var lblDetailName:UILabel!
    @IBOutlet weak var lblDetailName1:UILabel!
    @IBOutlet weak var lblDetailName2:UILabel!

    @IBOutlet weak var lblDetailSize:UILabel!
    @IBOutlet weak var lblDetailStorageUsed:UILabel!
    @IBOutlet weak var lblDetailSharedBy:UILabel!
    @IBOutlet weak var lblDetailDateCreatedandLocation:UILabel!
    //@IBOutlet weak var mapView: MKMapView!

    var selectedType = "recent"
    var selectedFilter = "0"
    var arrselectedType = ["recent","folders","folders"]
    var arrarchivedList:[archivedListModel] = [archivedListModel]()
    var sectionIsExpanded: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.25) {
                if self.sectionIsExpanded {
                    self.btnDateAdded.imageView?.transform = CGAffineTransform.identity
                } else {
                    self.btnDateAdded.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
                }
            }
        }
    }
    @IBOutlet weak var btnFolders:UIButton!
    @IBOutlet weak var btnShared:UIButton!
    var arrOption = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        arrOption = [btnRecent,btnFolders,btnShared]
        self.collVideogrid.delegate = self
        self.collVideogrid.dataSource = self
   //     mapView.delegate = self

        self.tblVideoList.register(UINib(nibName: "VideoDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoDetailsTableViewCell")
            //self.Viewmap.isHidden = true
        // Do any additional setup after loading the view.
    }
    
   // MARK: - Button Click Action
    @IBAction func btnCreateFolderAction(_ sender: UIControl) {
        guard let text = txtName.text, !text.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: "Please enter folder name.")
            return
        }
        self.WSCreateFolder(Parameter: ["name":text])
        
    }
      
    @IBAction func btnDeleteArchiveClick(_ sender: UIControl) {
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME
            
                   , andMessage: "Are you sure you want to delete?", buttons: ["Yes","Cancel"]) { (index) in
                       if(index == 0){
                           self.WSDeleteFile(Parameter: ["id":self.arrarchivedList[self.selectedIndex!.row].id!,"type":"0"])
                       }
                   }
        
    }
    
    @IBAction func btnClearAllButton(_ sender: UIButton) {
        if(arrarchivedList.count>0){
            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME
            , andMessage: "Are you sure you want to empty the deleted files ?", buttons: ["Yes","Cancel"]) { (index) in
                if(index == 0){
                    self.WSCleatDeletedfiles(Parameter: [:])
                }
            }

        }
        else{
            //showAlertWithTitleFromVC(vc: self, andMessage: "")
        }
    }
    @IBAction func btnVideoRecover(_ sender: UIButton) {
        self.WSRecoverFile(Parameter: ["file_id":self.arrarchivedList[self.selectedIndex!.row].id!])
    }
    
//    @IBAction func btnVideoDetails(_ sender: UIButton) {
//        self.btnHandlerBlackBg(self)
//        self.ViewVideoDetails.frame = UIScreen.main.bounds
//        self.navigationController?.view.addSubview(self.ViewVideoDetails)
//    }
    func setDetails(data:archivedListModel) -> Void {
        self.lblDetailName.text = ""
        self.lblDetailName1.text = ""
        self.lblDetailName2.text = ""

        self.lblDetailSize.text = ""
        self.lblDetailType.text = ""
        if(data.user_id == USER.shared.id){
            self.lblDetailSharedBy.text = "YOU"
        }
        else{
            self.lblDetailSharedBy.text = "-"
        }
        self.lblDetailStorageUsed.text = data.storage_used?.uppercased()
        let date = data.created?.uppercased()
        let newdate = date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.toLocalTime()
        
        //self.lblDateCreatedandLocation.text = "DATE CREATED"
        self.lblDetailDateCreatedandLocation.text = (self.UTCToLocalAM(date: data.created!))

        let city = ""
        let country = ""
//        self.lblDetailDateCreatedandLocation.text = (date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getyyyMMdd())!

        print()
        
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
        self.selectedIndex = IndexPath(row: sender.tag, section: 0)
        self.lblDetailName.text = self.arrarchivedList[selectedIndex!.row].folder_name
 //       self.setDetails(data:self.arrarchivedList[sender.tag])
        self.ViewOptionMenu.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewOptionMenu)
    }
    @IBAction func btnhideDetails(_ sender: Any)
    {
        self.ViewCreateFolder.removeFromSuperview()
        self.ViewVideoDetails.removeFromSuperview()

//        self.ViewVideoDetails.removeFromSuperview()
    }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        self.ViewOptionMenu.removeFromSuperview()
    }
    @IBAction func btnChangeRename(_ sender: Any)
    {
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
        OBJchangepasswordVC.titleString = "File Name"
        OBJchangepasswordVC.FieldType = "video"
        OBJchangepasswordVC.fileID = self.arrarchivedList[selectedIndex!.row].id!
        OBJchangepasswordVC.txtValue = self.arrarchivedList[selectedIndex!.row].folder_name!
        
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
        self.btnChangeTableView(self.btnGreed)
        txtName.borderColor = .black
        txtName.borderWidth = 1.0
        WSDeletedFiles(Parameter: [:])

    }
    @IBAction func btnChangeTableView(_ sender: UIButton) {
        if(sender == self.btnlist){
            self.btnlist.tintColor = UIColor.clrSkyBlue
            self.btnGreed.tintColor = UIColor.themeGrayColor
            UIView.animate(withDuration: 0.1,
                       delay: 0.2,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.tblVideoList.alpha = 0.5
                        self.collVideogrid.alpha = 0.5
            }, completion: { (finished) -> Void in
                self.tblVideoList.alpha = 1.0
                self.collVideogrid.alpha = 1.0
                self.tblVideoList.isHidden = false
                self.collVideogrid.isHidden = true
            })
        }
        else{
            self.btnlist.tintColor = UIColor.themeGrayColor
            self.btnGreed.tintColor = UIColor.clrSkyBlue
            UIView.animate(withDuration: 0.1,
                                  delay: 0.2,
                                  options: UIView.AnimationOptions.curveEaseIn,
                                  animations: { () -> Void in
                                   self.tblVideoList.alpha = 0.5
                                   self.collVideogrid.alpha = 0.5
                       }, completion: { (finished) -> Void in
                       // ....
                           self.tblVideoList.alpha = 1.0
                           self.collVideogrid.alpha = 1.0
                              self.tblVideoList.isHidden = true
                           self.collVideogrid.isHidden = false
                       })
        }
    }
    @IBAction func btnbtnAddedClick(_ sender: UIButton) {
        sectionIsExpanded = !sectionIsExpanded
        if(sectionIsExpanded == true){
            self.selectedFilter  = "0"
        }
        else{
            self.selectedFilter  = "1"
        }
        //WSFolderList(Parameter: [:])

    }
    @IBAction func btnSelectOptions(_ sender: UIButton) {
        self.selectOptions(selected: sender)
    }
    @IBAction func selectOptions(selected:UIButton)  {
//        for btn in arrOption{
//
//            if(btn == selected){
//                if(btn == self.btnRecent){
//                    self.selectedType = "recent"
//                }
//                else if(btn == self.btnFolders){
//                    self.selectedType = "folders"
//                }
//                else{
//                    self.selectedType = "folders"
//                }
//                btn.setTitleColor(UIColor.clrSkyBlue, for: .normal)
//
//            }
//            else{
//                btn.setTitleColor(UIColor.lightGray, for: .normal)
//            }
//        }
//        WSFolderList(Parameter: [:])

    }
    
   @IBAction func showPlusButtonAction(_ sender:UIButton){
        showActionSheetWithTitleFromVC(vc: self, title:Constant.APP_NAME, andMessage: "Choose action", buttons: ["Create New Folder","Photo Album","Video Album"], canCancel: true) { (i) in
            if(i == 0){
                self.ViewCreateFolder.frame = UIScreen.main.bounds
                self.navigationController?.view.addSubview(self.ViewCreateFolder)
            }
            else if(i == 1){
                //self.PhotoAlbum()
                
            }
            else
            {
                //self.VideoAlbum()
            }
        }
    }

    // MARK: - WEB Service
    func WSCreateFolder(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .create_folder, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let archived_counter = dataResponce["archived_counter"] as? Int{
                        USER.shared.archived_counter = String(archived_counter)
                        USER.shared.save()
                    }
                                       if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                                                               USER.shared.linked_account_counters = String(linked_account_counters)
                                       USER.shared.save()
                                       }
                    self.btnhideDetails(self)
                    //self.WSFolderList(Parameter: [:])
                }
                    else if(StatusCode == 307)
                    {
                        if let errorMessage:String = dataResponce["message"] as? String{
                        if let LIveURL:String = dataResponce["iOS_live_application_url"] as? String{
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Open Store"]) { (i) in
                                if let url = URL(string: LIveURL),
                                UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            }
                            //showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                            }
                    }
                    else if(StatusCode == 412)
                    {
                        if let errorMessage:String = dataResponce["message"] as? String{
                                showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                        }
                    }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                            USER.shared.isLogout = true
                            USER.shared.save()
                                appDelegate.setLoginVC()
                                // Fallback on earlier versions
                            
                        }
                    }
                }
                else{
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                }
            }
            else{
                if let errorMessage:String = Message{
                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
            }
        }) { (DataResponce, Status, Message) in
            //
        }
    }
    func WSCleatDeletedfiles(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .clear_all_deleted_files, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let archived_counter = dataResponce["archived_counter"] as? Int{
                        USER.shared.archived_counter = String(archived_counter)
                        USER.shared.save()
                    }
                                       if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                                                               USER.shared.linked_account_counters = String(linked_account_counters)
                                       USER.shared.save()
                                       }
                    self.arrarchivedList.removeAll()
                    self.collVideogrid.reloadData()
                }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = Message{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                          USER.shared.isLogout = true
                          USER.shared.save()
                                appDelegate.setLoginVC()
                                // Fallback on earlier versions
                            
                        }
                    }
                }
                else{
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                }
            }
            else{
                if let errorMessage:String = Message{
                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
            }
        }) { (DataResponce, Status, Message) in
            //
        }
    }
    func WSRecoverFile(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .recover_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let archived_counter = dataResponce["archived_counter"] as? Int{
                        USER.shared.archived_counter = String(archived_counter)
                        USER.shared.save()
                    }
                    if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                        USER.shared.linked_account_counters = String(linked_account_counters)
                        USER.shared.save()
                    }
                    self.WSDeletedFiles(Parameter: [:])
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                    self.btnHandlerBlackBg(self)
                    self.btnhideDetails(self)
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        
                    }
                }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = Message{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                          USER.shared.isLogout = true
                          USER.shared.save()
                                appDelegate.setLoginVC()
                                // Fallback on earlier versions
                            
                        }
                    }
                }
                else{
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                }
            }
            else{
                if let errorMessage:String = Message{
                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
            }
        }) { (DataResponce, Status, Message) in
            //
        }
    }
    func WSDeleteFile(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .delete_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let archived_counter = dataResponce["archived_counter"] as? Int{
                        USER.shared.archived_counter = String(archived_counter)
                        USER.shared.save()
                    }
                                       if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                                                               USER.shared.linked_account_counters = String(linked_account_counters)
                                       USER.shared.save()
                                       }
                    self.WSDeletedFiles(Parameter: [:])

                    self.btnHandlerBlackBg(self)
                    self.btnhideDetails(self)
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        
                    }
                }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = Message{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                          USER.shared.isLogout = true
                          USER.shared.save()
                                appDelegate.setLoginVC()
                                // Fallback on earlier versions
                            
                        }
                    }
                }
                else{
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                }
            }
            else{
                if let errorMessage:String = Message{
                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
            }
        }) { (DataResponce, Status, Message) in
            //
        }
    }
    func WSDeletedFiles(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .deleted_files, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let archived_counter = dataResponce["archived_counter"] as? String{
                        USER.shared.archived_counter = archived_counter
                        USER.shared.save()
                    }
                    if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                        USER.shared.linked_account_counters = String(linked_account_counters)
                            USER.shared.save()

                    }
                    
                    if let outcome = dataResponce["data"] as? [NSDictionary]{
                        self.arrarchivedList.removeAll()
                        for a : Int in (0..<(outcome.count))
                        {
                            let objarchivedList : archivedListModel = archivedListModel()
                            objarchivedList.city         = outcome[a]["city"] as? String ?? ""
                            objarchivedList.country      = outcome[a]["country"] as? String ?? ""
                            objarchivedList.created      = outcome[a]["created"] as? String ?? ""
                            objarchivedList.file_size    = outcome[a]["file_size"] as? String ?? ""
                            objarchivedList.folder_id    = outcome[a]["folder_id"] as? String ?? ""
                            objarchivedList.folder_name  = outcome[a]["folder_name"] as? String ?? ""
                            objarchivedList.id           = outcome[a]["id"] as? String ?? ""
                            objarchivedList.image_name   = outcome[a]["image_name"] as? String ?? ""
                            objarchivedList.image_path   = outcome[a]["image_path"] as? String ?? ""
                            objarchivedList.longitude     = outcome[a]["longitude"] as? String ?? ""
                            objarchivedList.latitude    = outcome[a]["latitude"] as? String ?? ""
                            objarchivedList.state        = outcome[a]["state"] as? String ?? ""
                            objarchivedList.status       = outcome[a]["status"] as? String ?? ""
                            objarchivedList.type         = outcome[a]["type"] as? String ?? ""
                            objarchivedList.updated      = outcome[a]["updated"] as? String ?? ""
                            objarchivedList.uploaded_by     = outcome[a]["uploaded_by"] as? String ?? ""
                            objarchivedList.user_id      = outcome[a]["user_id"] as? String ?? ""
                            objarchivedList.name      = outcome[a]["name"] as? String ?? ""
                            
                            objarchivedList.thumb_image      = outcome[a]["thumb_image"] as? String ?? ""

                            self.arrarchivedList.append(objarchivedList)
                        }
                        if(self.arrarchivedList.count == 0){
                            //self.collVideogrid.setEmptyMessage("No Data Found!")
                        }
                        self.tblVideoList.reloadData()
                        self.collVideogrid.reloadData()
                    }
                }
                    else if(StatusCode == 307)
                    {
                        if let errorMessage:String = dataResponce["message"] as? String{
                        if let LIveURL:String = dataResponce["iOS_live_application_url"] as? String{
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Open Store"]) { (i) in
                                if let url = URL(string: LIveURL),
                                UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.openURL(url)
                                }
                            }
                            }
                            //showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                            }
                    }
                    else if(StatusCode == 412)
                    {
                        if let errorMessage:String = dataResponce["message"] as? String{
                                showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                        }
                    }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                            USER.shared.isLogout = true
                            USER.shared.save()
                                appDelegate.setLoginVC()
                                // Fallback on earlier versions
                            
                        }
                    }
                }
                else{
                    if let errorMessage:String = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                    }
                }
            }
            else{
                if let errorMessage:String = Message{
                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
            }
        }) { (DataResponce, Status, Message) in
            //
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {
        
        guard let url = URL(string: (url ?? "")) else { return }
        DispatchQueue.main.async {
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            
            let time = CMTimeMake(value: 2, timescale: 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                completion(thumbnail)
            } catch let error{
                print("Error :: ", error)
                completion(nil)
            }
        }
    }

}
extension deletedVC:sendbacktoName{
    func getselectedvire(view: String) {
        if(view == "grid"){
            self.btnChangeTableView(self.btnGreed)
        }
        else{
            self.btnChangeTableView(self.btnlist)
        }
    }
    
    func changename(name: String, index: IndexPath) {
        
    }
}
extension deletedVC:UICollectionViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrarchivedList.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsTableViewCell", for: indexPath) as! VideoDetailsTableViewCell
        cell.videoThumb.image = #imageLiteral(resourceName: "ic_folder")
        cell.selectionStyle = .none
        cell.btnMap.isHidden = true
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
     //   cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
        cell.lblTitle.text = self.arrarchivedList[indexPath.row].folder_name
        cell.lblName.text = self.arrarchivedList[indexPath.row].name
        
        return cell
    }
    
   
}
extension deletedVC:UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let padding: CGFloat = 50
    let collectionCellSize = collectionView.frame.size.width - padding
    return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrarchivedList.count
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell:collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! collCell
        cell.videoThumb.image = nil
        cell.btnPlayvideo.tag = indexPath.row
        //cell.btnMap.tag = indexPath.row
        cell.btnPlayvideo.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
        //cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
        cell.lblTitle.text = self.arrarchivedList[indexPath.row].image_name
        cell.lblName.text = self.arrarchivedList[indexPath.row].uploaded_by
        if(arrarchivedList[indexPath.row].type == "image"){
            cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].image_path!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
            cell.imgtype.image = #imageLiteral(resourceName: "ic_playimg")
          }
        else{
            cell.imgtype.image = #imageLiteral(resourceName: "ic_playvid")
            cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].thumb_image!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
        }
        return cell
        }
    
}
