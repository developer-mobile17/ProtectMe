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
import AVKit
import CoreLocation
import Foundation
import MobileCoreServices

//import CameraEngine



class recordVC: baseVC,AVCaptureFileOutputRecordingDelegate{
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var outputFileHandle:FileHandle?

    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var timeView: UIView!
    // let cameraManager = CameraManager()
    let movieOutput = AVCaptureMovieFileOutput()
    var videoRecorded: URL? = nil
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
    func fileintoChunk(filepath:URL){
        //let path = Bundle.main.url(forAuxiliaryExecutable: self.videoRecorded!.absoluteString)
        let size = self.fileSize(forURL: filepath)
        print("Filte Size : ",size)
                  do
                  {
                    let data = try Data(contentsOf: filepath)
                      let dataLen = (data as NSData).length
                      let fullChunks = Int(dataLen / 1024) // 1 Kbyte
                      let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)

                      var chunks:[Data] = [Data]()
                      for chunkCounter in 0..<totalChunks
                      {
                          var chunk:Data
                          let chunkBase = chunkCounter * 1024
                          var diff = 1024
                          if chunkCounter == totalChunks - 1
                          {
                              diff = dataLen - chunkBase
                          }

                          let range:Range<Data.Index> = Range<Data.Index>(chunkBase..<(chunkBase + diff))
                          chunk = data.subdata(in: range)
                        print("chunks.count : ",chunks.count)
                          chunks.append(chunk)
                      }

                      // Send chunks as you want
                      debugPrint(chunks)
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
     func WSUploadVideoR(Parameter:[String:String],urll:URL) -> Void {
//        self.presentTo("uploadProgress")
        ServiceManager.shared.callAPIWithVideo(WithType:.upload_file, VideoUrl: urll,  WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
     func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

         if (error != nil) {
            self.StopTimer()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.timeView.isHidden = true
            stopRecording()
            stopSession()
            
             print("Error recording movie: \(error!.localizedDescription)")

         } else {
            
             videoRecorded = outputURL! as URL
             print(videoRecorded)
            DispatchQueue.background(background: {
                // do something in background
                self.fileintoChunk(filepath: outputFileURL)
               // self.getFileDataInChunks()
                    self.WSUploadVideoR(Parameter: ["lat":self.latitude.description,"long":self.longitude.description,"type":"video"], urll: self.videoRecorded!)
                            
            }, completion:{
                // when background job finished, do something in main thread
            })
                
                 
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
//        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
//            for input in inputs {
//                captureSession.removeInput(input)
//            }
//        }

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
