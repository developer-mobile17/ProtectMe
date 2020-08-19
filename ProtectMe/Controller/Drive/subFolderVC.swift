//
//  subFolderVC.swift
//  ProtectMe
//
//  Created by Mac on 19/08/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//



import UIKit
import SDWebImage
import AVFoundation



class subFolderVC: baseVC {
    var FileId:String = ""
    var FolderId:String = ""
    @IBOutlet weak var navigationbar: UINavigationBar!

    var buttonName:String = ""
    var data = archivedListModel()
    var navigationTitle:String = ""
  
    @IBOutlet weak var tblVideoList:UITableView!
    @IBOutlet weak var collVideogrid:UICollectionView!
   // @IBOutlet weak var Viewmap:UIView!
    @IBOutlet weak var ViewCreateFolder:UIControl!
    @IBOutlet weak var btnCancle:UIButton!
    @IBOutlet weak var btnAction:UIButton!

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
    @IBOutlet weak var txtName:AIBaseTextField!{
           didSet{
          // txtName.borderColor = .black
           txtName.borderWidth = 1.0
           txtName.leftViewPadding = 12
           //txtName.validationType = .alphaNumeric_WithSpace
           //txtName.config.textFieldKeyboardType = .name
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
    var arrFolderList:[FolderListMOdel] = [FolderListMOdel]()
    var arrFileList:[archivedListModel] = [archivedListModel]()
    
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
    @IBAction func btnPlusFolderAction(_ sender: Any){
        self.ViewCreateFolder.frame = UIScreen.main.bounds

        UIView.animate(withDuration: 0.2, animations: {self.ViewCreateFolder.alpha = 0.0},
               completion: {(value: Bool) in
                            self.ViewCreateFolder.alpha = 1.0
                             self.navigationController?.view.addSubview(self.ViewCreateFolder)
                           })

//        self.ViewCreateFolder.frame = UIScreen.main.bounds
//     //   self.ViewCreateFolder.animShow()
//        self.navigationController?.view.addSubview(self.ViewCreateFolder)
    }
    @IBAction func btnCancleAction(_ sender: Any){
       for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: archiveVC.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        //self.navigationController?.popToRootViewController(animated: true)
    }
     @IBAction func btnAction(_ sender: Any){
        if(self.buttonName == "Copy"){
            self.WSCopyFileHere(Parameter: ["file_id":self.FileId,"folder_id":self.FolderId])
        }
        else{
            self.WSMoveFileHere(Parameter: ["file_id":self.FileId,"folder_id":self.FolderId])
        }
     }
    @IBAction func btnBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnVideoDetails(_ sender: UIButton) {
        self.btnHandlerBlackBg(self)
        self.ViewVideoDetails.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewVideoDetails)
    }
    func setDetails(data:FolderListMOdel) -> Void {
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
        self.lblDetailStorageUsed.text = "-"
        let date = data.created?.uppercased()
        let city = ""
        let country = ""
        self.lblDetailDateCreatedandLocation.text = (date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getyyyMMdd())!

        print()
        
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
        self.selectedIndex = IndexPath(row: sender.tag, section: 0)
        self.lblDetailName.text = self.arrFolderList[selectedIndex!.row].folder_name
 //       self.setDetails(data:self.arrarchivedList[sender.tag])
        self.ViewOptionMenu.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewOptionMenu)
    }
    @IBAction func btnhideDetails(_ sender: Any)
    {
        UIView.animate(withDuration: 0.2, animations: {self.ViewCreateFolder.alpha = 0.0},
        completion: {(value: Bool) in
            self.ViewCreateFolder.alpha = 1.0
                      self.ViewCreateFolder.removeFromSuperview()
                    })

       // self.ViewVideoDetails.removeFromSuperview()

//        self.ViewVideoDetails.removeFromSuperview()
    }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        //self.ViewOptionMenu.removeFromSuperview()
    }
    @IBAction func btnChangeRename(_ sender: Any)
    {
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
        OBJchangepasswordVC.titleString = "File Name"
        OBJchangepasswordVC.FieldType = "video"
        OBJchangepasswordVC.fileID = self.arrFolderList[selectedIndex!.row].id!
        OBJchangepasswordVC.txtValue = self.arrFolderList[selectedIndex!.row].folder_name!
        
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = navigationTitle
        txtName.borderColor = .black
        txtName.borderWidth = 1.0
        txtName.Round = true
       // txtName.cornerRadius = txtName.layer.frame.size.height/2
        if(self.buttonName != ""){
            self.btnAction.setTitle(buttonName, for: .normal)
            self.btnCancle.isHidden = false
            self.btnAction.isHidden = false

        }
        else{
            self.btnCancle.isHidden = true
            self.btnAction.isHidden = true
        }
        WSFolderList(Parameter: ["folder_id":self.FolderId])
    }
    @IBAction func btnCreateFolderAction(_ sender: UIControl) {
             guard let text = txtName.text, !text.isEmpty else {
                 showAlertWithTitleFromVC(vc: self, andMessage: "Please enter folder name.")
                 return
             }
//             self.WSCreateFolder(Parameter: ["name":text])
        self.WSCreateFolder(Parameter: ["name":text,"main_folder_id":self.FolderId])

             
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
        WSFolderList(Parameter: [:])

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
                self.PhotoAlbum()
                
            }
            else
            {
                self.VideoAlbum()
            }
        }
    }

    // MARK: - WEB Service
    func WSMoveFileHere(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .move, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.WSFolderList(Parameter: ["folder_id":self.FolderId])
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
    func WSCopyFileHere(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .copy, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.WSFolderList(Parameter: ["folder_id":self.FolderId])
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
    func WSCreateFolder(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .create_folder, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.btnhideDetails(self)
                    self.WSFolderList(Parameter: ["folder_id":self.FolderId])

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
    func WSDeleteArchive(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .delete_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.btnHandlerBlackBg(self)
                    self.btnhideDetails(self)
                 //   self.btnSelectOptions(self.btnRecent)

                    if let outcome = dataResponce["data"] as? NSDictionary{
                        
                    }
                }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = Message{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                          
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
    func WSFolderList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .nested_folder_list, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        self.arrFolderList.removeAll()
                        self.arrFileList.removeAll()

                        if let folderArr = outcome["folder_list"] as? [NSDictionary]{
                            for a : Int in (0..<(folderArr.count))
                            {
                                let objarchivedList : FolderListMOdel = FolderListMOdel()
                                objarchivedList.created      = folderArr[a]["created"] as? String ?? ""
                                objarchivedList.folder_name  = folderArr[a]["folder_name"] as? String ?? ""
                                objarchivedList.id           = folderArr[a]["id"] as? String ?? ""
                                objarchivedList.updated      = folderArr[a]["updated"] as? String ?? ""
                                objarchivedList.user_id      = folderArr[a]["user_id"] as? String ?? ""
                                objarchivedList.name         = folderArr[a]["name"] as? String ?? ""

                                self.arrFolderList.append(objarchivedList)
                            }
                           // self.collVideogrid.reloadSections(NSIndexSet(index: 0) as IndexSet)

                            
                        }
                        if let FileArr = outcome["file_list"] as? [NSDictionary]{
                            for a : Int in (0..<(FileArr.count))
                            {
                                let objarchivedList : archivedListModel = archivedListModel()
                                objarchivedList.city         = FileArr[a]["city"] as? String ?? ""
                                objarchivedList.country      = FileArr[a]["country"] as? String ?? ""
                                objarchivedList.created      = FileArr[a]["created"] as? String ?? ""
                                objarchivedList.file_size    = FileArr[a]["file_size"] as? String ?? ""
                                objarchivedList.folder_id    = FileArr[a]["folder_id"] as? String ?? ""
                                objarchivedList.folder_name  = FileArr[a]["folder_name"] as? String ?? ""
                                objarchivedList.id           = FileArr[a]["id"] as? String ?? ""
                                objarchivedList.image_name   = FileArr[a]["image_name"] as? String ?? ""
                                objarchivedList.image_path   = FileArr[a]["image_path"] as? String ?? ""
                                objarchivedList.longitude    = FileArr[a]["latitude"] as? String ?? ""
                                objarchivedList.latitude     = FileArr[a]["longitude"] as? String ?? ""
                                objarchivedList.state        = FileArr[a]["state"] as? String ?? ""
                                objarchivedList.status       = FileArr[a]["status"] as? String ?? ""
                                objarchivedList.type         = FileArr[a]["type"] as? String ?? ""
                                objarchivedList.updated      = FileArr[a]["updated"] as? String ?? ""
                                objarchivedList.uploaded_by     = FileArr[a]["uploaded_by"] as? String ?? ""

                                objarchivedList.user_id      = FileArr[a]["user_id"] as? String ?? ""
                                objarchivedList.name         = FileArr[a]["name"] as? String ?? ""
                                objarchivedList.thumb_image  = FileArr[a]["thumb_image"] as? String ?? ""
                                self.arrFileList.append(objarchivedList)
                            }
                          //  self.collVideogrid.reloadSections(NSIndexSet(index: 1) as IndexSet)
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
extension subFolderVC:sendbacktoName{
    func changename(name: String, index: IndexPath) {
        
    }
}
extension subFolderVC:UICollectionViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFolderList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsTableViewCell", for: indexPath) as! VideoDetailsTableViewCell
        cell.videoThumb.image = #imageLiteral(resourceName: "ic_folder")
        cell.selectionStyle = .none
        cell.btnMap.isHidden = true
       // cell.btnOption.tag = indexPath.row
        //cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
     //   cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
        cell.lblTitle.text = self.arrFolderList[indexPath.row].folder_name
        cell.lblName.text = self.arrFolderList[indexPath.row].name
        
        return cell
    }
    
   
}
extension subFolderVC:UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
     func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 2
       }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return self.arrFolderList.count
        }
        else{
            return self.arrFileList.count
        }
    }
    @IBAction func btnSelectFolder(_ sender:UIButton){
          self.fileAction(Index: IndexPath(row: sender.tag, section: 0))
      }
    func fileAction(Index:IndexPath){
          let vc = storyBoards.Main.instantiateViewController(withIdentifier: "subFolderVC") as! subFolderVC
          vc.FolderId = self.arrFolderList[Index.row].id!
          //vc.data = data
          vc.FileId = self.FileId
          vc.navigationTitle = self.arrFolderList[Index.row].folder_name!
          vc.buttonName = self.buttonName
          self.navigationController?.pushViewController(vc, animated: true)
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("section",indexPath.section)
        if(indexPath.section == 0){
        let cell:collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! collCell
            cell.lblName.text = self.arrFolderList[indexPath.row].folder_name
            cell.btnOption.tag = indexPath.row
            cell.btnOption.addTarget(self, action: #selector(self.btnSelectFolder(_:)),for: .touchUpInside)
            return cell
        }
        else{
            let cell:collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as! collCell
                       cell.videoThumb.image = nil
                       cell.btnPlayvideo.tag = indexPath.row
                       cell.btnMap.tag = indexPath.row
                   //    cell.btnPlayvideo.addTarget(self, action: #selector(self.btnplayvideoClieck),for: .touchUpInside)
                       cell.btnOption.tag = indexPath.row
                      // cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
                     //  cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
                       cell.lblTitle.text = self.arrFileList[indexPath.row].image_name
                       cell.lblName.text = self.arrFileList[indexPath.row].name
                       if(arrFileList[indexPath.row].type == "image"){
                           cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
                           cell.videoThumb.sd_setImage(with: URL(string: arrFileList[indexPath.row].image_path!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                           cell.imgtype.image = #imageLiteral(resourceName: "ic_playimg")
                         }
                       else{
                           cell.imgtype.image = #imageLiteral(resourceName: "ic_playvid")
                           cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
                           cell.videoThumb.sd_setImage(with: URL(string: arrFileList[indexPath.row].thumb_image!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                       }
                       return cell
            }
        }
    
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
