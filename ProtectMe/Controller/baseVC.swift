//
//  baseVC.swift
//  ProtectMe
//
//  Created by Mac on 09/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import Photos
import CameraRoll
import MobileCoreServices


protocol NotifyToCallListService: class {
    // The following command (ie, method) must be obeyed by any
    // underling (ie, delegate) of the older sibling.
    func getListData()
}
class baseVC: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var videoRecorded: URL? = nil
    var unique_idforFile = ""
    weak var delegate: NotifyToCallListService?

    let imgPickerController = UIImagePickerController()
    var selectedImage:UIImage?
    let titleName = "Photos"
    var videoURL : NSURL?
    var latitude:Double = 0.0
    var longitude:Double = 0.0
      let locationManager = LocationManager.sharedInstance



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.imgPickerController.delegate = self
        self.getLocation()

//        let photos = PHPhotoLibrary.authorizationStatus()
//        if photos == .notDetermined {
//            PHPhotoLibrary.requestAuthorization({status in
//                if status == .authorized{
//                    
//                } else {}
//            })
//        }
//        PHPhotoLibrary.requestAuthorization({ (newStatus) in
//                       if (newStatus == PHAuthorizationStatus.authorized) {
//                         //  acess = true
//                       }
//
//                       else {
//                           //acess = false
//
//                       }
//                   })

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    func getLocation(){
           locationManager.showVerboseMessage = false
           locationManager.autoUpdate = true
         //   locationManager.startUpdatingLocation()
           locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
               self.latitude = longitude
               self.longitude = latitude
            self.locationManager.autoUpdate = false
           }
    }
    @IBAction func OpenMenuBtnAction(_ sender:UIButton){
           let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
           present(menu, animated: true, completion: nil)
       }
    func WSUploadPhoneVideo(statTime:Double, endTime:Double) -> Void {
        var etime = statTime + 5.0
        if(etime>endTime){
            etime = endTime
        }
        if(statTime < endTime){
            self.cropVideo(sourceURL: self.videoURL! as URL, startTime: statTime, endTime: etime) { (FUrl) in
        print("url :",FUrl, "Start time : ",statTime, "End time : ",etime)
            
           // arrOfChunks.append(FUrl)
            let curruntChunk = FUrl
             let Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":self.unique_idforFile]
                ServiceManager.shared.callAPIWithVideoChunk(WithType: .upload_chunk, VideoChunk: curruntChunk, thumbImage: UIImage(), passThumb: false, WithParams: Parameter,Progress: {
                    (process)in
                    print("my:",process)
                }, Success: { (DataResponce, Status, Message) in
                if(Status == true){
                    let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                    let StatusCode = DataResponce?["status"] as? Int
                    if (StatusCode == 200){
                       if let Data = dataResponce["data"] as? NSDictionary{
                            if let videoKey = Data["unique_id"] as? String{
                                self.unique_idforFile = videoKey
                              //  if(chunk.count - 1 != Index){
                                 //    Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":self.unique_id]
                                    var strTimr = statTime + 5
                                    if(statTime >= endTime){
                                        print("video upload complete")
                                        self.delegate?.getListData()
                                    }
                                    else{
                                        
                                        self.WSUploadPhoneVideo(statTime: strTimr , endTime: endTime)
                                    }
                                    //self.WSUploadVideoR(Parameter: Parameter, chunk: chunk, Index: Index+1)
                           //     }
                                

                            }
                    }
                    }
                    else if(StatusCode == 401)
                    {
                     //   self.myGroup.leave()
                        self.WSUploadPhoneVideo(statTime: statTime , endTime: endTime)
                        if let errorMessage:String = Message{
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                                
                                    appDelegate.setLoginVC()
                                    // Fallback on earlier versions
                                
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
    func WSUploadImage(Parameters: [String: Any],img:UIImage){
        ServiceManager.shared.callAPIWithMultipleImage(WithType: .upload_file, imageUpload: [img], WithParams:  Parameters, Success: { (DataResponce, Status, Message)  in
       
            let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
            let StatusCode = DataResponce?["status"] as? Int
            if (StatusCode == 200){
                if let outcome = dataResponce["data"] as? NSDictionary {
                    DispatchQueue.main.async {
                        self.delegate?.getListData()
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
    func PhotoAlbum()
     {
        var controller = UIImagePickerController()

            // Display Photo Library
//        controller.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
//            controller.mediaTypes = [kUTTypeImage as String]
//            controller.delegate = self
//            present(controller, animated: true, completion: nil)
        
         let cr = CameraRoll()
               cr.present(in: self, mode: .Image) { (assets) in
                   if let assets = assets, let first = assets.first {
                       DispatchQueue.main.async {
                        AssetManager.sharedInstance.getOriginal(phAsset: first) { (img) in
                            let imageData = img.mediumQualityJPEGNSData
                            if let image = UIImage(data: imageData as Data) {
                               // Use image...
                                DispatchQueue.background(background: {
                                    // do something in background
                                self.WSUploadImage(Parameters: ["lat":self.longitude.description,"long":self.latitude.description,"type":"image"], img: image)

                                }, completion:{
                                   

                                    // when background job finished, do something in main thread
                                })

                            }

                        }
                       }
                   }
               }
           
     }

     func VideoAlbum()
     {
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
                                let duration = asset.duration
                                let durationTime = CMTimeGetSeconds(duration)
                                                     DispatchQueue.background(background: {
                                                         // do something in background
                                                        
                                                         self.WSUploadPhoneVideo(statTime: 0.0, endTime:Double(durationTime) )
                                                     }, completion:{
                                                        self.delegate?.getListData()
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
    // MARK: - Lifecycle Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
              imgPickerController.delegate = self
              imgPickerController.dismiss(animated: true,completion: {
              })
    }
      //
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        // change title here to something other than default "Photo"
        viewController.navigationController?.navigationBar.topItem?.title = "AAA"
        //self.imgPickerController.navigationBar.topItem?.title = titleName
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        self.WSUploadImage(Parameters: ["lat":self.latitude.description,"long":self.longitude.description,"type":"image"], img: pickedImage)
        }
        imgPickerController.dismiss(animated: true,completion: {
                      guard let image = info[.editedImage] as? UIImage else { return }
                      self.selectedImage = image
                      })
        imgPickerController.dismiss(animated: true,completion: {
            guard let URLVIdeo = info[.mediaURL] as? NSURL else { return }
        self.videoURL = URLVIdeo
            print(self.videoURL ?? "")
        })
        //        do {
//               let asset = AVURLAsset(url: videoURL as! URL , options: nil)
//               let imgGenerator = AVAssetImageGenerator(asset: asset)
//               imgGenerator.appliesPreferredTrackTransform = true
////               let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
////               let thumbnail = UIImage(cgImage: cgImage)
////               imgView.image = thumbnail
//           } catch let error {
//               print("*** Error generating thumbnail: \(error.localizedDescription)")
//           }
                 
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}