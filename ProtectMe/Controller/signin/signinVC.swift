//
//  signinVC.swift
//  ProtectMe
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices

protocol SignupVCdelegate {
    func copydata(data:socialModel)
}

class signinVC: UIViewController {
    let appleSignIn = HSAppleSignIn()
    var SocialData:socialModel = socialModel()
    var latitude:Double = 0.0
     var longitude:Double = 0.0
    var delegate: SignupVCdelegate!

  
    @IBOutlet weak var txtpassword:AIBaseTextField!{
        didSet{
            txtpassword.leftIcon = #imageLiteral(resourceName: "ic_password")
            txtpassword.validationType = .password
            txtpassword.config.textFieldKeyboardType = .password
            txtpassword.config.minLength = 6
            txtpassword.config.maxLength = 16
        }
    }
    @IBOutlet weak var txtemail:AIBaseTextField!{
        didSet{
            txtemail.leftIcon = #imageLiteral(resourceName: "ic_email")
            txtemail.validationType = .email
            txtemail.config.textFieldKeyboardType = .email
            
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func getLocation(){
        let locationManager = LocationManager.sharedInstance
           locationManager.showVerboseMessage = false
           locationManager.autoUpdate = true
         //   locationManager.startUpdatingLocation()
           locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
               self.latitude = latitude
               self.longitude = longitude
               print("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
               //print(verboseMessage)
            locationManager.autoUpdate = false
           }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getLocation()
        self.navigationController?.navigationBar.isHidden = true
    }
  
    @IBAction func btnBackClick(_ sender: Any) {
        USER.shared.isLogout = false
        USER.shared.save()
              self.navigationController?.popViewController(animated: true)
          }
    @IBAction func btnLoginClick(_ sender: Any) {
        guard let text = txtemail.text, !text.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
            return
        }
        guard let ptext = txtpassword.text, !ptext.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMissing)
            return
        }
        guard let pltext = txtpassword.text,  !pltext.isHaveMinmumPassword() == false else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMin6DigitMissing)
            return
        }
        WSLogin(Parameter: ["email":txtemail.text!,"password":txtpassword.text!,"eDeviceType":"IOS","vPushToken":appDelegate.FCMdeviceToken,"latitude":self.latitude.description,"longitude":self.longitude.description])
    }
    @IBAction func btnForgotClick(_ sender: Any) {
        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "forgotVC") as! forgotVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnGoogleClick(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    @available(iOS 13.0, *)
    @IBAction func addSignInWithAppleButton(){
             let appleIDProvider = ASAuthorizationAppleIDProvider()
             
             let request = appleIDProvider.createRequest()
             request.requestedScopes = [.fullName, .email]
             
             let authorizationController = ASAuthorizationController(authorizationRequests: [request])
             authorizationController.delegate = self
             authorizationController.presentationContextProvider = self
             authorizationController.performRequests()
        
      }
    func GetFacebookData()
    {
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
                if (error == nil) {
                    
                    let fbloginresult:LoginManagerLoginResult = result!
                    
                    if fbloginresult.grantedPermissions != nil
                    {
                        let permissionDictionary = [
                            "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
                        let pictureRequest = GraphRequest(graphPath: "me", parameters: permissionDictionary)
                        let _ = pictureRequest.start(completionHandler: {
                            (connection, result, error) -> Void in
                            
                            if error == nil {
                                let results = result as? NSDictionary
                                
                                
                                let profile = results?.value(forKey: "picture") as? NSDictionary
                                let data = profile?.value(forKey: "data") as? NSDictionary

                                var CheckbEmail = results?.value(forKey: "email") as? String
                                var mobilenumber = results?.value(forKey: "mobile") as? String
                                
                                print(data?["url"])
                                if CheckbEmail?.isEmpty == true ||  CheckbEmail == nil
                                {
                                    CheckbEmail = ""
                                }
                                else
                                {
                                    CheckbEmail  = (results!.value(forKey: "email") as! String)
                                }
                                if mobilenumber?.isEmpty == true ||  mobilenumber == nil
                                {
                                    mobilenumber = ""
                                }
                                else
                                {
                                    mobilenumber  = (results!.value(forKey: "mobile") as! String)
                                    
                                }
                                var registerDetail:[String:Any] = [String : Any]()

                                registerDetail["username"] = self.createString(value: results!.value(forKey: "name") as AnyObject)
                                registerDetail["name"] = self.createString(value: results!.value(forKey: "first_name") as AnyObject) + " " + self.createString(value: results!.value(forKey: "last_name") as AnyObject)
                                registerDetail["email"] = CheckbEmail
                                registerDetail["profile_image"] = data?["url"]
                                registerDetail["type"] = "facebook"
                                registerDetail["vPushToken"] = appDelegate.FCMdeviceToken
                                registerDetail["eDeviceType"] = "iOS"
                                registerDetail["checkExist"] = "1"
                                registerDetail["longitude"] = self.longitude.description
                                registerDetail["latitude"] = self.latitude.description
                                registerDetail["id"] = self.createString(value: results!.value(forKey: "id") as AnyObject)
                                registerDetail["social_id"] = self.createString(value: results!.value(forKey: "id") as AnyObject)
                                                                
                                                        
                                //EnliteUser.shared.setData(dict: registerDetail as NSDictionary)
                                //EnliteUser.shared.save()
                                self.WSSocialLogin(Parameter: registerDetail as! [String : String])
                                
    //                            self.SocialMobileNumber = mobilenumber!
    //                            self.SocialType = "facebook"
    //                            self.Socialid = results?.value(forKey: "id") as! String
    //                            self.SocialEmailAddress = CheckbEmail!
    //                            self.SocialName = results?.value(forKey: "name") as! String
    //
    //                            self.showLoader()
                                
                               // self.GetSocialData(mobile: mobilenumber!, provider: "facebook", provider_id: results?.value(forKey: "id") as! String, email: CheckbEmail!)
                                
                            } else {
                                
                                print("error \(String(describing: error.debugDescription))")
                                
                                
                            }
                        })
                        
                        let manager = LoginManager()
                        manager.logOut()
                    }
                    else
                    {
                        
                    }
                }
            }
            
        }
    @IBAction func btnFacebookLoginAction(_ sender: Any){
        GetFacebookData()
    }
/*
     {
         let fbLoginManager : LoginManager = LoginManager()
         fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
             if (error == nil) {
                 
                 let fbloginresult:LoginManagerLoginResult = result!
                 
                 if fbloginresult.grantedPermissions != nil
                 {
                     let permissionDictionary = [
                         "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large),cover.type(large)"]
                     let pictureRequest = GraphRequest(graphPath: "me", parameters: permissionDictionary)
                     let _ = pictureRequest.start(completionHandler: {
                         (connection, result, error) -> Void in
                         
                         if error == nil {
                             let results = result as? NSDictionary
                             print("Logged in : \(String(describing: results))")
                             // print("Userid : \(String(describing: FBSDKAccessToken.current().userID))")
                             let profile = self.getDictionaryFromDictionary(dictionary: results!, key: "picture")
                             let data = self.getDictionaryFromDictionary(dictionary: profile, key: "data")
                             
                             var registerDetail:[String:Any] = [String : Any]()

                      //       registerDetail["username"] = self.createString(value: results!.value(forKey: "name") as AnyObject)
                             registerDetail["name"] = self.createString(value: results!.value(forKey: "first_name") as AnyObject) + " " + self.createString(value: results!.value(forKey: "last_name") as AnyObject)
                             registerDetail["email"] = self.createString(value: results!.value(forKey: "email") as AnyObject)
                             registerDetail["profile_image"] = self.createString(value: data.value(forKey: "url") as AnyObject)
                             registerDetail["type"] = "facebook"
                             registerDetail["vPushToken"] = appDelegate.FCMdeviceToken
                             registerDetail["eDeviceType"] = "iOS"
                             registerDetail["checkExist"] = "1"
                             registerDetail["longitude"] = self.longitude.description
                             registerDetail["latitude"] = self.latitude.description
                             registerDetail["id"] = self.createString(value: results!.value(forKey: "id") as AnyObject)
                             
                             self.SocialData.type = registerDetail["type"] as? String
                             self.SocialData.email = registerDetail["email"] as? String
                             self.SocialData.name = registerDetail["name"] as? String
                             self.SocialData.social_Id = registerDetail["id"] as? String
                             
                             let userProfile = GraphRequest(graphPath: "link", parameters: [String : Any](), httpMethod: HTTPMethod(rawValue: "GET"))
                             let _ =  userProfile.start(completionHandler: {
                                 (connection, result, error) -> Void in
                                 if error == nil {
                                     print("\(error.debugDescription)")
                                 } else {
                                     print("\(String(describing: result))")
                                 }
                             })
                             
                                if(self.SocialData.email != "" || self.SocialData.name != ""){
                                     self.WSSocialLogin(Parameter: registerDetail as! [String : String])
                                }
                                else{
                                     self.WSSocialLoginCheck(Parameter: registerDetail as! [String : String])
                                 }
                             
                        
                             
                         } else {
                             
                             print("error \(String(describing: error.debugDescription))")
                         }
                     })
                     //    UserDefaults.standard.set(true, forKey:"loggedin");
                     let manager = LoginManager()
                     manager.logOut()
                 }
                 else
                 {
                     
                 }
             }
         }
     }
     */
    // MARK: - WEB Service
    func WSSocialLoginCheck(Parameter:[String:String]) -> Void {
               ServiceManager.shared.callAPIPost(WithType: .social_login, isAuth: false, WithParams: Parameter, Success:  { (DataResponce, Status, Message) in
                   if(Status == true){
                       let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                       let StatusCode = DataResponce?["status"] as? Int

                       if (StatusCode == 200 ){
               
                          if let outcome = dataResponce["data"] as? NSDictionary {
                          USER.shared.setData(dict:outcome)
                          appDelegate.setHome()
                         
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
                          //  if let errorMessage:String = dataResponce["message"] as? String{
                                self.delegate.copydata(data: self.SocialData)
                                self.popTo()
                                //    showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                            //}
                        }
                       
                       else{

                       }
                   }
                   else{
                       if let errorMessage:String = Message{
                       showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                   }
                   }
                   
               }) { (dataResponce, status, errorMessage) in
                   
               }
           }
    func WSSocialLogin(Parameter:[String:String]) -> Void {
               ServiceManager.shared.callAPIPost(WithType: .social_login, isAuth: false, WithParams: Parameter, Success:  { (DataResponce, Status, Message) in
                   if(Status == true){
                       let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                       let StatusCode = DataResponce?["status"] as? Int

                       if (StatusCode == 200 ){
               
                          if let outcome = dataResponce["data"] as? NSDictionary {
                          USER.shared.setData(dict:outcome)
                          appDelegate.setHome()
                         
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
                       else if (StatusCode == 412){
                          if let errorMessage:String = DataResponce?["message"] as? String{
                          showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                          }
                       }
                       else{

                       }
                   }
                   else{
                       if let errorMessage:String = Message{
                       showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
                   }
                   }
                   
               }) { (dataResponce, status, errorMessage) in
                   
               }
           }
    func WSLogin(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .login, isAuth: false, WithParams: Parameter, Success:  { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let outcome = dataResponce["data"] as? NSDictionary {
                    USER.shared.setData(dict:outcome)
                        appDelegate.setHome()
                  
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
            
        }) { (dataResponce, status, errorMessage) in
            
        }
    }
                     
    }
    

    
// MARK: - Apple Login
@available(iOS 13.0, *)
extension signinVC : ASAuthorizationControllerDelegate
{
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            DispatchQueue.main.async {
                
                if "\(credentials.user)" != "" {
                    print(credentials.user)
                    self.SocialData.social_Id = credentials.user
                }
                else{
                    self.SocialData.social_Id = ""
                }
                if credentials.email != nil {
                    print(credentials.email!)
                    self.SocialData.email = credentials.email!
                   // UserDefaults.standard.set("\(credentials.email!)", forKey: "User_Email")
                }
                else{
                    self.SocialData.email = ""
                }
                if credentials.fullName!.givenName != nil {
                    print(credentials.fullName!.givenName!)
                    self.SocialData.name = credentials.fullName!.givenName!
                }
                if credentials.fullName!.familyName != nil {
                    print(credentials.fullName!.familyName!)
                    self.SocialData.social_Id = credentials.fullName!.familyName!
                }
                
                var registerDetail:[String:Any] = [String : Any]()
                registerDetail["name"] = self.SocialData.name
                registerDetail["email"] = self.SocialData.email
                registerDetail["type"] = "apple"
                registerDetail["vPushToken"] = appDelegate.FCMdeviceToken
                registerDetail["eDeviceType"] = "iOS"
                registerDetail["id"] = self.SocialData.social_Id
                registerDetail["checkExist"] = "1"
                
                registerDetail["longitude"] = self.longitude.description
                registerDetail["latitude"] = self.latitude.description
                   
                if(self.SocialData.email != "" || self.SocialData.name != ""){
                    self.WSSocialLogin(Parameter: registerDetail as! [String : String])
                }
                else{
                    self.WSSocialLoginCheck(Parameter: registerDetail as! [String : String])
                   
                }
                
                        
  //              UserDefaults.standard.synchronize()
//                self.setupUserInfoAndOpenView()
            }
            
        case let credentials as ASPasswordCredential:
            DispatchQueue.main.async {
            
                if "\(credentials.user)" != "" {

                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if "\(credentials.password)" != "" {

                    UserDefaults.standard.set("\(credentials.password)", forKey: "User_Password")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
            }
            
        default :
            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    @objc func actionHandleAppleSignin()
    {
         let appleIDProvider = ASAuthorizationAppleIDProvider()
         
         let request = appleIDProvider.createRequest()
         request.requestedScopes = [.fullName, .email]
         
         let authorizationController = ASAuthorizationController(authorizationRequests: [request])
         authorizationController.delegate = self
         authorizationController.presentationContextProvider = self
         authorizationController.performRequests()
    }
    func setupUserInfoAndOpenView()
    {
        DispatchQueue.main.async {
            
//            if "\(UserDefaults.standard.value(forKey: "User_FirstName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_LastName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_Email")!)" != "" {
//
//            //    self.lblID.text = "\(UserDefaults.standard.value(forKey: "User_AppleID")!)"
//            //   self.lblFirstname.text = "\(UserDefaults.standard.value(forKey: "User_FirstName")!)"
//            //    self.lblLastname.text = "\(UserDefaults.standard.value(forKey: "User_LastName")!)"
//            //    self.lblEmail.text = "\(UserDefaults.standard.value(forKey: "User_Email")!)"
//            } else {
//
//
//            }
            
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension signinVC : ASAuthorizationControllerPresentationContextProviding
{
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
    {
        return view.window!
    }
}

    

extension signinVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let imgprofile = user.profile.imageURL(withDimension: 100)
            // ...
            var registerDetail:[String:Any] = [String : Any]()
            registerDetail["name"] = String(describing: givenName!) + " " + String(describing: familyName!)
            registerDetail["email"] = email
            registerDetail["profile_image"] = imgprofile?.absoluteString
            registerDetail["type"] = "google"
            registerDetail["vPushToken"] = appDelegate.FCMdeviceToken
            registerDetail["eDeviceType"] = "iOS"
            registerDetail["checkExist"] = "1"
            registerDetail["id"] = userId
            registerDetail["longitude"] = self.longitude.description
            registerDetail["latitude"] = self.latitude.description
            
            self.SocialData.type = registerDetail["type"] as? String
            self.SocialData.email = registerDetail["email"] as? String
            self.SocialData.name = registerDetail["name"] as? String
            self.SocialData.social_Id = registerDetail["id"] as? String
            GIDSignIn.sharedInstance()?.signOut()
            //USER.shared.setData(dict: registerDetail as NSDictionary)
            //USER.shared.save()
                if(self.SocialData.email != "" || self.SocialData.name != ""){
                            self.WSSocialLogin(Parameter: registerDetail as! [String : String])
                        }
                        else{
                            self.WSSocialLoginCheck(Parameter: registerDetail as! [String : String])
                           
                        }

            //call
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}
class socialModel: NSObject {
    var type:String?
    var social_Id:String?
    var name:String?
    var email:String?
}
