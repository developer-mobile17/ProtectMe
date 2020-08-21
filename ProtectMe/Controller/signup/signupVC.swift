//
//  signupVC.swift
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

extension signupVC:SignupVCdelegate{
    func copydata(data: socialModel) {
        self.txtName.text = data.name
        self.txtemail.text = data.email
        self.isFromLogin = true
        self.socialData = data
    }
    
    
}
class signupVC: UIViewController {
  let appleSignIn = HSAppleSignIn()
    @IBOutlet weak var viewAppleButton: UIControl!
    var isFromLogin:Bool = false
    var socialData:socialModel = socialModel()
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    @IBOutlet weak var ViewPopup:UIControl!
    @IBOutlet weak var fbloginButton:UIControl!
    @IBOutlet weak var googleloginButton:UIControl!

    //@IBOutlet weak var tblView:UITableView!

    @IBOutlet weak var txtName:AIBaseTextField!{
          didSet{
              txtName.leftIcon = #imageLiteral(resourceName: "ic_name")
            txtName.validationType = .name
              txtName.config.textFieldKeyboardType = .name

          }
      }
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
      @IBOutlet weak var txtConfirmpassword:AIBaseTextField!{
             didSet{
                txtConfirmpassword.leftIcon = #imageLiteral(resourceName: "ic_password")
                txtConfirmpassword.validationType = .password
                txtConfirmpassword.config.textFieldKeyboardType = .password
                txtConfirmpassword.config.minLength = 6
                txtConfirmpassword.config.maxLength = 16
             }
         }
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginButton.center = view.center
     //   self.fbloginButton.addSubview(loginButton)

        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }

        // Swift
        //
        // Extend the code sample from 6a. Add Facebook Login to Your Code
        // Add to your viewDidLoad method:
       // loginButton.permissions = ["public_profile", "email"]
        
        // Do any additional setup after loading the view.
    }
    
     @IBAction func btnSkipClick(_ sender: Any) {
             let vc = storyBoards.Main.instantiateViewController(withIdentifier: "recordVC") as! recordVC
               self.navigationController?.pushViewController(vc, animated: true)
        
    }
     @IBAction func btnLoginClick(_ sender: Any) {
        
             let vc = storyBoards.Main.instantiateViewController(withIdentifier: "signinVC") as! signinVC
        vc.delegate = self
               self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func getLocation(){
        let locationManager = LocationManager.sharedInstance
           locationManager.showVerboseMessage = false
           locationManager.autoUpdate = true
         //   locationManager.startUpdatingLocation()
           locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
               self.latitude = latitude
               self.longitude = longitude
            //   print("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
               //print(verboseMessage)
            locationManager.autoUpdate = false
           }
    }
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getLocation()
    self.navigationController?.navigationBar.isHidden = true
        if(USER.shared.isLogout == true){
            self.PushToLogin(self)
        }
        else{
        
        }
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
          self.ViewPopup.frame = UIScreen.main.bounds
          self.view.addSubview(self.ViewPopup)
        }
    @IBAction func PushToLogin(_ sender: Any)
    {
        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "signinVC") as! signinVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
        @IBAction func btnHandlerBlackBg(_ sender: Any)
        {
                  self.ViewPopup.removeFromSuperview()
        }
    @IBAction func btnRegisterClick(_ sender: Any) {
            guard let text = txtName.text, !text.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.NameMissing)
                return
            }
            guard let email = txtemail.text, !email.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
                return
            }
            guard let validEmail = txtemail.text,  !validEmail.isValidEmail() == false else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
                return
            }
            guard let createpass = txtpassword.text, !createpass.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.CreatePasswordMissing)
                return
            }
            guard let confpass = txtConfirmpassword.text, !confpass.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMissing)
                return
            }
            guard let createminpass = txtpassword.text,  !createminpass.isHaveMinmumPassword() == false else {
                       showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.CreatePasswordMin6DigitMissing)
                       return
            }
            guard let confminpass = txtConfirmpassword.text,  !confminpass.isHaveMinmumPassword() == false else {
                       showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMin6DigitMissing)
                       return
            }
            guard  confpass == createpass else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordNotMatch)
                return
            }
        if(self.isFromLogin == true){
            var registerDetail:[String:Any] = [String : Any]()
            registerDetail["name"] = socialData.name
            registerDetail["email"] = socialData.email
            registerDetail["type"] = socialData.type
            registerDetail["vPushToken"] = appDelegate.FCMdeviceToken
            registerDetail["eDeviceType"] = "iOS"
            registerDetail["checkExist"] = "1"
            registerDetail["longitude"] = self.longitude.description
            registerDetail["latitude"] = self.latitude.description
            registerDetail["id"] = socialData.social_Id
            self.WSSocialLogin(Parameter: registerDetail as! [String : String])
        }
        else{
        self.WSSignup(Parameter: ["name":self.txtName.text!,"email":self.txtemail.text!,"password":self.txtpassword.text!,"latitude":self.latitude,"longitude":self.longitude,"eDeviceType":"","vPushToken":""])
        }
   
        }
    
    // MARK: - WEB Service
    func WSSignup(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .register_user, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let userData = dataResponce["data"] as? NSDictionary{
                        USER.shared.setData(dict: userData)
                        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "linkAccountVC") as! linkAccountVC
                        vc.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)

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
        @IBAction func btnGoogleClick(_ sender: Any) {
               
               GIDSignIn.sharedInstance().delegate=self
                GIDSignIn.sharedInstance().presentingViewController = self
               GIDSignIn.sharedInstance().signIn()
        }
    @IBAction func addSignInWithAppleButton(){
              
              if #available(iOS 13.0, *) {
                appleSignIn.loginWithApple { (userInfo, message) in
                     if let userInfo = userInfo{
                            print(userInfo.email)
                            print(userInfo.userid)
                            print(userInfo.firstName)
                            print(userInfo.lastName)
                            print(userInfo.fullName)
                    }else if let message = message{
                        print("Error Message: \(message)")
                    }else{
                        print("Unexpected error!")
                    }
            }
                }

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
    @IBAction func btnFacebookLoginAction(_ sender: Any) {
        self.GetFacebookData()
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
                              
                             

                             let userProfile = GraphRequest(graphPath: "link", parameters: [String : Any](), httpMethod: HTTPMethod(rawValue: "GET"))
                             let _ =  userProfile.start(completionHandler: {
                                 (connection, result, error) -> Void in
                                 if error == nil {
                                     print("\(error.debugDescription)")
                                 } else {
                                     print("\(String(describing: result))")
                                 }
                             })
                           self.WSSocialLogin(Parameter: registerDetail as! [String : String])
                             
                        
                             
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension signupVC : GIDSignInDelegate {
    
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

            USER.shared.setData(dict: registerDetail as NSDictionary)
            USER.shared.save()
            self.WSSocialLogin(Parameter: registerDetail as! [String : String])
            
            GIDSignIn.sharedInstance()?.signOut()
            //call
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
}
//@available(iOS 13.0, *)
//extension signupVC: ASAuthorizationControllerDelegate {
//
//    // ASAuthorizationControllerDelegate function for authorization failed
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print(error.localizedDescription)
//    }
//
//    // ASAuthorizationControllerDelegate function for successful authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
//
//            let fullName = appleIDCredential.fullName?.familyName
//            let email = appleIDCredential.email
//            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
//
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    // The Apple ID credential is valid.
//                    print("The Apple ID credential is valid.\(userIdentifier)")
//                    var registerDetail:[String:Any] = [String : Any]()
//
//
//                  //  UserDefaults.Main.set(registerDetail, forKey: .RegisterDetail)
//
//
//                    if email == nil
//                    {
//                        registerDetail["email"] = ""
//                        registerDetail["name"] = ""
//                    }
//                    else
//                    {
//                        registerDetail["email"] = email
//                        let firstName = "\(appleIDCredential.fullName!.givenName!)"
//                        let fullName = "\(appleIDCredential.fullName!.familyName!)"
//                        loggedInUserData.name = "\(firstName) \(fullName)"
//                        registerDetail["name"] = String(describing: firstName) + " " + String(describing: fullName)
//                        if email!.contains("privaterelay.appleid.com")
//                        {
//                            loggedInUserData.email = "" ?? ""
//                        }
//                        else
//                        {
//                            loggedInUserData.email = email ?? ""
//                        }
//
//                    }
//                    //registerDetail["fb_profile_pic_url"] = createString(value: profile as AnyObject)
//                    registerDetail["apple_id"] = userIdentifier
//                    registerDetail["social_type"] = "apple"
//                    registerDetail["mobile"] = ""
//                    registerDetail["country_code"] = ""
//                    registerDetail["vPushToken"] = appDelegate.FCMdeviceToken
//                    registerDetail["eDeviceType"] = "iOS"
//                    registerDetail["facebook_id"] = ""
//                    registerDetail["checkExist"] = "0"
//                    USER.shared.setData(dict: registerDetail as NSDictionary)
//                    USER.shared.save()
//                    DispatchQueue.main.async {
//                        self.WSSocialLogin(Parameter: registerDetail as! [String : String])
//
//                        //                        self.loginWithSocialAPICall(peraDic: registerDetail)
////                        self.redirectRegister(vlue: registerDetail)
//                    }
//
//                    break
//                case .revoked:
//                    // The Apple ID credential is revoked.
//                    print("The Apple ID credential is revoked.")
//                    break
//                case .notFound:
//                    // No credential was found, so show the sign-in UI.
//                    print("No credential was found, so show the sign-in UI")
//                    break
//                default:
//                    break
//                }
//            }
//
//        }
//    }
//}
//
//
//@available(iOS 13.0, *)
//extension signupVC: ASAuthorizationControllerPresentationContextProviding {
//    //For present window
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
//    {
//        return self.view.window!
//    }
//}
