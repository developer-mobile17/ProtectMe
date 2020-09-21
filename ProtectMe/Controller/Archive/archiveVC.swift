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
import CameraRoll
import MobileCoreServices


import Toast_Swift


extension archiveVC:MKMapViewDelegate{
    
    
    func getListData() {
        WSArchiveList(Parameter: ["type":self.selectedType,"filter":selectedFilter])
    }
}

class archiveVC:downloadfolder,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let controller = UIImagePickerController()


    var timer = Timer()
    let att = appDelegate.ArrLocalVideoUploading.filter({$0.isUploaded == false})
    @IBOutlet weak var tblVideoList:UITableView!
    @IBOutlet weak var collVideogrid:UICollectionView!
    @IBOutlet weak var Viewmap:UIView!
    @IBOutlet weak var SharedBy:UIControl!
    @IBOutlet weak var NumberofFiles:UIControl!
    @IBOutlet weak var Viewrename:UIControl!

    @IBOutlet weak var VideoDuration:UIControl!
    @IBOutlet weak var lblVideoDuration:UILabel!
    @IBOutlet weak var ViewVideoDetails:UIControl!
    @IBOutlet weak var ViewOptionMenu:UIControl!
    @IBOutlet weak var ViewFolderOptionMenu:UIControl!

    @IBOutlet weak var ViewdeleteConfirmation:UIControl!
    @IBOutlet weak var ViewDownloadCompleted:UIControl!
    @IBOutlet weak var ViewCreateFolder:UIControl!
    
    @IBOutlet weak var btncheckboxAgree:UIButton!
    @IBOutlet weak var btnOkayAgree:UIButton!
    @IBOutlet weak var btnRecent:UIButton!
    @IBOutlet weak var btnFilter:UIButton!
    @IBOutlet weak var btnPlus:UIButton!

    @IBOutlet weak var btnSemiFilter:UIButton!
    @IBOutlet weak var btnGreed:UIButton!
    @IBOutlet weak var btnlist:UIButton!
    @IBOutlet weak var lblMonthandYear:UILabel!{
        didSet{
            lblMonthandYear.text = ""
        }
    }
    var uploadImage:Bool = false
    var selectedIndex:IndexPath? = nil
    var isFolderSelected:Bool = false
//Detail View
    @IBOutlet weak var lblFolderName:UILabel!
    @IBOutlet weak var lblNuberofFiles:UILabel!

    @IBOutlet weak var lblDetailType:UILabel!
    @IBOutlet weak var lblDetailName:UILabel!
    @IBOutlet weak var lblDetailName1:UILabel!
    @IBOutlet weak var lblDetailName2:UILabel!

    @IBOutlet weak var lblDetailSize:UILabel!
    @IBOutlet weak var lblDetailStorageUsed:UILabel!
    @IBOutlet weak var lblDetailSharedBy:UILabel!
    @IBOutlet weak var lblDateCreatedandLocation:UILabel!

    @IBOutlet weak var lblDetailDateCreatedandLocation:UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtName:AIBaseTextField!{
        didSet{
            txtName.leftViewPadding = 12
        }
    }
    
    
    
    var videoRecorded: URL? = nil
     var unique_idforFile = ""
//     weak var delegate: NotifyToCallListService?
     var Baseunique_id = ""
     var isLocationEnable = USER.shared.location_service.StrTobool

     let imgPickerController = UIImagePickerController()
     var selectedImage:UIImage?
     let titleName = "Photos"
     var videoURL : NSURL?
     var latitude:Double = 0.0
     var longitude:Double = 0.0
       let locationManager = LocationManager.sharedInstance
    let accetm = AssetManager.sharedInstance
    var selectedButton:UIButton?
    var selectedType = "recent"
    var selectedView = USER.shared.selectedView
    var selectedFilter = USER.shared.selectedFilter
    var arrselectedType = ["recent","folders","folders"]
    var arrarchivedList:[archivedListModel] = [archivedListModel]()
    var arrFolderList:[FolderListMOdel] = [FolderListMOdel]()
    var semiFilter = USER.shared.selectedSubFilter
    var sectionIsExpanded = true
        
    
    var checkBoxAction: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                if self.checkBoxAction {
                    self.btncheckboxAgree.setImage(#imageLiteral(resourceName: "ic_checkbox"), for: .normal)
                } else {
                    self.btncheckboxAgree.setImage(#imageLiteral(resourceName: "ic_checkboxblank"), for: .normal)
                }
            }
        }
    }
    @IBOutlet weak var btnFolders:UIButton!
    @IBOutlet weak var btnShared:UIButton!
    var arrOption = [UIButton]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgPickerController.delegate = self
        controller.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadList(notification:)), name: NSNotification.Name(rawValue: "download"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadCan(notification:)), name: NSNotification.Name(rawValue: "downloadcan"), object: nil)


        arrOption = [btnRecent,btnFolders,btnShared]
        self.tblVideoList.delegate = self
        self.tblVideoList.dataSource = self
        self.collVideogrid.delegate = self
        self.collVideogrid.dataSource = self
        self.scheduledTimerWithTimeInterval()
        self.btnHandlerBlackBg(self)
        //self.btnChangeTableView(self.btnGreed)
        //self.btnSelectOptions(self.btnRecent)
              
        mapView.delegate = self
        self.tblVideoList.register(UINib(nibName: "uploadTableViewCell", bundle: nil), forCellReuseIdentifier: "uploadTableViewCell")
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
    
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
           let vc = storyBoards.Main.instantiateViewController(withIdentifier: "searchVC") as! searchVC
        navigationController?.pushViewController(vc, animated: true)
       }

    @IBAction func btnUserCurruntLocation(_ sender: UIButton) {
           mapView.userTrackingMode = .follow
       }
      
    @IBAction func btnDeleteArchiveClick(_ sender: UIControl) {
        if(self.isFolderSelected == true){
            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME
                       , andMessage: "Are you sure you want to delete?", buttons: ["Yes","Cancel"]) { (index) in
                           if(index == 0){
                               self.WSDeleteFolder(Parameter: ["id":self.arrarchivedList[self.selectedIndex!.row].id!])
                           }
                       }
        }
        else{
            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME
            , andMessage: "Are you sure you want to delete?", buttons: ["Yes","Cancel"]) { (index) in
                if(index == 0){
                    self.WSDeleteArchive(Parameter: ["type":"1","id":self.arrarchivedList[self.selectedIndex!.row].id!])
                }
            }
            
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
                showActionSheetWithTitleFromVC(vc: self, title:Constant.APP_NAME, andMessage: "Choose action", buttons: ["Create New Folder"], canCancel: true) { (i) in
                    if(i == 0){
                        self.txtName.Round = true
                        self.txtName.borderColor = .black
                        self.txtName.borderWidth = 1.0
                        self.ViewCreateFolder.frame = UIScreen.main.bounds
                        self.navigationController?.view.addSubview(self.ViewCreateFolder)
                    }
                        //,"Photo Album","Video Album"
//                    else if(i == 1){
//                        self.uploadImage = true
//
//                        self.PhotoAlbum()
//
//                    }
//                    else if(i == 2){
//                        self.uploadImage = false
//                        self.VideoAlbum()
//                    }
                    else{
                        
                    }
                 
                }
            }
            else{
            showActionSheetWithTitleFromVC(vc: self, title:Constant.APP_NAME, andMessage: "Choose action", buttons: ["Photo Album","Video Album"], canCancel: true) { (i) in
                if(i == 0){
                    self.PhotosFromAlbum()
                }
                else if(i == 1){
                    self.VideoFromAlbum()
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
        self.lblDetailDateCreatedandLocation.text = (date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getyyyMMdd())!
        print()
        
    }
    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00:00"
        }
        let Min = Int(seconds / 60)
        let Hours:Int = Min/60

        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d:%02d",Hours, Min, Sec)
    }
    func setFolderDetails(data:archivedListModel) -> Void {
        self.lblFolderName.text = data.folder_name?.uppercased()
        self.lblDetailName.text = data.folder_name?.uppercased()
        self.lblDetailName1.text = data.folder_name?.uppercased()
        self.lblDetailName2.text = data.folder_name?.uppercased()
        self.lblDetailSize.text = data.total_size
        self.lblDetailType.text = "Folder"
        self.VideoDuration.isHidden = true
        self.SharedBy.isHidden = true
        self.NumberofFiles.isHidden = false
        self.lblNuberofFiles.text = data.number_of_files


        if(data.user_id == USER.shared.id){
            self.lblDetailSharedBy.text = "YOU"
        }
        else{
            self.lblDetailSharedBy.text = data.uploaded_by
        }
        self.lblDetailStorageUsed.text = data.storage_used
        let date = data.created?.uppercased()
        
        self.lblDateCreatedandLocation.text = "DATE CREATED"
        self.lblDetailDateCreatedandLocation.text = (date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getyyyMMdd())!

        
    }
    func setDetails(data:archivedListModel) -> Void {
        APPDELEGATE.SHOW_CUSTOM_LOADER()
        self.lblDetailName.text = data.image_name?.uppercased()
        self.lblDetailName1.text = data.image_name?.uppercased()
        self.lblDetailName2.text = data.image_name?.uppercased()
        self.lblDetailSize.text = data.file_size?.uppercased()
        self.SharedBy.isHidden = false
        self.NumberofFiles.isHidden = true
        if(data.type?.uppercased() == "VIDEO"){
            let asset = AVURLAsset(url: URL(string: data.image_path!)!)
                   let durationInSeconds = asset.duration.seconds
                  
            self.lblDetailType.text = (data.type?.uppercased())! + " (MP4)"
            self.VideoDuration.isHidden = false
            
            let s = formatSecondsToString(durationInSeconds)
            self.lblVideoDuration.text = s
        }
        else{
            self.lblDetailType.text = (data.type?.uppercased())! + " (JPG)"
            self.VideoDuration.isHidden = true

        }
        if(data.user_id == USER.shared.id){
            self.lblDetailSharedBy.text = "YOU"
        }
        else{
            self.lblDetailSharedBy.text = data.uploaded_by
        }
        self.lblDetailStorageUsed.text = "-"
        let date = data.created?.uppercased()
        let city = data.city?.uppercased()
        let country = data.country?.uppercased()
        self.lblDateCreatedandLocation.text = "DATE CREATED & LOCATION"
        self.lblDetailDateCreatedandLocation.text = (date?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getyyyMMdd())! + " - " + city! + ", " + country!
APPDELEGATE.HIDE_CUSTOM_LOADER()
    }
    func fileAction(action:String){
        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "driveVC") as! driveVC
        vc.buttonName = action
        vc.isThreeDotVible = false
        vc.FileId = self.arrarchivedList[self.selectedIndex!.row].id!
        vc.data = self.arrarchivedList[self.selectedIndex!.row]
        vc.buttonName = action
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnMoveAction(_ sender: UIButton) {
        //self.selectedIndex?.row = sender.tag
        self.fileAction(action: "  Add  ")
    }

    @IBAction func btnCopyAction(_ sender: UIButton) {
        //self.selectedIndex?.row = sender.tag
        self.fileAction(action: "Copy")
    }
    @IBAction func btnplayofflineVideo(_ sender: UIButton) {
        
        if let videoURL =  appDelegate.ArrLocalVideoUploading[sender.tag].url{
        let player = AVPlayer(url: videoURL)
               let vc = AVPlayerViewController()
        
               vc.player = player

               present(vc, animated: true) {
                   vc.player?.play()
               }
        }
    }
    
    func getVideo(){

        let videoURL = URL(string: "http://fitnation.theclientdemos.com:9000/media/uploads/videoplayback_3_JtVCHi1")
        // Create an AVAsset
        let videoAsset = AVAsset(url: videoURL!)
        // Create an AVPlayerItem with asset
        let videoPlayerItem = AVPlayerItem(asset: videoAsset)
        // Initialize player with the AVPlayerItem instance.
        let player = AVPlayer(playerItem: videoPlayerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    @IBAction func btnplayvideoClieck(_ sender: UIButton) {
        if(self.isFolderSelected == true){
            let vc = storyBoards.Main.instantiateViewController(withIdentifier: "subFolderVC") as! subFolderVC
                  vc.FolderId = self.arrarchivedList[sender.tag].id!
                  vc.data = self.arrarchivedList[sender.tag]
            vc.FileId = self.arrarchivedList[sender.tag].folder_id!
                  vc.navigationTitle = self.arrarchivedList[sender.tag].folder_name!
                  vc.buttonName = ""
                  self.navigationController?.pushViewController(vc, animated: true)
        }
        else{

        if(arrarchivedList[sender.tag].type == "image"){
              let vc = storyBoards.Main.instantiateViewController(withIdentifier: "imgviewwerVC") as! imgviewwerVC
                  vc.imgforview = self.arrarchivedList[sender.tag].image_path!
                  
                  self.present(vc, animated: true, completion: nil)
        }
        else{
            guard let url = URL(string:self.arrarchivedList[sender.tag].image_path!) else {
                return
            }
            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//            if(url.isFileURL == false){
//                showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Can't play this video", buttons: ["Opent in Safari","Cancel"]) { (i) in
//                    if i == 0{
//                        guard let url1 = URL(string:self.arrarchivedList[sender.tag].image_path!) else { return }
//                        UIApplication.shared.open(url1)
//                    }
//                }
//                //showAlert(title: "sel", message: "dasda")
//            }
            print("playing video :",self.arrarchivedList[sender.tag].image_path)
            
            let q = NSURL(string: self.arrarchivedList[sender.tag].image_path!)
            let url1 = URL(string:self.arrarchivedList[sender.tag].image_path!)
            let videoAsset = AVAsset(url: url1!)
            // Create an AVPlayerItem with asset
            let videoPlayerItem = AVPlayerItem(asset: videoAsset)
            // Initialize player with the AVPlayerItem instance.
            let player = AVPlayer(playerItem: videoPlayerItem)
            let playerLayer = AVPlayerLayer(player: player)
            
            //let player = AVPlayer(url: url)
            // Create a new AVPlayerViewController and pass it a reference to the player.
            let controller = AVPlayerViewController()
            
            
            controller.player = player

            // Modally present the player and call the player's play() method when complete.
            present(controller, animated: true) {
                player.play()
            }
            
//            let videoURL = URL(string: self.arrarchivedList[sender.tag].image_path!)
//               let player = AVPlayer(url: videoURL!)
//
//               let vc = AVPlayerViewController()
//               vc.player = player
//
//               present(vc, animated: true) {
//                   vc.player?.play()
//               }
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
        DispatchQueue.main.async {
            self.btnhideDetails(self)
            self.btnHandlerBlackBg(self)
        }
        UIPasteboard.general.string = ServiceManager.shared.deeplink + self.arrarchivedList[self.selectedIndex!.row].image_path!

        self.view.makeToast("URL Copied", duration: 1.5, position: .bottom)
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
    
    @IBAction func btnDownloadFolder(_ sender: Any) {
        //self.DownloadAndSave(urlString: "http://www.africau.edu/images/default/sample.pdf")
        let folderid = self.arrarchivedList[self.selectedIndex!.row].id
        let folderName = self.arrarchivedList[self.selectedIndex!.row].folder_name!

        self.getfilelist(folderid: folderid!, foldername: folderName)
    }
    @IBAction func btnDownloadVideo(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.ViewOptionMenu.removeFromSuperview()
            self.ViewFolderOptionMenu.removeFromSuperview()
            self.view.makeToast("Downloaded Started", duration: 1.0, position: .bottom)

        if(self.arrarchivedList[self.selectedIndex!.row].type?.lowercased() == "image"){
            if let urlString = self.arrarchivedList[self.selectedIndex!.row].image_path{

                ServiceManager.shared.callDownloadFile(WithType: .add_linked_account, fileUrl: urlString, WithParams: ["type":"image"], Progress: { (progress) in
                    self.ViewOptionMenu.removeFromSuperview()
                    self.ViewFolderOptionMenu.removeFromSuperview()


                    print(progress)
                }, Success: { (DataResponce, Status, Message) in
                    print("downloaded")
                    print("URL", Message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.view.makeToast("Downloaded Completed", duration: 1.0, position: .bottom)
                    }
                    DispatchQueue.main.async(execute: {
                    self.btnHandlerBlackBg(self)
//                    self.ViewDownloadCompleted.frame = UIScreen.main.bounds
                    //self.navigationController?.view.addSubview(self.ViewDownloadCompleted)
                    })
                }) { (DataResponce, Status, Message) in
                    print("faild download")
                }
                
                
        }
                
        
    }
    else{
            if let urlString = self.arrarchivedList[self.selectedIndex!.row].image_path{

            ServiceManager.shared.callDownloadFile(WithType: .add_linked_account, fileUrl: urlString, WithParams: ["type":"video"], Progress: { (progress) in
                print(progress)
                self.ViewOptionMenu.removeFromSuperview()
                self.ViewFolderOptionMenu.removeFromSuperview()
                //self.view.makeToast("Downloaded Started", duration: 1.0, position: .bottom)

            }, Success: { (DataResponce, Status, Message) in
                print("downloaded")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.view.makeToast("Downloaded Completed", duration: 1.0, position: .bottom)
                }
                print("URL", Message)
                DispatchQueue.main.async(execute: {

                self.btnHandlerBlackBg(self)
                //self.ViewDownloadCompleted.frame = UIScreen.main.bounds
                //self.navigationController?.view.addSubview(self.ViewDownloadCompleted)
                                  
                })
            }) { (DataResponce, Status, Message) in
                print("faild download")
            }
            }
//            let url = self.arrarchivedList[self.selectedIndex!.row].image_path
//            self.downloadVideoLinkAndCreateAsset(url!)

        }
        }
    }
    
    @IBAction func btncelltapClick(_ sender: UIButton) {

    let vc = storyBoards.Main.instantiateViewController(withIdentifier: "subFolderVC") as! subFolderVC
    vc.FolderId = self.arrarchivedList[sender.tag].id!
    vc.data = self.arrarchivedList[sender.tag]
    vc.FileId = self.arrarchivedList[sender.tag].folder_id!
        vc.navigationTitle = self.arrarchivedList[sender.tag].folder_name!
        
              vc.buttonName = ""
                    self.navigationController?.pushViewController(vc, animated: true)
    }
    func showAlertFolrDeleted(){
        self.ViewdeleteConfirmation.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewdeleteConfirmation)
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
       self.selectedIndex = IndexPath(row: sender.tag, section: 0)
       self.setDetails(data:self.arrarchivedList[sender.tag])
        self.ViewOptionMenu.frame = UIScreen.main.bounds
        if(self.arrarchivedList[selectedIndex!.row].user_id == USER.shared.id){
            self.Viewrename.isHidden = false
        }
        else{
            self.Viewrename.isHidden = true
        }
        self.navigationController?.view.addSubview(self.ViewOptionMenu)
    }
    @IBAction func btnFolderOptionMenuClick(_ sender: UIButton) {
        
        self.ViewOptionMenu.removeFromSuperview()
        self.selectedIndex = IndexPath(row: sender.tag, section: 0)
           self.setFolderDetails(data:self.arrarchivedList[sender.tag])
           self.ViewFolderOptionMenu.frame = UIScreen.main.bounds
           self.navigationController?.view.addSubview(self.ViewFolderOptionMenu)
       }
    @IBAction func btnhideDetails(_ sender: Any)
    {
        self.ViewDownloadCompleted.removeFromSuperview()
        self.ViewVideoDetails.removeFromSuperview()
        self.ViewCreateFolder.removeFromSuperview()
    }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        UIView.animate(withDuration: 0.2, animations: {self.ViewFolderOptionMenu.alpha = 0.0},
                 completion: {(value: Bool) in
                   self.ViewFolderOptionMenu.alpha = 1.0
                   self.ViewFolderOptionMenu.removeFromSuperview()
               })
        UIView.animate(withDuration: 0.2, animations: {self.ViewOptionMenu.alpha = 0.0},
          completion: {(value: Bool) in
            self.ViewOptionMenu.alpha = 1.0
            self.ViewOptionMenu.removeFromSuperview()
        })
        //self.ViewOptionMenu.removeFromSuperview()
    }
    @IBAction func btnChangeRename(_ sender: Any)
    {
        if(self.isFolderSelected == false){

        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
        OBJchangepasswordVC.titleString = "File Name"
        OBJchangepasswordVC.FieldType = "video"
        OBJchangepasswordVC.selectedView = self.selectedView
        OBJchangepasswordVC.fileID = self.arrarchivedList[selectedIndex!.row].id!
        let firstPart = self.arrarchivedList[selectedIndex!.row].image_name!.strstr(needle: ".", beforeNeedle: true)
        OBJchangepasswordVC.txtValue = firstPart ??  self.arrarchivedList[selectedIndex!.row].image_name!
        
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
        else{
            let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
                  OBJchangepasswordVC.titleString = "Folder Name"
                  OBJchangepasswordVC.FieldType = "folder"
                OBJchangepasswordVC.selectedView = self.selectedView
                  OBJchangepasswordVC.fileID = self.arrarchivedList[selectedIndex!.row].id!
                  let firstPart = self.arrarchivedList[selectedIndex!.row].folder_name
            OBJchangepasswordVC.txtValue = firstPart!
                  self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
    }
    func setInitialView(){
        self.semiFilter = USER.shared.selectedSubFilter
        self.selectedView = USER.shared.selectedView
        if(selectedView == "grid"){
            self.btnChangeTableView(self.btnGreed)
        }
        else{
            self.btnChangeTableView(self.btnlist)
        }
        //semiFilter
        
        if(USER.shared.selectedSubFilter == "1"){
            let img = UIImage(named: "ic_down" )
            self.semiFilter = "1"
            self.sectionIsExpanded = true
            
            self.btnSemiFilter.setImage( img , for:  .normal)
        }
        else{
            let img = UIImage(named:"ic_down")?.rotate(radians: Float(CGFloat.pi))
            self.btnSemiFilter.setImage( img , for:  .normal)
            self.semiFilter = "0"
            self.sectionIsExpanded = false
            //self.btnSemiFilter.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
        }
        switch (USER.shared.selectedFilter.toInt()){
                    
                    case 0:
                        self.selectedFilter = "0"
                        self.btnFilter.setTitle("Date Added ", for: .normal)
                        //break
                    case 1:
                        self.selectedFilter = "1"
                        self.btnFilter.setTitle("Date Modified ", for: .normal)
                    
                    case 2:
                        self.selectedFilter = "2"
                        self.btnFilter.setTitle("A to Z ", for: .normal)
                        
                    default:
                        break
                    }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getLocation()
        self.btnHandlerBlackBg(self)
        //self.btnSelectOptions(self.btnRecent)
        self.setInitialView()
        self.selectOptions(selected: self.selectedButton ?? self.btnRecent)
        
        txtName.borderColor = .black
        txtName.borderWidth = 1.0
        txtName.Round = true
        DispatchQueue.main.async {
            self.WSClearCount(Parameter: [:])
        }
        //let monthname = Date().getMonthFullname()
        //let year = Date().getYear()
        lblMonthandYear.text = "Recent"
        

    }
    @IBAction func btnChangeTableView(_ sender: UIButton) {
        if(sender == self.btnlist){
            USER.shared.selectedView = "table"
            USER.shared.save()
            self.selectedView = "table"
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
            self.selectedView = "grid"
            USER.shared.selectedView = "grid"
            USER.shared.save()
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
    @IBAction func btnCheckBoxClickAction(_ sender: UIButton) {
         checkBoxAction = !checkBoxAction
    }
    @IBAction func btnOkayAgreeClickAction(_ sender: UIButton) {
        if(!checkBoxAction){
            USER.shared.isDeleteActionShow = "0"
            USER.shared.save()
        }
        else{
            USER.shared.isDeleteActionShow = "1"
            USER.shared.save()
        }
        self.ViewdeleteConfirmation.removeFromSuperview()
    }
    @IBAction func btnSemiFilterAction(_ sender: UIButton) {
        //USER.shared.selectedSubFilter = !USER.shared.selectedSubFilter
        //USER.shared.save()
       sectionIsExpanded = !sectionIsExpanded
       if(sectionIsExpanded){
           let img = UIImage(named: "ic_down" )
           self.btnSemiFilter.setImage( img , for:  .normal)
           self.semiFilter = "1"
//           USER.shared.selectedSubFilter = "1"
//           USER.shared.save()
       }
       else{
           let img = UIImage(named:"ic_down")?.rotate(radians: Float(CGFloat.pi))
           self.btnSemiFilter.setImage( img , for:  .normal)
           self.semiFilter = "0"
//           USER.shared.selectedSubFilter = "0"
//           USER.shared.save()
           //self.btnSemiFilter.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
              }
        
       
        self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":self.selectedFilter,"semi_filter":self.semiFilter.description])
    }
    @IBAction func btnFilterAction(_ sender: UIButton) {
//        sectionIsExpanded = !sectionIsExpanded
//        if(sectionIsExpanded == true){
//            self.semiFilter  = "0"
//        }
//        else{
//            self.semiFilter  = "1"
//        }
        showActionSheetWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Choose Option", buttons: ["Date Added","Date Modified","A to Z"], canCancel: true) { (index) in

            switch (index){
            
            case 0:
                self.selectedFilter = "0"
                USER.shared.selectedFilter = "0"
                USER.shared.save()
                //self.sectionIsExpanded = !self.sectionIsExpanded
                self.btnFilter.setTitle("Date Added ", for: .normal)
                self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":self.selectedFilter,"semi_filter":self.semiFilter.description])
                //break
            case 1:
                self.selectedFilter = "1"
                USER.shared.selectedFilter = "1"
                USER.shared.save()
                //self.sectionIsExpanded = !self.sectionIsExpanded
                self.btnFilter.setTitle("Date Modified ", for: .normal)
            self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":self.selectedFilter,"semi_filter":self.semiFilter.description])
            case 2:
                self.selectedFilter = "2"
                USER.shared.selectedFilter = "2"
                USER.shared.save()
                //self.sectionIsExpanded = !self.sectionIsExpanded
                self.btnFilter.setTitle("A to Z ", for: .normal)
                self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":self.selectedFilter,"semi_filter":self.semiFilter.description])
//            case 3:
//                self.selectedFilter = "3"
//                //self.sectionIsExpanded = !self.sectionIsExpanded
//                self.btnFilter.setTitle("Z to A ", for: .normal)

            default:
                break
            }
            
        }
        

    }
    @IBAction func btnSelectOptions(_ sender: UIButton) {
        self.selectOptions(selected: sender)
    }
    func selectOptions(selected:UIButton)  {
        for btn in arrOption{
            
            if(btn == selected){
                
                if(btn == self.btnRecent){
                    self.selectedButton = self.btnRecent
                    self.selectedType = "recent"
                    self.isFolderSelected = false
                    self.btnPlus.isHidden = false
                }
                else if(btn == self.btnFolders){
                    self.selectedType = "folders"
                    self.selectedButton = self.btnFolders
                    self.isFolderSelected = true
                    self.btnPlus.isHidden = false
                }
                else{
                    self.selectedButton = self.btnShared
                    self.isFolderSelected = false
                    self.selectedType = "shared"
                    self.btnPlus.isHidden = true
                    
                    
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
            self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":selectedFilter,"semi_filter":self.semiFilter.description])
        //}

    }
    
    // MARK: - WEB Service
    func WSClearCount(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .reset_archived_counter, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
    func WSCreateFolder(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .create_folder, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.txtName.text = ""
                    if let archived_counter = dataResponce["archived_counter"] as? String{
                            USER.shared.archived_counter = archived_counter
                            USER.shared.save()
                    }
                    if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                                                USER.shared.linked_account_counters = String(linked_account_counters)
                        USER.shared.save()
                    }
                    self.btnhideDetails(self)
                    self.btnSelectOptions(self.btnFolders)

//                    self.WSFolderList(Parameter: [:])
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
    func WSFolderList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .folderList, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let outcome = dataResponce["data"] as? [NSDictionary]{
                        self.btnHandlerBlackBg(self)
                        self.btnhideDetails(self)
                        self.btnSelectOptions(self.btnFolders)
//                        self.arrFolderList.removeAll()
//                        for a : Int in (0..<(outcome.count))
//                        {
//                            let objarchivedList : FolderListMOdel = FolderListMOdel()
//                            objarchivedList.created      = outcome[a]["created"] as? String ?? ""
//                            objarchivedList.folder_name  = outcome[a]["folder_name"] as? String ?? ""
//                            objarchivedList.id           = outcome[a]["id"] as? String ?? ""
//                            objarchivedList.updated      = outcome[a]["updated"] as? String ?? ""
//                            objarchivedList.user_id      = outcome[a]["user_id"] as? String ?? ""
//                            objarchivedList.name      = outcome[a]["name"] as? String ?? ""
//                            self.arrFolderList.append(objarchivedList)
//                        }
//                        self.tblVideoList.reloadData()
//                        self.collVideogrid.reloadData()
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
    func WSDeleteFolder(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .delete_folder, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                   self.btnHandlerBlackBg(self)
                    self.btnhideDetails(self)
                    self.btnSelectOptions(self.btnFolders)

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
    func WSDeleteArchive(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .delete_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if(USER.shared.isDeleteActionShow == "0"){
                        self.showAlertFolrDeleted()
                    }
                    self.btnHandlerBlackBg(self)
                    self.btnhideDetails(self)
                    self.btnSelectOptions(self.selectedButton ?? self.btnRecent)

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
    func WSArchiveList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .archived_list, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    //self.sectionIsExpanded = !sectionIsExpanded
                    if(self.sectionIsExpanded){
                        let img = UIImage(named: "ic_down" )
                        self.btnSemiFilter.setImage( img , for:  .normal)
                        self.semiFilter = "1"
                        USER.shared.selectedSubFilter = "1"
                        USER.shared.save()
                    }
                    else{
                        let img = UIImage(named:"ic_down")?.rotate(radians: Float(CGFloat.pi))
                        self.btnSemiFilter.setImage( img , for:  .normal)
                        self.semiFilter = "0"
                        USER.shared.selectedSubFilter = "0"
                        USER.shared.save()
                        //self.btnSemiFilter.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi )
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
                            if let number_of_files = outcome[a]["number_of_files"] as? Int{
                                objarchivedList.number_of_files = number_of_files.description
                            }
                            else{
                                objarchivedList.number_of_files = "0"
                            }
                            
                            if let storage_used = outcome[a]["storage_used"] as? String{
                                objarchivedList.storage_used = storage_used
                            }
                            else{
                                objarchivedList.number_of_files = "0"
                            }
                            
                            if let total_size = outcome[a]["total_size"] as? String{
                                objarchivedList.total_size = total_size
                            }
                            else{
                                objarchivedList.number_of_files = "0"
                            }

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
extension archiveVC:sendbacktoName{
    func getselectedvire(view: String) {
        
    }
    
    func changename(name: String, index: IndexPath) {
        
    }
}

extension archiveVC:UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @objc func downloadCan(notification: NSNotification) {
        self.btnHandlerBlackBg(self)
    }
    @objc func downloadList(notification: NSNotification) {
        self.btnHandlerBlackBg(self)
        self.view.makeToast("Successfully downloaded", duration: 1.5, position: .bottom)
    }
    @objc func loadList(notification: NSNotification) {
        self.selectOptions(selected: self.selectedButton ?? self.btnRecent)
       }
    @objc func RefreshList(notification: NSNotification) {
             self.WSArchiveList(Parameter: ["type":self.selectedType,"filter":selectedFilter,"semi_filter":self.semiFilter.description])
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
           self.tblVideoList.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none)
       }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 && appDelegate.ArrLocalVideoUploading.count == 0 {
               // No insets for header in section 0
            return UIEdgeInsets.zero
        } else {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 50
        let collectionCellSize = collectionView.frame.size.width - padding
    if(self.isFolderSelected == true){
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/3)
    }
    else{
        return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
    }
        
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
            let vc = storyBoards.Main.instantiateViewController(withIdentifier: "subFolderVC") as! subFolderVC
            vc.FolderId = self.arrarchivedList[indexPath.row].id!
            vc.data = self.arrarchivedList[indexPath.row]
            vc.FileId = self.arrarchivedList[indexPath.row].folder_id!
            vc.navigationTitle = self.arrarchivedList[indexPath.row].folder_name!
            vc.buttonName = ""
            self.navigationController?.pushViewController(vc, animated: true)
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
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0){
            let cell:collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadCell", for: indexPath) as! collCell
                cell.videoThumb.image = nil
            cell.lblTitle.text = appDelegate.ArrLocalVideoUploading[indexPath.row].name ?? ""
            cell.lblName.text = ""
            cell.videoThumb.image = appDelegate.ArrLocalVideoUploading[indexPath.row].thumbImage
//            appDelegate.ArrLocalVideoUploading.filter({$0.isUploaded == false})
            cell.progressBar.progress = Float(appDelegate.ArrLocalVideoUploading[indexPath.row].progress)
            cell.btnPlayvideo.tag = indexPath.row
            cell.btnPlayvideo.addTarget(self, action: #selector(self.btnplayofflineVideo(_:)),for: .touchUpInside)
            return cell
        }
        else{
        
        if(self.isFolderSelected == true){
        let cell:FolderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
            cell.lblName.text = self.arrarchivedList[indexPath.row].folder_name
            cell.btncellTap.tag = indexPath.row
            cell.btncellTap.addTarget(self, action: #selector(self.btncelltapClick(_:)),for: .touchUpInside)
            cell.btnOption.tag = indexPath.row
            cell.btnOption.addTarget(self, action: #selector(self.btnFolderOptionMenuClick(_:)),for: .touchUpInside)
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
            //cell.lblTitle.text = self.arrarchivedList[indexPath.row].image_name
            
            let firstPart = self.arrarchivedList[indexPath.row].image_name!.strstr(needle: ".", beforeNeedle: true)
                cell.lblTitle.text = firstPart ??  self.arrarchivedList[indexPath.row].image_name!
              
            if(self.isLocationEnable == true){
                cell.btnMap.isHidden = false
            }
            else{
                cell.btnMap.isHidden = true
            }
            
            cell.lblName.text = self.arrarchivedList[indexPath.row].uploaded_by
            cell.lblName.textColor = UIColor.AppSky()
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

    }
    
}
extension archiveVC:UICollectionViewDelegate,UITableViewDataSource{
     // MARK: - UITableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
                return appDelegate.ArrLocalVideoUploading.count
        }
        else{
            return self.arrarchivedList.count
        }
//            return self.arrarchivedList.count
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            if(self.isFolderSelected == true){
                let vc = storyBoards.Main.instantiateViewController(withIdentifier: "subFolderVC") as! subFolderVC
                      vc.FolderId = self.arrarchivedList[indexPath.row].id!
                      vc.data = self.arrarchivedList[indexPath.row]
                vc.FileId = self.arrarchivedList[indexPath.row].folder_id!
                      vc.navigationTitle = self.arrarchivedList[indexPath.row].folder_name!
                      vc.buttonName = ""
                      self.navigationController?.pushViewController(vc, animated: true)
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell:uploadTableViewCell = tableView.dequeueReusableCell(withIdentifier: "uploadTableViewCell", for: indexPath) as! uploadTableViewCell
            cell.videoThumb.image = nil
            cell.lblTitle.text = appDelegate.ArrLocalVideoUploading[indexPath.row].name ?? ""
            cell.videoThumb.image = appDelegate.ArrLocalVideoUploading[indexPath.row].thumbImage
            cell.progressBar.progress = Float(appDelegate.ArrLocalVideoUploading[indexPath.row].progress)
            return cell
        }
        else{
            if(self.isFolderSelected == true){
                let cell:VideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsTableViewCell", for: indexPath) as! VideoDetailsTableViewCell
                cell.videoThumb.contentMode = .scaleAspectFit
                cell.videoThumb.image = #imageLiteral(resourceName: "ic_folder")
                cell.selectionStyle = .none
                cell.btnPlayView.tag = indexPath.row
                cell.btnPlayView.addTarget(self, action: #selector(self.btnplayvideoClieck(_:)),for: .touchUpInside)
                cell.btnMap.isHidden = true
                cell.btnOption.isHidden = false
                cell.btnOption.tag = indexPath.row
                cell.btnOption.addTarget(self, action: #selector(self.btnFolderOptionMenuClick(_:)),for: .touchUpInside)
                cell.lblTitle.text = self.arrarchivedList[indexPath.row].folder_name
                cell.lblName.text = ""
                cell.imgType.image = nil
                return cell
            }
            else{
                let cell:VideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailsTableViewCell", for: indexPath) as! VideoDetailsTableViewCell
                cell.videoThumb.image = nil

                if(self.isLocationEnable == true){
                    cell.btnMap.isHidden = false
                }
                else{
                    cell.btnMap.isHidden = true
                }
                cell.selectionStyle = .none
                cell.btnPlayView.tag = indexPath.row
                cell.btnPlayView.addTarget(self, action: #selector(self.btnplayvideoClieck(_:)),for: .touchUpInside)
                cell.btnMap.tag = indexPath.row
                cell.btnOption.tag = indexPath.row
                cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
                cell.btnMap.addTarget(self, action: #selector(self.btnMapShow(_:)),for: .touchUpInside)
                //cell.lblTitle.text = self.arrarchivedList[indexPath.row].image_name
                let firstPart = self.arrarchivedList[indexPath.row].image_name!.strstr(needle: ".", beforeNeedle: true)
                cell.lblTitle.text = firstPart ??  self.arrarchivedList[indexPath.row].image_name!
                          
                cell.lblName.text = self.arrarchivedList[indexPath.row].uploaded_by
                if(arrarchivedList[indexPath.row].type == "image"){
                    cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].image_path!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                    cell.imgType.image = #imageLiteral(resourceName: "ic_playimg")
                    //cell.videoThumb.contentMode = .scaleAspectFit
                    
                }
                else{
                    cell.imgType.image = #imageLiteral(resourceName: "ic_playvid")
                    //cell.videoThumb.contentMode = .scaleAspectFill
                    cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].thumb_image!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                    
                }
                return cell
            }
        }
    }
    
   
}
class FolderCell: UICollectionViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var btnOption:UIButton!
    @IBOutlet weak var btncellTap:UIButton!
    @IBOutlet weak var imgMore:UIImageView!
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
extension archiveVC {
        func PhotosFromAlbum()
{
       //          Display Photo Library
    imgPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
    imgPickerController.mediaTypes = [kUTTypeImage as String]
                //controller.delegate = self
    present(imgPickerController, animated: true, completion: {
        self.imgPickerController.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
    })
            
//             let cr = CameraRoll()
//
//            cr.present(in: self, mode: .Image) { (assets) in
//
//                let first = assets?.first
//                          // DispatchQueue.main.async {
//                self.accetm.getOriginal(phAsset: first!) { (myimage) in
//                            let imageData = myimage.mediumQualityJPEGNSData
//                            if let image = UIImage(data: imageData as Data) {
//                                self.WSUploadImageArchive(Parameters: ["lat":self.latitude.description,"long":self.longitude.description,"type":"image"], img: image)
//                            }
//
//                            /*AssetManager.sharedInstance.getOriginal(phAsset: first) { (img) in
//                                let imageData = img.mediumQualityJPEGNSData
//                                if let image = UIImage(data: imageData as Data) {
//                                    self.WSUploadImageArchive(Parameters: ["lat":self.latitude.description,"long":self.longitude.description,"type":"image"], img: image)
//
//                                }
//
//                            }
// */
//
//                          // }
//                       }
//                   }
//
         }
    func VideoFromAlbum()
    {
             //imgPickerController.delegate = self
        imgPickerController.modalPresentationStyle = .popover
        imgPickerController.sourceType = .photoLibrary
        imgPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeMPEG2Video as String]
        imgPickerController.allowsEditing = true
             //imgPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
        self.present(imgPickerController, animated: true, completion: nil)
        
        
//        imgPickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
//        imgPickerController.mediaTypes = [kUTTypeVideo as String,kUTTypeAppleProtectedMPEG4Video]
//        imgPickerController.delegate = self
//        present(imgPickerController, animated: true, completion: {
//            self.imgPickerController.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
//        })
        
        
        
        let cr = CameraRoll()
       
             cr.present(in: self, mode: .Video) { (assets) in
               
                 if let assets = assets, let first = assets.first {
                     DispatchQueue.main.async {
                       
                         AssetManager.sharedInstance.getVideoFromAsset(phAsset: first) { (vid) in
                           print(vid)
                           if let nextURLAsset = vid as? AVURLAsset {
                               let sourceURL = nextURLAsset.url
                               let asset = AVAsset(url: sourceURL)
                               self.videoURL = sourceURL as NSURL
                            self.videoRecorded = sourceURL
                               let duration = asset.duration
                               let durationTime = CMTimeGetSeconds(duration)
                              
                           DispatchQueue.background(background: {
                       self.getThumbnailImageFromVideoUrl(url: self.videoURL as! URL) { (AthumbImage) in
                                                                     //self.thumbImageForVide = AthumImage
                       let objLocalVid:localVideoModel = localVideoModel()
                       objLocalVid.url = self.videoRecorded
                       objLocalVid.thumbImage = AthumbImage
                        objLocalVid.name = "video\(Date().getyyyMMddStr().description).mp4"
                       appDelegate.ArrLocalVideoUploading.append(objLocalVid)
                       self.WSUploadPhoneVideo(statTime: 0.0, endTime:Double(durationTime), thumimg: AthumbImage!, sendThum: true, OPUrl: self.videoURL! as URL )
                               }
                               
                           }, completion:{
                                                      // self.delegate?.getListData()
                                                        // when background job finished, do something in main thread
                                                    })

                              // self.WSUploadVideo(Parameter: ["lat":self.latitude.description,"long":self.longitude.description,"type":"video"], urll: sourceURL.absoluteURL)
                           }
                            // self.imageView.image = image
                        //   self.WSUploadImage(Parameters: ["lat":self.latitude.description,"long":self.longitude.description,"type":"image"], img: vid)

                           
                         }
                     }
                 }
             }

    }
    
      func getLocation(){
               locationManager.showVerboseMessage = false
               locationManager.autoUpdate = true
                locationManager.startUpdatingLocation()
            DispatchQueue.main.async {
                self.locationManager.reverseGeocodeLocationWithLatLon(latitude: USER.shared.latitude.toDouble()!, longitude: USER.shared.longitude.toDouble()!) { (dict, placemark, str) in
                      if let city = dict?["locality"] as? String{
                          USER.shared.city = city
                      }
                      if let country = dict?["country"] as? String{
                          USER.shared.country = country
                      }
                      USER.shared.save()
                      }

            }
               locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
                   self.latitude = latitude
                   self.longitude = longitude
                self.locationManager.autoUpdate = false
               }
        }
        @IBAction func OpenMenuBtnAction(_ sender:UIButton){
               let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
               present(menu, animated: true, completion: nil)
           }
        
        
        func WSVideoUploadSuces(Parameter:[String:String]) -> Void {
            ServiceManager.shared.callAPIPost(WithType: .successfully_upload_video, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
                if(Status == true){
                    let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                    let StatusCode = DataResponce?["status"] as? Int
                    if (StatusCode == 200){
                       
                    }
                    else if(StatusCode == 401)
                    {
                    }
                    else{
                    }
                }
                else{
                }
            }) { (DataResponce, Status, Message) in
                //
            }
        }
        
          func WSUploadPhoneVideo(statTime:Double, endTime:Double,thumimg:UIImage,sendThum:Bool,OPUrl:URL) -> Void {
            
            var etime = statTime + 5.0
            if(etime>endTime){
                etime = endTime
            }
            if(statTime < endTime){
                self.cropVideo(sourceURL: self.videoURL! as URL, startTime: statTime, endTime: etime) { (FUrl) in
            print("url :",FUrl, "Start time : ",statTime, "End time : ",etime)
                 // arrOfChunks.append(FUrl)
                let curruntChunk = FUrl
                    let Parameter = ["lat":APPDELEGATE.latitude,"long":APPDELEGATE.logitude,"unique_id":self.Baseunique_id]
                ServiceManager.shared.callAPIWithVideoChunk(WithType: .upload_chunk, VideoChunk: curruntChunk, thumbImage: thumimg, passThumb: sendThum, WithParams: Parameter,Progress: {
                    (process)in
                    print("my:",process)
                    //set progress
                    appDelegate.ArrLocalVideoUploading.filter({$0.url == OPUrl}).first?.progress = process!
                    
                    //appDelegate.objLocalVid.progress = process!
                }, Success: { (DataResponce, Status, Message) in
                    if(Status == true){
                        let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                        let StatusCode = DataResponce?["status"] as? Int
                        if (StatusCode == 200){
                           if let Data = dataResponce["data"] as? NSDictionary{
                                if let videoKey = Data["unique_id"] as? String{
                                    self.Baseunique_id = videoKey
                                    let strTimr = statTime + 5
                                    if(strTimr >= endTime){
                                        print("video upload complete")
                                        self.WSVideoUploadSuces(Parameter: ["unique_video_id":videoKey])
                                        appDelegate.ArrLocalVideoUploading = appDelegate.ArrLocalVideoUploading.filter({$0.url != OPUrl})
                                        self.getListData()
                                      //  NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: nil)
                                    }
                                    else{
                                        appDelegate.ArrLocalVideoUploading.filter({$0.url == OPUrl}).first?.progress = 0.0
                                        self.WSUploadPhoneVideo(statTime: strTimr, endTime:endTime, thumimg: thumimg, sendThum: false,OPUrl: self.videoURL! as URL)
                                    }
                                }
                        }
                        }
                        else if(StatusCode == 401)
                        {
                         //   self.myGroup.leave()
                            self.WSUploadPhoneVideo(statTime: statTime, endTime:endTime, thumimg:thumimg, sendThum: false,OPUrl: self.videoURL! as URL)
                            if let errorMessage:String = Message{
                                showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                                        appDelegate.setLoginVC()
                                }
                            }
                        }
                        else{
                       //     self.myGroup.leave()

                            if let errorMessage:String = dataResponce["message"] as? String{
                               // showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                            }
                        }
                    }
                    else{
                        //self.myGroup.leave()

                        if let errorMessage:String = Message{
                            //showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                        }
                    }
                }) { (DataResponce, Status, Message) in
                    //
                    //self.myGroup.leave()

                }

              
            
            }
        }
           // return responsBool
        }
        func WSUploadVideo(Parameter:[String:String],urll:URL) -> Void {
            ServiceManager.shared.callAPIWithVideo(WithType:.upload_chunk, VideoUrl: urll,  WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            //        ServiceManager.shared.callAPIPost(WithType: .get_pocket, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
                if(Status == true){
                    let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                    let StatusCode = DataResponce?["status"] as? Int
                    if (StatusCode == 200){
                        
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
        func WSDownloadImage(Parameters: [String: Any],img:UIImage){
            ServiceManager.shared.callAPIWithMultipleImage(WithType: .upload_file, imageUpload: img, WithParams:  Parameters, Success: { (DataResponce, Status, Message)  in
           
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let outcome = dataResponce["data"] as? NSDictionary {
                        DispatchQueue.main.async {
                            self.getListData()
                            //USER.shared.setData(dict:outcome)
                            //USER.shared.save()
                            //self.popTo()
                        }
                    }
                    else
                    {
                        print("error to save data!")
                    }
                }
                    else if(StatusCode == 401)
                    {
                        USER.shared.clear()
                        if let errorMessage:String = dataResponce["message"] as? String{
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                                    
                                        appDelegate.setLoginVC()
                                        // Fallback on earlier versions
                                    
                            }
                        }
                    }
                    else{
                        if let errorMessage:String = DataResponce!["message"] as? String{
                            showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                        }
                                  
                    }
                }) { (DataResponce, Status, Message) in
                
                    if let errorMessage:String = DataResponce!["message"] as? String{
                showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
                
            }
                
        }
        func WSUploadImageArchive(Parameters: [String: Any],img:UIImage){
            ServiceManager.shared.callAPIWithMultipleImage(WithType: .upload_file, imageUpload: img, WithParams:  Parameters, Success: { (DataResponce, Status, Message)  in
           
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    //self.viewWillAppear(true)
                        DispatchQueue.main.async {
                            self.getListData()
                        }
                }
                    else if(StatusCode == 401)
                    {
                        USER.shared.clear()
                        if let errorMessage:String = dataResponce["message"] as? String{
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                                    
                                        appDelegate.setLoginVC()
                                        // Fallback on earlier versions
                                    
                            }
                        }
                    }
                    else{
                        if let errorMessage:String = DataResponce!["message"] as? String{
                            showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                        }
                                  
                    }
                }) { (DataResponce, Status, Message) in
                
                    if let errorMessage:String = DataResponce!["message"] as? String{
                showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                }
                
            }
                
        }

        func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
               DispatchQueue.global().async { //1
                   let asset = AVAsset(url: url) //2
                   let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
                   avAssetImageGenerator.appliesPreferredTrackTransform = true //4
                   let thumnailTime = CMTimeMake(value: 0, timescale: 600) //5
                   do {
                       let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                       let thumbImage = UIImage(cgImage: cgThumbImage) //7
                       DispatchQueue.main.async { //8
                           completion(thumbImage) //9
                       }
                   } catch {
                       print(error.localizedDescription) //10
                       DispatchQueue.main.async {
                           completion(nil) //11
                       }
                   }
               }
           }

        // MARK: - Lifecycle Delegate Methods
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                  imgPickerController.delegate = self
                  imgPickerController.dismiss(animated: true,completion: {
                  })
        }
          //
//        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//
//            // change title here to something other than default "Photo"
//            viewController.navigationController?.navigationBar.topItem?.title = "Photos"
//            self.imgPickerController.navigationBar.topItem?.title = "Photos"
//
//        }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let controller = navigationController.topViewController
        controller!.navigationItem.title = "Choose Video"
            viewController.navigationItem.title = "Media Picker"
        viewController.navigationItem.title = "video" // Change title
        imgPickerController.navigationBar.tintColor = .white
        imgPickerController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
    }
    func videoUrlForUpload(nextURLAsset:URL){
            
                let sourceURL = nextURLAsset
                let asset = AVAsset(url: sourceURL)
                self.videoURL = sourceURL as NSURL
             self.videoRecorded = sourceURL
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
               
            DispatchQueue.background(background: {
        self.getThumbnailImageFromVideoUrl(url: self.videoURL as! URL) { (AthumbImage) in
                                                      //self.thumbImageForVide = AthumImage
        let objLocalVid:localVideoModel = localVideoModel()
        objLocalVid.url = self.videoRecorded
        objLocalVid.thumbImage = AthumbImage
         objLocalVid.name = "video\(Date().getyyyMMddStr().description).mp4"
        appDelegate.ArrLocalVideoUploading.append(objLocalVid)
        self.WSUploadPhoneVideo(statTime: 0.0, endTime:Double(durationTime), thumimg: AthumbImage!, sendThum: true, OPUrl: self.videoURL! as URL )
                }
                
            }, completion:{
                                       // self.delegate?.getListData()
                                         // when background job finished, do something in main thread
                                     })

               // self.WSUploadVideo(Parameter: ["lat":self.latitude.description,"long":self.longitude.description,"type":"video"], urll: sourceURL.absoluteURL)
            
    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
            let videoString = kUTTypeVideo as? String
            let movieString = kUTTypeMovie as? String

            if (mediaType == videoString) || (mediaType == movieString) {
                imgPickerController.dismiss(animated: true,completion: {
                    guard let URLVIdeo = info[.mediaURL] as? NSURL else { return }
                self.videoURL = URLVIdeo
                    self.videoUrlForUpload(nextURLAsset: self.videoURL! as URL)
                })
                
            }
            else{
                
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                picker.dismiss(animated: true) {
                      self.WSUploadImageArchive(Parameters: ["lat":APPDELEGATE.latitude,"long":APPDELEGATE.logitude,"type":"image"], img: pickedImage)
                }
            }
            imgPickerController.dismiss(animated: true,completion: {
                          guard let image = info[.editedImage] as? UIImage else { return }
                          self.selectedImage = image
                          })
            
                }
            //print(self.videoURL ?? "")
            
          
                     
        }


}
extension archiveVC{
    func DownloadAndSave(urlString : String)
    {
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let imagesDirectoryPath = documentDirectoryPath.appending("/ProtectMe")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: imagesDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: imagesDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating images folder in documents dir: \(error)")
                }
            }
        }
        
        APPDELEGATE.SHOW_CUSTOM_LOADER()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            // ...
            let path = urlString
            let fileName = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
            let  fileExtension = URL(fileURLWithPath: path).pathExtension
            Swift.print(fileName,".",fileExtension)
            
            let fileNameWithExtension = "\(fileName).\(fileExtension)"
            
            let tmpDirURL = FileManager.default.temporaryDirectory
            
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = fileNameWithExtension
            let actualPath = resourceDocPath.appendingPathComponent("ProtectMe/\(pdfNameFromUrl)")
            print(resourceDocPath,actualPath)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                self.view.makeToast("Successfully downloaded", duration: 1.5, position: .bottom)

//                Toast(text: "Successfully downloaded").show()
                APPDELEGATE.HIDE_CUSTOM_LOADER()
                print("successfully saved!")
            } catch {
                APPDELEGATE.HIDE_CUSTOM_LOADER()
                print(" could not be saved")
            }
        }
        
    }
}
