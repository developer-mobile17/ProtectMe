//
//  recordVC.swift
//  ProtectMe
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import SideMenu
import AVFoundation
import CoreMedia
import AVKit
import CoreLocation
import Foundation
import MobileCoreServices

//import CameraEngine


class recordVC: baseVC,AVCaptureFileOutputRecordingDelegate{
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var outputFileHandle:FileHandle?
    let myGroup = DispatchGroup()
    var thumbImageForVide:UIImage = #imageLiteral(resourceName: "placeholder")
    var unique_id = ""

    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var timeView: UIView!
    // let cameraManager = CameraManager()
    let movieOutput = AVCaptureMovieFileOutput()
    var videoRecordedURL: URL? = nil
    var cameraOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    @IBOutlet weak var btnChangeCam: UIButton!

    @IBOutlet weak var durationTxt: UILabel!
    var isVideoRecordingOn:Bool = false
    var isBackCam:Bool = true
    var isFlashOn:Bool = false
    var myVideoURL:URL? = nil
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.

    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.

    func capturePhoto() {
        // create settings for your photo capture
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: UIScreen.main.bounds.size.width,
            kCVPixelBufferHeightKey as String: UIScreen.main.bounds.size.height
            ] as [String : Any]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setUserLocation()
        }
        if USER.shared.id == ""{
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.LoginToContinue)
        }
        else{
            if(USER.shared.videoUrl != ""){
                if(USER.shared.videoUrl.contains(".mp4")){
                let videoURL = URL(string: USER.shared.videoUrl)
                let player = AVPlayer(url: videoURL!)

                let vc = AVPlayerViewController()
                vc.player = player

                present(vc, animated: true) {
                    USER.shared.videoUrl = ""
                    USER.shared.save()
                    vc.player?.play()
                }
            }
            
            else{
                let vc = storyBoards.Main.instantiateViewController(withIdentifier: "imgviewwerVC") as! imgviewwerVC
                vc.imgforview = USER.shared.videoUrl
                self.present(vc, animated: true, completion: {
                    USER.shared.videoUrl = ""
                    USER.shared.save()
                })
            }
        }
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.stopAnimating()
                DispatchQueue.main.async {
            if self.setupSession() {
                self.setupPreview()
                self.startSession()
              }
        }
        //askForCameraPermissions()
        self.timeView.isHidden = true

//        cameraManager.shouldFlipFrontCameraImage = true


    }
    
       
 func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
        cameraOutput.isHighResolutionCaptureEnabled = true
        captureSession.addOutput(cameraOutput)

    
    }
    
     //MARK:- Setup Camera
 /// Create new capture device with requested position
    
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {

        if #available(iOS 10.2, *) {
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
            for device in devices {
                         if device.position == position {
                             return device
                         }
                     }
        } else {
            // Fallback on earlier versions
        }

        //if let devices = devices {
//            for device in devices {
//                if device.position == position {
//                    return device
//                }
//            }
        //}

        return nil
    }
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }

        return nil
    }
     fileprivate func swapCamera() {

        // Get current input
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }

        // Begin new session configuration and defer commit
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        // Create new capture device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }

        // Create new capture input
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        // Swap capture device inputs
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    
     func setupSession() -> Bool {
        if AVCaptureDevice.default(for: AVMediaType.video) != nil {
           // init AVCaptureSession here
         captureSession.sessionPreset = AVCaptureSession.Preset.high
         // Setup Camera
         let camera = AVCaptureDevice.default(for: AVMediaType.video)!
         do {
             let input = try AVCaptureDeviceInput(device: camera)
             if captureSession.canAddInput(input) {
                 captureSession.addInput(input)
                 activeInput = input
             }
         } catch {
             print("Error setting device video input: \(error)")
             return false
         }

         // Setup Microphone
         let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!

         do {
             let micInput = try AVCaptureDeviceInput(device: microphone)
             if captureSession.canAddInput(micInput) {
                 captureSession.addInput(micInput)
             }
         } catch {
             print("Error setting device audio input: \(error)")
             return false
         }


         // Movie output
         if captureSession.canAddOutput(movieOutput) {
             captureSession.addOutput(movieOutput)
         }
        }
         return true
            
     }

     func setupCaptureMode(_ mode: Int) {
         // Video Mode

     }

     //MARK:- Camera Session
     func startSession() {

         if !captureSession.isRunning {
             videoQueue().async {
//                self.isVideoRecordingOn = true
                 self.captureSession.startRunning()
             }
         }
     }

     func stopSession() {
         if captureSession.isRunning {
             videoQueue().async {
//                self.isVideoRecordingOn = false
                 self.captureSession.stopRunning()
             }
         }
     }

     func videoQueue() -> DispatchQueue {
         return DispatchQueue.main
     }

     func currentVideoOrientation() -> AVCaptureVideoOrientation {
         var orientation: AVCaptureVideoOrientation

         switch UIDevice.current.orientation {
             case .portrait:
                 orientation = AVCaptureVideoOrientation.portrait
             case .landscapeRight:
                 orientation = AVCaptureVideoOrientation.landscapeLeft
             case .portraitUpsideDown:
                 orientation = AVCaptureVideoOrientation.portraitUpsideDown
             default:
                  orientation = AVCaptureVideoOrientation.landscapeRight
          }

          return orientation
      }

     @objc func startCapture() {

         startRecording()

     }
     func startRecording() {
         if movieOutput.isRecording == false {
             let connection = movieOutput.connection(with: AVMediaType.video)
             if (connection?.isVideoOrientationSupported)! {
                 connection?.videoOrientation = currentVideoOrientation()
             }
             if (connection?.isVideoStabilizationSupported)! {
                 connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
             }
             let device = activeInput.device
             if (device.isSmoothAutoFocusSupported) {
                 do {
                     try device.lockForConfiguration()
                     device.isSmoothAutoFocusEnabled = false
                     device.unlockForConfiguration()
                 } catch {
                    print("Error setting configuration: \(error)")
                 }
             }
             //EDIT2: And I forgot this
             outputURL = tempURL()
             movieOutput.startRecording(to: outputURL, recordingDelegate: self)
             }
             else {
                 stopRecording()
             }
        }
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString

        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }

        return nil
    }
    func stopRecording() {

        if movieOutput.isRecording == true {
            self.toggleTorch(on: false)
            movieOutput.stopRecording()
         }
    }

     func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
     }
    @objc func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject)
     {
        if let _ = error {
           print("Error,Video failed to save")
        }else{
           print("Successfully,Video was saved")
        }
    }
    func fileSize(forURL url: Any) -> Double {
        var fileURL: URL?
        var fileSize: Double = 0.0
        if (url is URL) || (url is String)
        {
            if (url is URL) {
                fileURL = url as? URL
            }
            else {
                fileURL = URL(fileURLWithPath: url as! String)
            }
            var fileSizeValue = 0.0
            try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
            if fileSizeValue > 0.0 {
                fileSize = (Double(fileSizeValue) / (1024 * 1024))
            }
        }
        return fileSize
    }
    func setupNamedPipe(withData data: Data) -> URL?
    {
        // Build a URL for a named pipe in the documents directory
        let fifoBaseName = "avpipe"
        let fifoUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent(fifoBaseName)

        // Ensure there aren't any remnants of the fifo from a previous run
        unlink(fifoUrl.path)

        // Create the FIFO pipe
        if mkfifo(fifoUrl.path, 0o666) != 0
        {
            print("Failed to create named pipe")
            return nil
        }

        // Run the code to manage the pipe on a dispatch queue
        DispatchQueue.global().async
        {
            print("Waiting for somebody to read...")
            let fd = open(fifoUrl.path, O_WRONLY)
            if fd != -1
            {
                print("Somebody is trying to read, writing data on the pipe")
                data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
                    let num = write(fd, bytes, data.count)
                    if num != data.count
                    {
                        print("Write error")
                    }
                }

                print("Closing the write side of the pipe")
                close(fd)
            }
            else
            {
                print("Failed to open named pipe for write")
            }

            print("Cleaning up the named pipe")
            unlink(fifoUrl.path)
        }

        return fifoUrl
    }
    func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
     
    func trimVideoAndUpload(filepath:URL){
        let asset = AVAsset(url: filepath)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        print("video in seconds : ",durationTime)
        var totalTime = Int(durationTime)
        if(totalTime < 5){
            
        }
        else{
            var currentLevel:Double = 0, finalLevel:Double = Double(totalTime)
            let gameCompleted = true
            while (currentLevel <= finalLevel) {
                //play game
                if gameCompleted {
                
                    if(totalTime>5){
                        totalTime = totalTime - Int(5.0)
                        currentLevel += 5.0
                        
                    }
                    else{
                        currentLevel = currentLevel + Double(totalTime)
                    }
                    self.cropVideo(sourceURL: filepath, startTime: Double(currentLevel), endTime: Double(currentLevel + 5) ) { (FUrl) in
                        print(FUrl)
                        let group = DispatchGroup()
                        let tempID = ""
                        var Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":tempID]
                        group.enter()
                        ServiceManager.shared.callAPIWithVideoChunk(WithType: .upload_chunk, VideoChunk: filepath, thumbImage: UIImage(), passThumb: false, WithParams: Parameter, Progress: {
                            (process)in
                            print("my:",process)
                        }, Success: { (DataResponce, Status, Message) in
                        if(Status == true){
                            let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                            let StatusCode = DataResponce?["status"] as? Int
                            if (StatusCode == 200){
                         
                                if let Data = dataResponce["data"] as? NSDictionary{
                                if let videoKey = Data["unique_id"] as? String{
                                    self.unique_id = videoKey
                                    Parameter["unique_id"] = videoKey
                                }
                                group.leave()
                                }
                                }
                                else if(StatusCode == 401)
                                {
                                    if let errorMessage:String = Message{
                                                                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                                                                            group.leave()

                                                                                appDelegate.setLoginVC()
                                                                                // Fallback on earlier versions
                                                                            
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    group.leave()

                                                                    if let errorMessage:String = dataResponce["message"] as? String{
                                                                        showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                                                                    }
                                                                }
                                                            }
                                                            else{
                                                                group.leave()

                                                                if let errorMessage:String = Message{
                                                                    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                                                                }
                                                            }
                        }) { (DataResponce, Status, Message) in
                                                            //
                                                        }
                                                group.wait()
//                        self.WSUploadVideoR(Parameter: ["lat":self.latitude.description,"long":self.longitude.description,"type":"video","unique_id":self.unique_id], chunk: FUrl)
                    }
                    
                        
                    }
                    
                }
            }
        }

    
    func fileintoChunk(filepath:URL){
        var tempID:String = ""
        let a = sizePerMB(url: filepath)
        print("video size:",a)
        //let path = Bundle.main.url(forAuxiliaryExecutable: self.videoRecorded!.absoluteString)
        let size = self.fileSize(forURL: filepath)
        print("Filte Size : ",size)
                  do
                  {
                    let data = try Data(contentsOf: filepath, options:.init())


                    //let data = try Data(contentsOf: filepath)
                    let dataLen = data.count
                    let chunkSize = ((1024 * 1000) * 4) // MB
                    let fullChunks = Int(dataLen / chunkSize)
                    let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)

                    var chunks:[Data] = [Data]()
                    chunks.removeAll()
                    for chunkCounter in 0..<totalChunks {
                      var chunk:Data
                      let chunkBase = chunkCounter * chunkSize
                      var diff = chunkSize
                      if(chunkCounter == totalChunks - 1) {
                        diff = dataLen - chunkBase
                      }
                      let range:Range<Data.Index> = Range<Data.Index>(chunkBase..<(chunkBase + diff))
                        chunk = data.subdata(in: range)
                        
//                        let videoDataString = NSString(data: chunk., encoding: String.Encoding.utf8.rawValue)
//                    let videoURL = NSURL(string: String(videoDataString!))
//                    print("video url",videoURL)
                        //
                      print("The size is \(chunk.count)")
                    chunks.append(chunk)

                    }
                    
                    
//                    let data = try Data(contentsOf: filepath)
//                      let dataLen = (data as NSData).length
//                    let valC = 1024*1024
//                    print("dataLen:",dataLen)
//                      let fullChunks = Int(dataLen / valC) // 1 Kbyte
//                    print("fullChunks:",fullChunks)
//                      let totalChunks = fullChunks + (dataLen % valC != 0 ? 1 : 0)
//                    print("totalChunks:",totalChunks)
//                      var chunks:[Data] = [Data]()
//                      for chunkCounter in 0..<totalChunks
//                      {
//                          var chunk:Data
//                          let chunkBase = chunkCounter * valC
//                          var diff = valC
//                          if chunkCounter == totalChunks - 1
//                          {
//                              diff = dataLen - chunkBase
//                          }
//
//                          let range:Range<Data.Index> = Range<Data.Index>(chunkBase..<(chunkBase + diff))
//                          chunk = data.subdata(in: range)
//                        print("chunks.count : ",chunks.count)
//                          chunks.append(chunk)
//                      }
 
                    let group = DispatchGroup()
            var Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":tempID]
             //   for a in chunks{
//                      if let videoURL = setupNamedPipe(withData: a)
//                    {
//                        print("video url",videoURL)
//                    //                        let player = AVPlayer(url: videoURL)
//                    }
                        group.enter()
                    ServiceManager.shared.callAPIWithVideoChunk(WithType: .upload_chunk, VideoChunk: filepath, thumbImage: UIImage(), passThumb: false, WithParams: Parameter,Progress: {
                        (process)in
                        print("my:",process)
                    },Success: { (DataResponce, Status, Message) in
                                    if(Status == true){
                                        let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                                        let StatusCode = DataResponce?["status"] as? Int
                                        if (StatusCode == 200){
                                           if let Data = dataResponce["data"] as? NSDictionary{
                                                if let videoKey = Data["unique_id"] as? String{
                                                    self.unique_id = videoKey
                                                    Parameter["unique_id"] = videoKey
                                                }
                                            group.leave()

                                        }
                                        }
                                        else if(StatusCode == 401)
                                        {
                                            if let errorMessage:String = Message{
                                                showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: errorMessage, buttons: ["Dismiss"]) { (i) in
                                                    group.leave()

                                                        appDelegate.setLoginVC()
                                                        // Fallback on earlier versions
                                                    
                                                }
                                            }
                                        }
                                        else{
                                            group.leave()

                                            if let errorMessage:String = dataResponce["message"] as? String{
                                                showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                                            }
                                        }
                                    }
                                    else{
                                        group.leave()

                                        if let errorMessage:String = Message{
                                            showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                                        }
                                    }
                    }) { (DataResponce, Status, Message) in
                                    //
                                }
                        group.wait()
    
                       // self.WSUploadVideoR(Parameter: ["lat":self.latitude.description,"long":self.longitude.description,"type":"video","unique_id":self.unique_id], chunk: a)
                        
                 //Forloop }
                      // Send chunks as you want
//                      debugPrint(chunks)
                  }
                  catch
                  {
                      // Handle error
                  }
                 
      
                   
        
       
    }
    func getFileDataInChunks() {
        
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = doumentDirectoryPath.appendingPathComponent("video.mp4")
        
        
        //Check file exits at path or not.
   //     if FileManager.default.fileExists(atPath: videoRecorded!.absoluteString) {
            
            let chunkSize = 1024 // divide data into 1 kb
            
            //Create NSMutableData object to save read data.
            let ReadData = NSMutableData()
            
            do {
                
                //open file for reading.
                outputFileHandle = try FileHandle(forReadingFrom:  self.videoRecorded!)
                
                // get the first chunk
                var datas = outputFileHandle?.readData(ofLength: chunkSize)
                
                //check next chunk is empty or not.
                while !(datas?.isEmpty)! {
                    
                    //here I write chunk data to ReadData or you can directly write to socket.
                    ReadData.append(datas!)
                    
                    // get the next chunk
                    datas = outputFileHandle?.readData(ofLength: chunkSize)
                    
                    print("Running: \(ReadData.length)")
                }
                
                //close outputFileHandle after reading data complete.
                outputFileHandle?.closeFile()
                
                print("File reading complete")
                
            }catch let error as NSError {
                print("Error : \(error.localizedDescription)")
            }
       // }
    }
    func WSVideoUploadSuces1(Parameter:[String:String]) -> Void {
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
    //Parameter:[String:String],chunk:[URL,Index:Int,
    func WSUploadVideoR(statTime:Double, endTime:Double,thumimg:UIImage,sendThum:Bool,OPUrl:URL) -> Void {
        
        var etime = statTime + 5.0
        if(etime>endTime){
            etime = endTime
        }
        if(statTime < endTime){
        self.cropVideo(sourceURL: self.videoRecorded!, startTime: statTime, endTime: etime) { (FUrl) in
        print("url :",FUrl, "Start time : ",statTime, "End time : ",etime)
            
           // arrOfChunks.append(FUrl)
            let curruntChunk = FUrl
             let Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":self.unique_id]
            ServiceManager.shared.callAPIWithVideoChunk(WithType: .upload_chunk, VideoChunk: curruntChunk, thumbImage: thumimg, passThumb: sendThum, WithParams: Parameter,Progress: {
                (process)in
                print("my:",process)
                //first?.added = value
                appDelegate.ArrLocalVideoUploading.filter({$0.url == OPUrl}).first?.progress = process!
                
                //appDelegate.objLocalVid.progress = process!
            }, Success: { (DataResponce, Status, Message) in
                if(Status == true){
                    let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                    let StatusCode = DataResponce?["status"] as? Int
                    if (StatusCode == 200){
                       if let Data = dataResponce["data"] as? NSDictionary{
                            if let videoKey = Data["unique_id"] as? String{
                                self.unique_id = videoKey
                                let strTimr = statTime + 5
                                if(strTimr >= endTime){
                                    print("video upload complete")
                                        self.WSVideoUploadSuces1(Parameter: ["unique_video_id":videoKey])
                                    appDelegate.ArrLocalVideoUploading = appDelegate.ArrLocalVideoUploading.filter({$0.url != OPUrl})
                                    //NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
                                }
                                else{
                                    appDelegate.ArrLocalVideoUploading.filter({$0.url == OPUrl}).first?.progress = 0.0
                                    self.WSUploadVideoR(statTime: strTimr, endTime:endTime, thumimg: thumimg, sendThum: false,OPUrl: self.videoRecorded!)
                                }
                            }
                    }
                    }
                    else if(StatusCode == 401)
                    {
                     //   self.myGroup.leave()
                        self.WSUploadVideoR(statTime: statTime, endTime:endTime, thumimg:thumimg, sendThum: false,OPUrl: self.videoRecorded!)
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
//    func generateThumbnail(path: URL) -> UIImage? {
//        do {
//            let asset = AVURLAsset(url: path, options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//            return thumbnail
//        } catch let error {
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//            return nil
//        }
//    }
     func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
         if (error != nil) {
            self.StopTimer()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.timeView.isHidden = true
            stopRecording()
            stopSession()
            
             print("Error recording movie: \(error!.localizedDescription)")

         } else {
            //self.thumbImageForVide =  generateThumbnail(path: self.outputURL)!
             videoRecorded = outputURL! as URL
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            print("recorded video url :",videoRecorded!)
            let asset = AVAsset(url: videoRecorded!)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            self.getThumbnailImageFromVideoUrl(url: videoRecorded!) { (AthumbImage) in
                //self.thumbImageForVide = AthumImage
            let objLocalVid:localVideoModel = localVideoModel()
            objLocalVid.url = self.videoRecorded
            objLocalVid.thumbImage = AthumbImage
            objLocalVid.name = "video\(Date().description).mp4"
            appDelegate.ArrLocalVideoUploading.append(objLocalVid)
            self.WSUploadVideoR(statTime: 0.0, endTime:Double(durationTime), thumimg: AthumbImage!, sendThum: true ,OPUrl: outputFileURL)
            }
                    //    DispatchQueue.background(background: {
                            // do something in background
           
//                        }, completion:{
//                            // when background job finished, do something in main thread
//                        })

//            self.passVideoFortrim(videoUrl: outputFileURL)
         //   self.cropVideo(sourceURL: outputURL, startTime: StartTime, endTime: EndTime) { (FUrl) in
                                  //print("url :",FUrl, "Start time : ",StartTime, "End time : ",EndTime)
                                                // UISaveVideoAtPathToSavedPhotosAlbum(FUrl.path, nil, nil, nil)
            //}
//            DispatchQueue.background(background: {
//                // do something in background
//             //   self.trimVideoAndUpload(filepath: outputFileURL)
//               // self.fileintoChunk(filepath: outputFileURL)
//               // self.getFileDataInChunks()
//                            
//            }, completion:{
//                // when background job finished, do something in main thread
//            })
            print(videoRecorded!.lastPathComponent)
            print(videoRecorded!.pathExtension)
            print("mimeType",videoRecorded?.mimeType())
            //  self.WSUploadImage(Parameters: ["lat":self.latitude.description,"long":self.longitude.description,"type":"image"], img: videoRecorded)
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum((videoRecorded?.path)!))
            {
                          // UISaveVideoAtPathToSavedPhotosAlbum((videoRecorded?.path)!, self, #selector(self.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
                       }
        //     performSegue(withIdentifier: "showVideo", sender: videoRecorded)

         }

     }

  func toggleTorch(on: Bool) {
      guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
      guard device.hasTorch else { print("Torch isn't available"); return }

      do {
          try device.lockForConfiguration()
          device.torchMode = on ? .on : .off
          // Optional thing you may want when the torch it's on, is to manipulate the level of the torch
        if on { try device.setTorchModeOn(level: 1.0) }
          device.unlockForConfiguration()
      } catch {
          print("Torch can't be used")
      }
  }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
       }
       
       // MARK: - ViewController
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            }
            else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
       @IBAction func changeFlashMode(_ sender: UIButton) {
        
        if(isFlashOn == true){
            isFlashOn = false
            self.toggleTorch(on: false)
            sender.setImage(#imageLiteral(resourceName: "ic_flash_off"), for: .normal)
            //sender.setImage( imageLiteral(resourceName: "ic_flash_off"), for: .normal)
        }
        else{
            isFlashOn = true
            sender.setImage(#imageLiteral(resourceName: "ic_flash"), for: .normal)
            //sender.setImage( imageLiteral(resourceName: "ic_flash"), for: .normal)
            self.toggleTorch(on: true)
        }
//        cameraManager.flashMode = cameraManager.flashMode == .off ? .on : .off
        
       
       }
    func changeCam(){}
    @IBAction func changeCamera(_ sender: UIButton){
              guard let currentCameraInput: AVCaptureInput = captureSession.inputs.first else {
                  return
              }
              //Indicate that some changes will be made to the session
              captureSession.beginConfiguration()
              captureSession.removeInput(currentCameraInput)
                if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                    for input in inputs {
                        captureSession.removeInput(input)
                    }
                }

              //Get new input
              var newCamera: AVCaptureDevice! = nil
              if let input = currentCameraInput as? AVCaptureDeviceInput {
                  if (input.device.position == .back) {
                      newCamera = cameraWithPosition(position: .front)
                  } else {
                      newCamera = cameraWithPosition(position: .back)
                  }
              }

              //Add input to session
              var err: NSError?
              var newVideoInput: AVCaptureDeviceInput!
              do {
                  newVideoInput = try AVCaptureDeviceInput(device: newCamera)
              } catch let err1 as NSError {
                  err = err1
                  newVideoInput = nil
              }

              if newVideoInput == nil || err != nil {
                  print("Error creating capture device input: \(err?.localizedDescription)")
              } else {
                  captureSession.addInput(newVideoInput)
              }

              //Commit all the configuration changes at once
              captureSession.commitConfiguration()
          
    }
    @objc func StopTimer() {
        durationTxt.text = ""
        timer.invalidate()
        seconds = 0

    }
    @objc func updateTimer() {
         if seconds > 36000 {
              timer.invalidate()
              //Send alert to indicate "time's up!"
         } else {
              seconds += 1
              durationTxt.text = timeString(time: TimeInterval(seconds))
         }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
         isTimerRunning = true
         //pauseButton.isEnabled = true
    }
    func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func recordVideo(_ sender: UIButton){

        if(movieOutput.isRecording == false){
//            if let videoConnection = cameraOutput.connection(with: AVMediaType.video) {
//                // Adjust the orientaion of captured image
//                let capturePhotoSetting = AVCapturePhotoSettings.init(from: photoSetting)
//                videoConnection.videoOrientation = (previewLayer.connection?.videoOrientation)!
//                // Save captured photo to system album
//                self.cameraOutput.capturePhoto(with: capturePhotoSetting, delegate: self)
//            }
            DispatchQueue.main.async {
                self.previewLayer.frame = self.camPreview.bounds
                self.camPreview.layer.addSublayer(self.previewLayer)
            }

            self.runTimer()
            sender.setImage(#imageLiteral(resourceName: "ic_videorecordStop"), for: .normal)
            self.btnChangeCam.isEnabled = false
            self.btnChangeCam.alpha = 0.5
//            sender.setImage( imageLiteral(resourceName: "ic_videorecordStop"), for: .normal)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.timeView.isHidden = false
            startRecording()

        }
        else{
            self.StopTimer()
            sender.setImage(#imageLiteral(resourceName: "ic_videorecordStart"), for: .normal)
            self.btnChangeCam.isEnabled = true
            self.btnChangeCam.alpha = 1.0
            //sender.setImage( imageLiteral(resourceName: "ic_videorecordStart"), for: .normal)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.timeView.isHidden = true


            stopRecording()

        }
    }
  // MARK: - video management
    func callservice(arrOfChunks:[URL]){
        var tempID = ""
        var Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":tempID]

        let GroupSync2 = DispatchGroup()

            for chURL in arrOfChunks {
                GroupSync2.enter()

                ServiceManager.shared.callAPIWithVideoChunk(WithType: .upload_chunk, VideoChunk: chURL, thumbImage: UIImage(), passThumb: false, WithParams: Parameter,Progress: {
                    (process)in
                    print("my:",process)
                }, Success: { (DataResponce, Status, Message) in
                            if(Status == true){
                                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                                let StatusCode = DataResponce?["status"] as? Int
                                if (StatusCode == 200){
                                   if let Data = dataResponce["data"] as? NSDictionary{
                                    GroupSync2.leave()
                                        if let videoKey = Data["unique_id"] as? String{
                                            
                                            self.unique_id = videoKey
                                           Parameter["unique_id"] = videoKey
                                        }
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
                GroupSync2.leave()
            }
    }
    func passVideoFortrim(videoUrl:URL){
        var arrOfChunks = [URL]()
        let Parameter = ["lat":self.latitude.description,"long":self.longitude.description,"unique_id":self.unique_id]

        let asset = AVAsset(url: videoUrl)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        //print("recorded video duration seconds : ",durationTime)

            // do something in background
            var VideoStartTime:Double = 0.0, VideoEndTime:Double = Double(durationTime)
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                
                let gameCompleted = true

                repeat {

                if(Int(round(durationTime))%5 == 0){

                }
                else{
                    VideoEndTime = VideoEndTime - Double(Int(durationTime)%5)
                }
                            
                    

                print("VideoStartTime",round(VideoStartTime))
                let st = VideoStartTime
                
                    if(VideoEndTime<5){
                        VideoStartTime += VideoEndTime
                    }
                    else{
                        VideoStartTime += 5

                    }
                let et = VideoStartTime
                print("VideoEndTime",et)


                
                
                
            }while (VideoStartTime <= VideoEndTime)
                
                
                
                
//            for n in 0 ... Int(VideoEndTime)/5 {
//                let st = VideoStartTime
//                VideoStartTime += 5
//                    let et = VideoStartTime
//                print(n)
//               // group.wait()
//                self.cropVideo(sourceURL: self.outputURL, startTime: st, endTime: et) { (FUrl) in
//                print("\(st):","url :",FUrl, "Start time : ",st, "End time : ",et)
//                    arrOfChunks.append(FUrl)
//                    if(Int(et) == Int(VideoEndTime)){
//                        group.leave()
//                    }
//
//                }
//                }
            // Do work asyncly and call group.leave() after you are done
        }
        group.notify(queue: .main, execute: {
        //    self.WSUploadVideoR(Parameter: Parameter, chunk: arrOfChunks, Index: 0)
            // This will be called when block ends
        })


        DispatchQueue.background(background: {

            
//            while (VideoStartTime <= VideoEndTime) {
//            //play game
//
//                let st = VideoStartTime
//                VideoStartTime += 1
//                let et = VideoStartTime
//                self.cropVideo(sourceURL: self.outputURL, startTime: st, endTime: et) { (FUrl) in
//                    print("\(st):","url :",FUrl, "Start time : ",st, "End time : ",et)
//                    arrOfChunks.append(FUrl)
//                    myGroup.wait() //// When your task completes
//
//                }
//
//
//            }
            }, completion:{

                
                    
                        // when background job finished, do something in main thread
                    })

        

            //self.callservice(arrOfChunks: arrOfChunks)

          //  }, completion:{
                  //    GroupSync.leave()
              // when background job finished, do something in main thread
            ///      })


      
          
        
        
//            for i in 0 ..< 5 {
//                self.myGroup.enter()
//                self.cropVideo(sourceURL: outputURL, startTime: StartTime, endTime: EndTime) { (FUrl) in
//                           print("url :",FUrl, "Start time : ",StartTime, "End time : ",EndTime)
//                    myGroup.leave()
//
//                }
//                }
            
           
        
      

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
extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
extension recordVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil else {
            print("Photo Error: \(String(describing: error))")
            return
        }

        guard let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let outputData =  AVCapturePhotoOutput
            .jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) else {
                    print("Oops, unable to create jpeg image")
            return
        }

        print("captured photo...")
        loadImage(data: outputData)
    }

    func loadImage(data: Data) {
        let dataProvider = CGDataProvider(data: data as CFData)
        let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        self.thumbImageForVide = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
        // do whatever you like with the generated image here...
        //delegate?.processVideoSnapshot(image)
    }
}
