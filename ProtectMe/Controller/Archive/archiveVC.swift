//
//  archiveVC.swift
//  ProtectMe
//
//  Created by Mac on 09/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
import MapKit
import Alamofire
import Photos

extension archiveVC:MKMapViewDelegate,NotifyToCallListService{
    func getListData() {
        WSArchiveList(Parameter: ["type":self.selectedType,"filter":selectedFilter])
    }
    
    
}

class archiveVC: baseVC {
    
    var timer = Timer()
    let att = appDelegate.ArrLocalVideoUploading.filter({$0.isUploaded == false})
   @IBOutlet weak var ViewCreateFolder:UIControl!
    @IBOutlet weak var tblVideoList:UITableView!
    @IBOutlet weak var collVideogrid:UICollectionView!
    @IBOutlet weak var Viewmap:UIView!
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
    var isFolderSelected:Bool = false
//Detail View
    @IBOutlet weak var lblDetailType:UILabel!
    @IBOutlet weak var lblDetailName:UILabel!
    @IBOutlet weak var lblDetailName1:UILabel!
    @IBOutlet weak var lblDetailName2:UILabel!

    @IBOutlet weak var lblDetailSize:UILabel!
    @IBOutlet weak var lblDetailStorageUsed:UILabel!
    @IBOutlet weak var lblDetailSharedBy:UILabel!
    @IBOutlet weak var lblDetailDateCreatedandLocation:UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtName:AIBaseTextField!{
        didSet{
        txtName.borderColor = .black
        txtName.borderWidth = 1.0
        txtName.leftViewPadding = 12
        txtName.validationType = .alphaNumeric_WithSpace
        //txtName.config.textFieldKeyboardType = .name
        }
    }
    var selectedType = "recent"
    var selectedFilter = "0"
    var arrselectedType = ["recent","folders","folders"]
    var arrarchivedList:[archivedListModel] = [archivedListModel]()
    var arrFolderList:[FolderListMOdel] = [FolderListMOdel]()

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
        self.scheduledTimerWithTimeInterval()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)

        arrOption = [btnRecent,btnFolders,btnShared]
        self.tblVideoList.delegate = self
        self.tblVideoList.dataSource = self
        self.collVideogrid.delegate = self
        self.collVideogrid.dataSource = self
        mapView.delegate = self

        self.tblVideoList.register(UINib(nibName: "VideoDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoDetailsTableViewCell")
        self.Viewmap.isHidden = true
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
        
    @IBAction func btnUserCurruntLocation(_ sender: UIButton) {
           mapView.userTrackingMode = .follow
       }
      
    @IBAction func btnDeleteArchiveClick(_ sender: UIControl) {
        if(self.isFolderSelected == true){
        }
        else{
        self.WSDeleteArchive(Parameter: ["id":self.arrarchivedList[self.selectedIndex!.row].id!])
        }
    }
        @IBAction func plusButtonAction(_ sender:UIButton){
            let status = PHPhotoLibrary.authorizationStatus()
            var acess:Bool = false
            if (status == PHAuthorizationStatus.authorized) {
                // Access has been granted.
                acess = true
            }

            else if (status == PHAuthorizationStatus.denied) {
                // Access has been denied.
                acess = false
                
    //
            }

            else if (status == PHAuthorizationStatus.notDetermined) {

                // Access has not been determined.
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        acess = true
                    }

                    else {
                        acess = false
                       
                    }
                })
            }

            else if (status == PHAuthorizationStatus.restricted) {
                // Restricted access - normally won't happen.
                acess = false
            }
            else{
                
            }
            if(acess == true){
                self.showAction()

            }
            else{
                 //showAlertWithTitleFromVC(vc: self, andMessage: "Please grant permition to acess camera roll!")
            }
            
            
            
            // handling code
        }
        func showAction(){
            
            if(self.isFolderSelected == true){
                showActionSheetWithTitleFromVC(vc: self, title:Constant.APP_NAME, andMessage: "Choose action", buttons: ["Create New Folder","Photo Album","Video Album"], canCancel: true) { (i) in
                    if(i == 0){
                        self.ViewCreateFolder.frame = UIScreen.main.bounds
                        self.navigationController?.view.addSubview(self.ViewCreateFolder)
                    }
                    else if(i == 1){
                        self.PhotoAlbum()
                        
                    }
                    else{
                    
                        self.VideoAlbum()
                    }
                 
                }
            }
            else{
            showActionSheetWithTitleFromVC(vc: self, title:Constant.APP_NAME, andMessage: "Choose action", buttons: ["Photo Album","Video Album"], canCancel: true) { (i) in
                if(i == 0){
                    self.PhotoAlbum()
                }
                else if(i == 1){
                    self.VideoAlbum()
                }
                else
                {
                }
            }
            }
        }

    func setPinUsingMKPlacemark(location: CLLocationCoordinate2D) {
        //let pin = MKPlacemark(coordinate: location)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.arrarchivedList[selectedIndex!.row].city! + ", " + self.arrarchivedList[selectedIndex!.row].country!
        annotation.subtitle = self.arrarchivedList[selectedIndex!.row].city! + ", " + self.arrarchivedList[selectedIndex!.row].country!
       let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.removeAnnotations(mapView.annotations)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
    @IBAction func btnMapShow(_ sender: UIButton) {
        self.selectedIndex = IndexPath(row: sender.tag, section: 0)
        DispatchQueue.main.async {
            
            let lat = Double((self.arrarchivedList[sender.tag].latitude?.toDouble())!)
            let lon = Double((self.arrarchivedList[sender.tag].longitude?.toDouble())!)
            let coordinates = CLLocationCoordinate2D(latitude:lat
                , longitude:lon)
            //        var locationManager = LocationManager.sharedInstance
            self.setPinUsingMKPlacemark(location: coordinates)
            self.Viewmap.isHidden = false

        }
    }
    @IBAction func btnmapHideClick(_ sender: UIButton) {
        self.Viewmap.isHidden = true
    }
    @IBAction func btnVideoDetails(_ sender: UIButton) {
        self.btnHandlerBlackBg(self)
        self.ViewVideoDetails.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewVideoDetails)
    }
    func setFoldersDetails(data:FolderListMOdel) -> Void {
        self.lblDetailName.text = data.folder_name
        self.lblDetailName1.text = data.folder_name
        self.lblDetailName2.text = data.folder_name

        self.lblDetailSize.text = "-"
        self.lblDetailType.text = "Folder"
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
    func setDetails(data:archivedListModel) -> Void {
        self.lblDetailName.text = data.image_name?.uppercased()
        self.lblDetailName1.text = data.image_name?.uppercased()
        self.lblDetailName2.text = data.image_name?.uppercased()

        self.lblDetailSize.text = data.file_size?.uppercased()
        if(data.type?.uppercased() == "VIDEO"){
            self.lblDetailType.text = (data.type?.uppercased())! + " (MP4)"
        }
        else{
            self.lblDetailType.text = (data.type?.uppercased())! + " (JPG)"

        }
        if(data.user_id == USER.shared.id){
            self.lblDetailSharedBy.text = "YOU"
        }
        else{
            self.lblDetailSharedBy.text = "-"
        }
        self.lblDetailStorageUsed.text = "-"
        let date = data.created?.uppercased()
        let city = data.city?.uppercased()
        let country = data.country?.uppercased()
        self.lblDetailDateCreatedandLocation.text = (date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getyyyMMdd())! + " - " + city! + ", " + country!

        print()
        
    }
    @IBAction func btnplayofflineVideo(_ sender: UIButton) {
        
        let videoURL =  appDelegate.ArrLocalVideoUploading[sender.tag].url!
        let player = AVPlayer(url: videoURL)
               let vc = AVPlayerViewController()
               vc.player = player

               present(vc, animated: true) {
                   vc.player?.play()
               }
        }
    
    @IBAction func btnplayvideoClieck(_ sender: UIButton) {
        if(arrarchivedList[sender.tag].type == "image"){
              let vc = storyBoards.Main.instantiateViewController(withIdentifier: "imgviewwerVC") as! imgviewwerVC
                  vc.imgforview = self.arrarchivedList[sender.tag].image_path!
                  
                  self.present(vc, animated: true, completion: nil)
        }
        else{
        let videoURL = URL(string: self.arrarchivedList[sender.tag].image_path!)
               let player = AVPlayer(url: videoURL!)
               let vc = AVPlayerViewController()
               vc.player = player

               present(vc, animated: true) {
                   vc.player?.play()
               }
        }
    }
    func downloadVideoToPhotos(url:String){
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        var headers: HTTPHeaders = [:]//
        
            let apitocken = USER.shared.vAuthToken
            headers = ["Accept":"application/json","Vauthtoken":"Bearer " + apitocken]
        
                  
        Alamofire.download(
         url,
         method: .get,
         parameters: [:],
         encoding: JSONEncoding.default,
         headers: headers,
         to: destination).downloadProgress(closure: { (progress) in
             //progress closure
         }).response(completionHandler: { (DefaultDownloadResponse) in
             //here you able to access the DefaultDownloadResponse
             //result closure
         })
    }
    func downloadVideoLinkAndCreateAsset(_ videoLink: String) {
        appDelegate.SHOW_CUSTOM_LOADER()
           // use guard to make sure you have a valid url
           guard let videoURL = URL(string: videoLink) else { return }

           guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

           // check if the file already exist at the destination folder if you don't want to download it twice
           if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {

               // set up your download task
               URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in

                   // use guard to unwrap your optional url
                   guard let location = location else { return }

                   // create a deatination url with the server response suggested file name
                   let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)

                   do {

                       try FileManager.default.moveItem(at: location, to: destinationURL)

                       PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in

                           // check if user authorized access photos for your app
                           if authorizationStatus == .authorized {
                               PHPhotoLibrary.shared().performChanges({
                                   PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                    appDelegate.HIDE_CUSTOM_LOADER()

                                       if completed {
                                        print("Video asset created")
                                        showAlertWithTitleFromVC(vc: self, andMessage: "File saved to photos")

                                        
//                                        appDelegate.HIDE_CUSTOM_LOADER()
                                       } else {
                                           print(error)
  //                                      appDelegate.HIDE_CUSTOM_LOADER()
                                       }
                               }
                           }
                       })

                   } catch { print(error)
                    appDelegate.HIDE_CUSTOM_LOADER()
                }

               }.resume()
            appDelegate.HIDE_CUSTOM_LOADER()


           } else {
            appDelegate.HIDE_CUSTOM_LOADER()
            showAlertWithTitleFromVC(vc: self, andMessage: "File already exists")

               print("File already exists at destination url")
           }
        appDelegate.HIDE_CUSTOM_LOADER()


       }
    @IBAction func btnShareVideoURL(_ sender: UIButton) {
        //Set the default sharing message.
        let message = "Please check this video link"
        //Set the link to share.
        if let link = NSURL(string: self.arrarchivedList[self.selectedIndex!.row].thumb_image!)
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func writeToFile(urlString: String) {

       guard let videoUrl = URL(string: urlString) else {
           return
       }

       do {

           let videoData = try Data(contentsOf: videoUrl)

           let fm = FileManager.default

           guard let docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
               print("Unable to reach the documents folder")
               return
           }

           let localUrl = docUrl.appendingPathComponent("test.mp4")

           try videoData.write(to: localUrl)

       } catch  {
           print("could not save data")
       }
    }
    @IBAction func btnDownloadVideo(_ sender: UIButton) {
        let url = self.arrarchivedList[self.selectedIndex!.row].image_path
    //    self.downloadVideoToPhotos(url:url! )
        //self.writeToFile(urlString: url!)
        self.downloadVideoLinkAndCreateAsset(url!)
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
        self.selectedIndex = IndexPath(row: sender.tag, section: 0)
        if(self.isFolderSelected == true){
            self.setFoldersDetails(data:self.arrFolderList[sender.tag])

        }
        else{
            self.setDetails(data:self.arrarchivedList[sender.tag])

        }
        self.ViewOptionMenu.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewOptionMenu)
    }
    @IBAction func btnhideDetails(_ sender: Any)
    {
        self.ViewVideoDetails.removeFromSuperview()
        self.ViewCreateFolder.removeFromSuperview()
    }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        self.ViewOptionMenu.removeFromSuperview()
    }
    @IBAction func btnChangeRename(_ sender: Any)
    {
        if(self.isFolderSelected == false){

        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
        OBJchangepasswordVC.titleString = "File Name"
        OBJchangepasswordVC.FieldType = "video"
        OBJchangepasswordVC.fileID = self.arrarchivedList[selectedIndex!.row].id!
        let firstPart = self.arrarchivedList[selectedIndex!.row].image_name!.strstr(needle: ".", beforeNeedle: true)
        print(firstPart) // print Hello
        OBJchangepasswordVC.txtValue = firstPart ??  self.arrarchivedList[selectedIndex!.row].image_name!
        
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
        self.btnChangeTableView(self.btnGreed)
        self.btnSelectOptions(self.btnRecent)
        txtName.borderColor = .black
        txtName.borderWidth = 1.0
        //let monthname = Date().getMonthFullname()
        //let year = Date().getYear()
        lblMonthandYear.text = "Recent"
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
        WSArchiveList(Parameter: ["type":self.selectedType,"filter":selectedFilter])

    }
    @IBAction func btnSelectOptions(_ sender: UIButton) {
        self.selectOptions(selected: sender)
    }
    func selectOptions(selected:UIButton)  {
        for btn in arrOption{
            
            if(btn == selected){
                self.isFolderSelected = false
                if(btn == self.btnRecent){
                    self.selectedType = "recent"
                }
                else if(btn == self.btnFolders){
                    self.selectedType = "folders"
                    self.isFolderSelected = true
                }
                else{
                    self.selectedType = "shared"
                    
                }
                btn.setTitleColor(UIColor.clrSkyBlue, for: .normal)
                
            }
            else{
                btn.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
//        if(self.isFolderSelected == true){
//            self.WSFolderList(Parameter: [:])
//        }
//        else{
            self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":selectedFilter])
        //}

    }
    
    // MARK: - WEB Service
    func WSCreateFolder(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .create_folder, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.btnhideDetails(self)
                    self.WSFolderList(Parameter: [:])
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
    func WSFolderList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .folderList, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let outcome = dataResponce["data"] as? [NSDictionary]{
                         self.arrFolderList.removeAll()
                        for a : Int in (0..<(outcome.count))
                        {
                            let objarchivedList : FolderListMOdel = FolderListMOdel()
                            objarchivedList.created      = outcome[a]["created"] as? String ?? ""
                            objarchivedList.folder_name  = outcome[a]["folder_name"] as? String ?? ""
                            objarchivedList.id           = outcome[a]["id"] as? String ?? ""
                            objarchivedList.updated      = outcome[a]["updated"] as? String ?? ""
                            objarchivedList.user_id      = outcome[a]["user_id"] as? String ?? ""
                            objarchivedList.name      = outcome[a]["name"] as? String ?? ""
                            self.arrFolderList.append(objarchivedList)
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
    func WSDeleteArchive(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .delete_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.btnHandlerBlackBg(self)
                    self.btnhideDetails(self)
                    self.btnSelectOptions(self.btnRecent)

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
    func WSArchiveList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .archived_list, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
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
                            objarchivedList.longitude     = outcome[a]["latitude"] as? String ?? ""
                            objarchivedList.latitude    = outcome[a]["longitude"] as? String ?? ""
                            objarchivedList.state        = outcome[a]["state"] as? String ?? ""
                            objarchivedList.status       = outcome[a]["status"] as? String ?? ""
                            objarchivedList.type         = outcome[a]["type"] as? String ?? ""
                            objarchivedList.updated      = outcome[a]["updated"] as? String ?? ""
                            objarchivedList.user_id      = outcome[a]["user_id"] as? String ?? ""
                            objarchivedList.name      = outcome[a]["name"] as? String ?? ""
                            objarchivedList.thumb_image      = outcome[a]["thumb_image"] as? String ?? ""

                            self.arrarchivedList.append(objarchivedList)
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
extension archiveVC:sendbacktoName{
    func changename(name: String, index: IndexPath) {
        
    }
}

extension archiveVC:UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
            if(section == 0){
                 
                return appDelegate.ArrLocalVideoUploading.count
            }
            else{
                return self.arrarchivedList.count
            }

    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(self.isFolderSelected == true){
            
        }
        else{
            if(indexPath.section == 0){
                let videoURL =  appDelegate.ArrLocalVideoUploading[indexPath.row].url!
                let player = AVPlayer(url: videoURL)
                       let vc = AVPlayerViewController()
                       vc.player = player

                       present(vc, animated: true) {
                           vc.player?.play()
                       }

            }
            else{
            if(self.arrarchivedList[indexPath.row].type?.lowercased() == "image")
            {
                
            }
            else{
                let videoURL = URL(string: self.arrarchivedList[indexPath.row].image_path!)
                       let player = AVPlayer(url: videoURL!)
                       let vc = AVPlayerViewController()
                       vc.player = player

                       present(vc, animated: true) {
                           vc.player?.play()
                       }

            }

            }
            
        }
    }
    @objc func loadList(notification: NSNotification) {
        self.selectOptions(selected: self.btnRecent)
    }

    func stopTimer() {
        timer.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
     //   timerDispatchSourceTimer?.cancel()
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.reloadcell), userInfo: nil, repeats: true)
    }
    @objc func reloadcell(){
        self.collVideogrid.reloadSections(NSIndexSet(index: 0) as IndexSet)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0){
            let cell:collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! collCell
                cell.videoThumb.image = nil
            
            cell.lblTitle.text = appDelegate.ArrLocalVideoUploading[indexPath.row].name ?? ""
            cell.lblName.text = USER.shared.name
            cell.videoThumb.image = appDelegate.ArrLocalVideoUploading[indexPath.row].thumbImage
//            appDelegate.ArrLocalVideoUploading.filter({$0.isUploaded == false})
            cell.progressBar.progress = Float(appDelegate.ArrLocalVideoUploading[indexPath.row].progress)
            cell.btnPlayvideo.tag = indexPath.row
            cell.btnPlayvideo.addTarget(self, action: #selector(self.btnplayofflineVideo(_:)),for: .touchUpInside)

           // cell.progressBar.setProgress(Float(appDelegate.ArrLocalVideoUploading[indexPath.row].progress), animated: true)
//            if(appDelegate.ArrLocalVideoUploading[indexPath.row].progress == 1.0){
//                self.stopTimer()
//            }
            return cell
        }
        else{
        

        
        if(self.isFolderSelected == true){
        let cell:FolderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
            cell.lblName.text = self.arrarchivedList[indexPath.row].folder_name
            cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)


            return cell

        }
        else{
        let cell:collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! collCell
            cell.videoThumb.image = nil
            
            
            
            
            cell.btnPlayvideo.tag = indexPath.row
            cell.btnMap.tag = indexPath.row
            cell.btnPlayvideo.addTarget(self, action: #selector(self.btnplayvideoClieck),for: .touchUpInside)

            cell.btnOption.tag = indexPath.row
            cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
            cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
            cell.lblTitle.text = self.arrarchivedList[indexPath.row].image_name
            cell.lblName.text = self.arrarchivedList[indexPath.row].name
//            cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].image_path!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
        if(arrarchivedList[indexPath.row].type == "image"){
                  cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
                  cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].image_path!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                cell.imgtype.image = #imageLiteral(resourceName: "ic_playimg")
                  
              }
              else{
            cell.imgtype.image = #imageLiteral(resourceName: "ic_playvid")
            cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].thumb_image!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
            //            let url:URL = URL(string: arrarchivedList[indexPath.row].image_path ?? "")!
//            AVAsset(url: url).generateThumbnail { [weak self] (image) in
//                DispatchQueue.main.async {
//                    guard let image = image else { return }
//                    cell.videoThumb.image = image
//                    cell.videoThumb.sd_imageIndicator?.stopAnimatingIndicator()
//                }
//            }
              //cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                      self.getThumbnailFromUrl(arrarchivedList[indexPath.row].image_path) { (image) in
//                       //Use image where you want to use
//                         cell.videoThumb.image = image
//                  }
        }
            return cell

                }
                

        }

    }
    
}
extension archiveVC:UICollectionViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.isFolderSelected == true){
            return self.arrFolderList.count
        }
        else{
            return self.arrarchivedList.count
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.isFolderSelected == true){
        }
        else{
        if(self.arrarchivedList[indexPath.row].type?.lowercased() == "image")
        {
            
        }
        else{
        let videoURL = URL(string: self.arrarchivedList[indexPath.row].image_path!)
        let player = AVPlayer(url: videoURL!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
        }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.isFolderSelected == true){
        let cell:VideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsTableViewCell", for: indexPath) as! VideoDetailsTableViewCell
        cell.videoThumb.image = #imageLiteral(resourceName: "ic_folder")
        cell.selectionStyle = .none
        cell.btnMap.isHidden = true
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
        cell.lblTitle.text = self.arrFolderList[indexPath.row].folder_name
        cell.lblName.text = ""
        cell.imgType.image = nil
        return cell
        }
        else{
        let cell:VideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsTableViewCell", for: indexPath) as! VideoDetailsTableViewCell
        cell.videoThumb.image = nil
        cell.selectionStyle = .none
        cell.btnMap.tag = indexPath.row
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
        cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
        cell.lblTitle.text = self.arrarchivedList[indexPath.row].image_name
        cell.lblName.text = self.arrarchivedList[indexPath.row].name
        
        if(arrarchivedList[indexPath.row].type == "image"){
            cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].image_path!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
            cell.imgType.image = #imageLiteral(resourceName: "ic_playimg")
        }
        else{
            cell.imgType.image = #imageLiteral(resourceName: "ic_playvid")
            cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].thumb_image!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
//            let url:URL = URL(string: arrarchivedList[indexPath.row].image_path!)!
//                  AVAsset(url: url).generateThumbnail { [weak self] (image) in
//                                 DispatchQueue.main.async {
//                                     guard let image = image else { return }
//                                     cell.videoThumb.image = image
//                                    cell.videoThumb.sd_imageIndicator?.stopAnimatingIndicator()
//                                 }
//                             }
        }
        return cell
        }
    }
    
   
}
class FolderCell: UICollectionViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var btnOption:UIButton!
}
class collCell: UICollectionViewCell {
    @IBOutlet weak var btnMap:UIButton!
    @IBOutlet weak var videoThumb:UIImageView!
    @IBOutlet weak var imgtype:UIImageView!
    @IBOutlet weak var progressBar:UIProgressView!{
        didSet{
            progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        }
    }

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var btnPlayvideo:UIButton!

    @IBOutlet weak var btnOption:UIButton!
}
extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
