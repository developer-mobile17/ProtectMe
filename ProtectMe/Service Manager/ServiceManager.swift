//
//  ServiceManager.swift
//  KYT
//
//  Created by Kavin Soni on 14/11/19.
//  Copyright © 2019 Kavin Soni. All rights reserved.
//

import UIKit
import Alamofire

import SystemConfiguration
var FileUploafProgress = Double()
typealias ApiCallSuccessBlock = (Bool,NSDictionary) -> Void
typealias ApiCallFailureBlock = (Bool,NSError?,NSDictionary?) -> Void
typealias APIResponseBlock = ((_ response: NSDictionary?,_ isSuccess: Bool,_ error: String?)->())

typealias APIResponseBlockImage = ((_ param:[String:Any], _ imgURL:String, _ isSuccess: Bool,_ error: String?)->())


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
enum APITYPE {
    
    
    case register_user
    case login
    case social_login
    case logout
    case edit_profile
    case forgot
    case notification
    case get_user_data
    case change_password
    case add_linked_account
    case linked_account_list
    case change_location_service
    case change_voice_action
    case sender_account_setting
    case new_link_account_setting
    case termsandcondition
    case privacy_policy
    case unlink_account
    case edit_linked_account
    case archived_list
    case change_email_notification
    case linked_account_action
    case resend_request
    case upload_file
    case delete_file
    case rename_file
    case upload_thumb
    case folderList
    case create_folder
    
    func getEndPoint() -> String {
        
        switch self {
        case .register_user:
            return "register_user"
        case .login:
            return "login"
        case .social_login:
            return "social_login"
        case .logout:
            return "logout"
        case .edit_profile:
            return "edit_profile"
        case .forgot:
            return "forgot"
        case .notification:
            return "notification"
        case .get_user_data:
            return "get_user_data"
        case .change_password:
            return "change_password"
        case .add_linked_account:
            return "add_linked_account"
        case .linked_account_list:
            return "linked_account_list"
        case .change_location_service:
            return "change_location_service"
        case .change_voice_action:
            return "change_voice_action"
        case .sender_account_setting:
            return "sender_account_setting"
        case .new_link_account_setting:
            return "new_link_account_setting"
        case .termsandcondition:
            return "content/term"
        case .privacy_policy:
            return "content/privacy_policy"
        case .unlink_account:
            return "unlink_account"
        case .edit_linked_account:
            return "edit_linked_account"
        case .archived_list:
            return "archived_list"
        case .change_email_notification:
            return "change_email_notification"
        case .linked_account_action:
            return "linked_account_action"
        case .resend_request:
            return "resend_request"
        case .upload_file:
            return "upload_file"
        case .delete_file:
            return "delete_file"
        case .rename_file:
            return "rename_file"
        case .upload_thumb:
            return "upload_thumb"
        case .folderList:
            return "folderList"
        case .create_folder:
            return "create_folder"
        }
    }
}


class ServiceManager: NSObject{
    
    
    //MARK:- Singleton
    static let shared:ServiceManager = ServiceManager()
    
    // MARK: - Static Variable
    let baseURL = "http://deluxcoder.com/beta/protectme/ws/v1/user/"
    
    
    static var previousAPICallRequestParams:(APITYPE,[String:Any]?)?
    
    static var previousAPICallRequestMultiParams:(APITYPE,[[String:Any]]?)?
    
    func callAPI(WithType apiType:APITYPE, WithParams params:String, Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if isInternetAvailable() == true {
            
        }else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            return
        }
        
        
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            
            print("------  Parameters --------")
            print(params)
            print("------  Parameters --------")
            
            
            let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())/\(params)"
            
            print(apiUrl)
            SHOW_CUSTOM_LOADER()
            
            Alamofire.request(apiUrl, method: .get, parameters:[:], encoding: URLEncoding.default, headers:[:]).responseJSON
                { (response) in
                    
                    switch response.result{
                        
                    case .success(let json):
                        
                        print(json)
                        let mainStatusCode:Int = (response.response?.statusCode)!
                        HIDE_CUSTOM_LOADER()
                        
                        if let jsonResponse = json as? NSDictionary
                        {
                            
                            successBlock(jsonResponse, true, nil)
                            
                            
                        }else{
                            print("Json Object is not NSDictionary : Please Check this API \(apiType.getEndPoint())")
                            successBlock(nil, true, nil)
                        }
                        
                        break
                    case .failure(let _):
                        // You Got Failure :(
                        HIDE_CUSTOM_LOADER()
                        
                        print("Response Status Code :: \(response.response?.statusCode ?? 400)")
                        let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        print(datastring ?? "Test")
                        failureBlock(nil,false,"")
                        break
                    }
            }
        }else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            //            (alertController, animated: true, completion: nil)
        }
    }
    
    
    func getLatLongFromAddress(address:String, Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void {
        let apiUrl = ""
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            
            
            var headers: HTTPHeaders = [:]
            
            headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            print(apiUrl)
            SHOW_CUSTOM_LOADER()
          
            
            Alamofire.request(apiUrl, method: .post, parameters: ["address":address],encoding:
                URLEncoding.default, headers: headers).responseJSON
                { (response) in
                    
                    switch response.result {
                    case .success(let json):
                        HIDE_CUSTOM_LOADER()
                        print(json)
                        
                        if let jsonResponse = json as? NSDictionary
                        {
                            successBlock(jsonResponse, true, nil)
                        }
                        
                    case .failure( _):
                        HIDE_CUSTOM_LOADER()
                        let alertController = UIAlertController(title: Constant.APP_NAME, message: "Something went wrong", preferredStyle: .alert)
                        HIDE_CUSTOM_LOADER()
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        successBlock(nil, false, nil)
                        
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                        failureBlock(nil,false,"Something went wrong.")
                    }
            }
            
        }
        else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            HIDE_CUSTOM_LOADER()
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            //            (alertController, animated: true, completion: nil)
        }
    }
    
    func callAPIPost(WithType apiType:APITYPE,isAuth:Bool, WithParams params:[String:Any], Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            
            print("------  Parameters --------")
            print(params)
            print("------  Parameters --------")
            
            
            var headers: HTTPHeaders = [:]//
            
            
                if isAuth == true{
                    let apitocken = USER.shared.vAuthToken
                    
                    headers = ["Accept":"application/json","Vauthtoken":"Bearer " + apitocken]
                }
            
            
            let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())"
            print("headers :",headers)

            print("apiUrl :",apiUrl)
            
            SHOW_CUSTOM_LOADER()
            
            
            Alamofire.request(apiUrl, method: .post, parameters: params,encoding:
                URLEncoding.default, headers: headers).responseJSON
                { (response) in
                    
                    switch response.result {
                    case .success(let json):
                        HIDE_CUSTOM_LOADER()
                        print(json)
                        
                        if let jsonResponse = json as? NSDictionary
                        {
                            successBlock(jsonResponse, true, nil)
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                                               print("\n\n===========Error===========")
                                               print("Error Code: \(error._code)")
                                               print("Error Messsage: \(error.localizedDescription)")
                                               if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                                                   print("Server Error: " + str)
                                               }
                                               debugPrint(error as Any)
                                               print("===========================\n\n")
                        HIDE_CUSTOM_LOADER()
                        let alertController = UIAlertController(title: Constant.APP_NAME, message: "Something went wrong", preferredStyle: .alert)
                        HIDE_CUSTOM_LOADER()
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        successBlock(nil, false, nil)
                        
                        let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                        
                        // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
                        // keyWindow.makeKeyAndVisible()
                        keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                        failureBlock(nil,false,"Something went wrong.")
                    }
            }
            
        }
        else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            HIDE_CUSTOM_LOADER()
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            //            (alertController, animated: true, completion: nil)
        }
    }
    
    
    
    ////********************************************
    
    
    func callAPIWithoutLoader(WithType apiType:APITYPE, WithParams params:String, Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            
            print("------  Parameters --------")
            print(params)
            print("------  Parameters --------")
            
            
            let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())/\(params)"
            
            print(apiUrl)
            //SwiftLoader.show(animated: true)
            //            let apiUrl:String = "https://api.instagram.com/v1/users/self"///?access_token=Rgfe_rd=cr&ei=RFE9WdGhIfDy8Ae7pI2YBg&gws_rd=ssl
            Alamofire.request(apiUrl, method: .get, parameters:[:], encoding: URLEncoding.default, headers:[:]).responseJSON
                { (response) in
                    
                    switch response.result{
                        
                    case .success(let json):
                        
                        // You got Success :)
                        print(json)
                        //  print("Response Status Code :: \(response.response?.statusCode)")
                        //                        print(json as! NSDictionary)
                        
                        if let jsonResponse = json as? NSDictionary
                        {
                            
                            print(jsonResponse)
                            
                            if jsonResponse.value(forKey: "Status") as! String == "true"{
                                
                                //                                if ((jsonResponse.value(forKey: "data") as? NSDictionary) != nil){
                                
                                // let resultDict = jsonResponse.value(forKey: "data") as? NSDictionary
                                successBlock(jsonResponse, true, nil)
                                //                                }else{
                                //
                                //                                    successBlock(nil, true, nil)
                                //
                                //                                }
                            }else{
                                
                                if ((jsonResponse.value(forKey: "data") as? NSDictionary) != nil){
                                    let resultDict = jsonResponse.value(forKey: "data") as? NSDictionary
                                    
                                    successBlock(resultDict, false, nil)
                                }else{
                                    successBlock(nil, false, nil)
                                }
                                
                            }
                            
                        }else{
                            print("Json Object is not NSDictionary : Please Check this API \(apiType.getEndPoint())")
                            successBlock(nil, true, nil)
                        }
                        
                        break
                    case .failure(let error):
                        // You Got Failure :(
                        HIDE_CUSTOM_LOADER()
                        
                        print("Response Status Code :: \(response.response?.statusCode ?? 00 )")
                        let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        print(datastring ?? "Test")
                        failureBlock(nil,false,error as? String)
                        break
                    }
            }
        }else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            //            (alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func callPutAPI(WithType apiType:APITYPE , passString:String , isHeader:Bool, WithParams params:[String:Any], Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            
            print("------  Parameters --------")
            print(params)
            print("------  Parameters --------")
            
            var headers: HTTPHeaders = [:]//
            if isHeader == true {
                headers = [
                    
                    "Content-Type": "application/x-www-form-urlencoded"//,"application/json",
                    //                    "Authorization": tokenPass
                ]
            }
            
            let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())/\(passString)"
            SHOW_CUSTOM_LOADER()
            
            Alamofire.request(apiUrl, method: .put, parameters:params, encoding: URLEncoding.default, headers:headers).responseJSON
                { (response) in
                    
                    switch response.result{
                        
                    case .success(let json):
                        HIDE_CUSTOM_LOADER()
                        
                        print(json)
                        
                        if let jsonResponse = json as? NSDictionary
                        {
                            
                            if jsonResponse.value(forKey: "success") as! Bool == true  {
                                if let dict  = jsonResponse.value(forKey: "data") as? NSDictionary{
                                    successBlock(dict, true, nil)
                                }else{
                                    successBlock(jsonResponse, true, nil)
                                }
                                
                            }else{
                                
                                print("Json Object is not NSDictionary : Please Check this API \(apiType.getEndPoint())")
                                let msg = jsonResponse.value(forKey: "message") as? String
                                //                            successBlock(nil, false, msg )
                                failureBlock(nil,false,msg)
                                
                            }
                        }
                        
                        break
                    case .failure(let error):
                        // You Got Failure :(
                        HIDE_CUSTOM_LOADER()
                        
                        print("Response Status Code :: \(String(describing: response.response?.statusCode))")
                        let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                        print(datastring ?? "Test")
                        failureBlock(nil,false,error as? String)
                        break
                    }
            }
        }else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            HIDE_CUSTOM_LOADER()
            
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func callGetAPI(WithType apiType:APITYPE , isAuth:Bool, passString:String, WithParams params:[String:Any], Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            var headers: HTTPHeaders = [:]//

            if isAuth == true{
                let apitocken = USER.shared.vAuthToken
                print(apitocken)
                headers = ["Vauthtoken":"Bearer " + apitocken]
            }
            print("------  Parameters --------")
            print(params)
            print("------  Headers --------")
            print(headers)
          
            
         
            
            let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())\(passString)"
            
            print(apiUrl)
            //SwiftLoader.show(animated: true)
            SHOW_CUSTOM_LOADER()
            
            Alamofire.request(apiUrl, method: .get, parameters:params, encoding: URLEncoding.default, headers:headers).responseJSON
                { (response) in
                    
                    switch response.result{
                        
                    case .success(let json):
                        HIDE_CUSTOM_LOADER()
                        let status:Int = response.response!.statusCode
                        print("service statuscode \(String(status))")

                        if status == 401 {
                            USER.shared.clear()
                            
                        }
                        if let jsonResponse = json as? NSDictionary
                        {
                            print(json)
                            
                            successBlock(jsonResponse,true,nil)
                        }
                        break
                    case .failure(let error):
                        // You Got Failure :(
                        HIDE_CUSTOM_LOADER()

                        if (response.response != nil) {
                            let status:Int = response.response!.statusCode
                                                   print("service statuscode \(String(status))")

                                                   print("Response Status Code :: \(String(describing: response.response?.statusCode))")
                                                   let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                                                   print(datastring ?? "Test")
                                                   failureBlock(nil,false,error as? String)
                        }else {
                            failureBlock(nil,false, "")

                        }
                       
                        break
                    }
            }
        }else{
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            HIDE_CUSTOM_LOADER()
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            
            //            (alertController, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: check internet connection
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
        
    
    
    func callAPIWithVideo(WithType apiType:APITYPE,VideoUrl:URL,WithParams params:[String:Any], Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
        {
            
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
                // do some tasks..
                /* API URL */
                
                print("------  Parameters --------")
                print(params)
                print("------  Parameters --------")
                
                
                let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())"
                print(apiUrl)
                let apitocken = USER.shared.vAuthToken
    //            let apitocken = UserDefaults.standard.string(forKey: kapiToken)
                print(apitocken)
                var headers: HTTPHeaders = [:]//

                headers = ["Vauthtoken":"Bearer " + apitocken,"Content-type": "multipart/form-data",
                "Content-Disposition" : "form-data"]
              //  SHOW_CUSTOM_LOADER()
                Alamofire.upload (multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        print("key: \(key),value : \(value)")
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
                    if let videoUrl = VideoUrl as? URL {
                        multipartFormData.append(videoUrl, withName: "file", fileName: "Video\(Date().description).mov", mimeType: "video/mp4")
                                   }
                    
                },to:apiUrl, headers:headers)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):

                        upload.uploadProgress(closure: { (progress) in
                            FileUploafProgress = progress.fractionCompleted
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            print(response.result.value ?? "")
                            
                            if let jsonResponse = response.result.value as? NSDictionary
                            {
                                HIDE_CUSTOM_LOADER()

                                successBlock(jsonResponse, true, nil)
         
                                
                            }else{
                                HIDE_CUSTOM_LOADER()
                                
                                let alertController = UIAlertController(title: Constant.APP_NAME, message: "Something went wrong.", preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                
                                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                                
                                keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                                
                                print(response)
                                print("Json Object is not NSDictionary : Please Check this API \(apiType.getEndPoint())")
                                successBlock(nil, true, nil)
                            }
                        }
                        
                    case .failure(let encodingError):
                        HIDE_CUSTOM_LOADER()
                        
                        print(encodingError)
                    }
                }
                
            }else{
                HIDE_CUSTOM_LOADER()
                
                let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                
                // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
                // keyWindow.makeKeyAndVisible()
                keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                // (alertController, animated: true, completion: nil)
            }
        }
    func callAPIWithMultipleImage(WithType apiType:APITYPE, imageUpload:[UIImage],WithParams params:[String:Any], Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            
            print("------  Parameters --------")
            print(params)
            print("------  Parameters --------")
            
            
            let apiUrl:String = "\(self.baseURL)\(apiType.getEndPoint())"
            print(apiUrl)

            let apitocken = USER.shared.vAuthToken
//            let apitocken = UserDefaults.standard.string(forKey: kapiToken)
            print(apitocken)
            var headers: HTTPHeaders = [:]//

            headers = ["Vauthtoken":"Bearer " + apitocken,"Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"]
            //            let apiUrl:String = "\(self.baseURL)/\(self.APIVersion)/\(apiType.getEndPoint())"
            //SwiftLoader.show(animated: true)
            SHOW_CUSTOM_LOADER()
            Alamofire.upload (multipartFormData: { multipartFormData in
                
                for (key, value) in params {
                    print("key: \(key),value : \(value)")
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }

                for img in imageUpload {
                    guard let imgData = img.jpegData(compressionQuality: 0.4) else { return }
                    multipartFormData.append(imgData, withName: "file", fileName: "image\(Date().description)" + ".jpeg", mimeType: "image/jpeg")
                }
                
                
                
//                for (key, value) in params {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "image")
//                }
            },to:apiUrl, headers:headers)
            { (result) in
                switch result {
                    
                    
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        if #available(iOS 11.0, *) {
                            print("Upload estimatedTimeRemaining: \(String(describing: progress.estimatedTimeRemaining))")
                        } else {
                            // Fallback on earlier versions
                        }
                        if #available(iOS 11.0, *) {
                            print("Upload fileOperationKind: \(String(describing: progress.fileOperationKind))")
                        } else {
                            // Fallback on earlier versions
                        }
                        if #available(iOS 11.0, *) {
                            print("Upload fileOperationKind: \(String(describing: progress.fileURL))")
                        } else {
                            // Fallback on earlier versions
                        }

                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print(response.result.value ?? "")
                        
                        if let jsonResponse = response.result.value as? NSDictionary
                        {
                            HIDE_CUSTOM_LOADER()

                            successBlock(jsonResponse, true, nil)
     
                            
                        }else{
                            HIDE_CUSTOM_LOADER()
                            
                            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Something went wrong.", preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
                            
                            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                            
                            print(response)
                            print("Json Object is not NSDictionary : Please Check this API \(apiType.getEndPoint())")
                            successBlock(nil, true, nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    HIDE_CUSTOM_LOADER()
                    
                    print(encodingError)
                }
            }
            
        }else{
            HIDE_CUSTOM_LOADER()
            
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            // (alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func callPutAPIWithMultipleImage(WithType apiType:APITYPE, imageUpload:UIImage,WithParams params:[String:Any], Success successBlock:@escaping APIResponseBlock, Failure failureBlock:@escaping APIResponseBlock) -> Void
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
            /* API URL */
            
            print("------  Parameters --------")
            print(params)
            print("------  Parameters --------")
            
            
            
            var headers: HTTPHeaders = [:]//
            headers = [:]
            
            
            
            
            let apiUrl:String = "\(self.baseURL)/\(apiType.getEndPoint())"
            
            SHOW_CUSTOM_LOADER()
            
            Alamofire.upload ( multipartFormData: { multipartFormData in
                
                print(imageUpload)
                if let imageData =
                    imageUpload.jpegData(compressionQuality: 0.05) {
                    
                    multipartFormData.append(imageData, withName: "reviewImage",fileName: "reviewPicc.jpg", mimeType: "image/jpg")
                }
                
                
                for (key, value) in params {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            },to:apiUrl,method:.put,headers:headers)
            { (result) in
                switch result {
                    
                    
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print(response.result.value ?? "")
                        
                        if let jsonResponse = response.result.value as? NSDictionary
                        {
                            successBlock(jsonResponse, true, "")
                            HIDE_CUSTOM_LOADER()
                            
                        }else{
                            HIDE_CUSTOM_LOADER()
                            
                        }
                    }
                    
                case .failure(let encodingError):
                    HIDE_CUSTOM_LOADER()
                    
                    print(encodingError)
                }
            }
            
        }else{
            HIDE_CUSTOM_LOADER()
            
            let alertController = UIAlertController(title: Constant.APP_NAME, message: "Internet Connection seems to be offline", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            let keyWindow: UIWindow? = UIApplication.shared.keyWindow
            
            // let appWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            // keyWindow.makeKeyAndVisible()
            keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            // (alertController, animated: true, completion: nil)
        }
    }
    
    
    
}
