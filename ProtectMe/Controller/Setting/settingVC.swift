//
//  settingVC.swift
//  ProtectMe
//
//  Created by Mac on 10/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import MessageUI
import IntentsUI

extension settingVC:MFMailComposeViewControllerDelegate{
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
              let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
              let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

              let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
              let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
              let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
              let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
              let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

              if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                  return gmailUrl
              } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                  return outlookUrl
              } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                  return yahooMail
              } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                  return sparkUrl
              }

              return defaultUrl
          }

          
          func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
              switch result {
              case .cancelled:
                  print("Mail cancelled")
              case .saved:
                  print("Mail saved")
              case .sent:
                  print("Mail sent")
              case .failed:
                  print("Mail sent failure: \(error?.localizedDescription)")
              default:
                  break
              }
              controller.dismiss(animated: true)
          }
    func launchEmail() {

        let recipientEmail = USER.shared.support_email
          let subject = ""
          let body = ""

          // Show default mail composer
          if MFMailComposeViewController.canSendMail() {
              let mail = MFMailComposeViewController()
              mail.mailComposeDelegate = self
              mail.mailComposeDelegate = self
                       mail.setToRecipients([recipientEmail])
                       mail.setMessageBody("", isHTML: false)

              present(mail, animated: true)

          // Show third party email composer if default Mail app is not present
          }
          else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
              //UIApplication.shared.open(emailUrl)
            if UIApplication.shared.canOpenURL(emailUrl) {
                UIApplication.shared.open(emailUrl, options: [:])
             }

            // for versions below iOS 10
            if UIApplication.shared.canOpenURL(emailUrl) {
               UIApplication.shared.openURL(emailUrl)
            }
          }
           
       }
}
class settingVC: baseVC {
    var isLocationServiceOn:Bool = true
    var isVoiceActivationOn:Bool = true
    @IBOutlet weak var ViewPopup:UIControl!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblInfo:UILabel!
    @IBOutlet weak var lblVoiceActivation:UILabel!

    @IBOutlet weak var btnlocation:UIButton!
    @IBOutlet weak var btnvoice:UIButton!
    @IBOutlet weak var viewbotm:UIView!

    

    @IBOutlet weak var btnswtlocation:UIButton!
    @IBOutlet weak var btnswtvoice:UIButton!

    @IBOutlet weak var lblName:UILabel!{
        didSet{
            lblName.text = USER.shared.name
        }
    }
    @IBOutlet weak var lblEmail:UILabel!
    {
        didSet{
            lblEmail.text = USER.shared.email
        }
    }
    @IBOutlet weak var lblStorage:UILabel!
    @IBOutlet weak var btnEditName:UIButton!{
        didSet{
            //btnEditName.setImage(image: #imageLiteral(resourceName: "ic_edit"), inFrame: CGRect(x: 8, y: 8, width: 18, height: 18), forState: UIControl.State.normal)
        }
    }
    @IBOutlet weak var btnEditEmail:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSiriButton(to: self.viewbotm)
        // Do any additional setup after loading the view.
    }
    func setData(){
        self.lblName.text = USER.shared.name
        self.lblEmail.text = USER.shared.email
        print(USER.shared.location_service)
        isLocationServiceOn = USER.shared.location_service.StrTobool!
        isVoiceActivationOn = USER.shared.voice_action.StrTobool!
        if(isVoiceActivationOn == true){
            btnswtvoice.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            btnswtvoice.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
         if(isLocationServiceOn == true){
            btnswtlocation.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            btnswtlocation.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        self.WSGetUserProfile(Parameter: [:])
    //    self.SwitchLocation.addTarget(self, action: #selector(self.LocationValueChanged(sender:)), for: .valueChanged)
      //  self.SwitchVoice.addTarget(self, action: #selector(self.VoiceValueChanged(sender:)), for: .valueChanged)
         // btnEditName.setImage(image: #imageLiteral(resourceName: "ic_edit"), inFrame: CGRect(x: 8, y: 8, width: 18, height: 18), forState: UIControl.State.normal)

    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
        if(sender == btnvoice){
            self.lblInfo.text = "Use \u{22}Hey Siri Activate ProtectMe\u{22} to open ProtectMe and start recording"
            self.lblTitle.text = "Voice Activation"
        }
        else{
            self.lblInfo.text = "Assign your location to the recording of videos"
            self.lblTitle.text = "Location Services"
        }
        self.ViewPopup.frame = UIScreen.main.bounds
       // self.view.addSubview(self.ViewPopup)
        self.navigationController?.view.addSubview(self.ViewPopup)
    }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        self.ViewPopup.removeFromSuperview()
    }
    @IBAction func btnLocationServiceClick(_ sender: UIButton) {
        isLocationServiceOn = !isLocationServiceOn
        if(isLocationServiceOn == true){
            self.WSchangelocation(Parameter: ["location_service":"1"])

            sender.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            self.WSchangelocation(Parameter: ["location_service":"0"])

            sender.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
    }
    @IBAction func btnVoiceActivationClick(_ sender: UIButton) {
        isVoiceActivationOn = !isVoiceActivationOn
        if(isVoiceActivationOn == true){
            self.WSchangeVoice(Parameter: ["voice_action":"1"])
            sender.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            self.WSchangeVoice(Parameter: ["voice_action":"0"])
            sender.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
    }

    @objc func LocationValueChanged(sender: UISwitch!)
       {
           if sender.isOn {

               print("switch on")

           } else {

           }
       }
    @objc func VoiceValueChanged(sender: UISwitch!)
          {
              if sender.isOn {

                  print("switch on")

              } else {

              }
          }
   public func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addTextField() { newTextField in
           newTextField.placeholder = placeholder
       }
       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("") })
       alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
           if
               let textFields = alert.textFields,
               let tf = textFields.first,
               let result = tf.text
           { completion(result) }
           else
           { completion("") }
       })
       navigationController?.present(alert, animated: true)
   }
    @IBAction func btnEditNameClick(_ sender: Any) {
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
        OBJchangepasswordVC.titleString = "Name"
        OBJchangepasswordVC.FieldType = "name"
        OBJchangepasswordVC.txtValue = self.lblName.text!

                     self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)

//        alertWithTextField(title: Constant.APP_NAME, message: "Please enter name", placeholder: "write name") { result in
//            print(result)
//            guard  !result.isEmpty else {
//                    showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.NameMissing)
//                    return
//            }
//            self.lblName.text = result
//        }
    }
    @IBAction func btnEditEmailClick(_ sender: Any) {
//    alertWithTextField(title: Constant.APP_NAME, message: "Please enter email", placeholder: "write email") { result in
//        print(result)
//        guard  !result.isEmpty else {
//                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
//                return
//        }
//        guard  !result.isValidEmail() == false else {
//            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
//            return
//        }
//        self.lblEmail.text = result
//    }
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "renameArchiveVC") as!  renameArchiveVC
        OBJchangepasswordVC.titleString = "Email Address"
        OBJchangepasswordVC.FieldType = "email"
        OBJchangepasswordVC.txtValue = self.lblEmail.text!


        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)

    }
    @IBAction func btnresetPasswordVCClick(_ sender: Any) {
    
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "resetPasswordVC") as! resetPasswordVC
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    @IBAction func btnUpgradStorageClick(_ sender: Any) {
    
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "upgradeAccountVC") as!  upgradeAccountVC
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    @IBAction func btnNotificationClick(_ sender: Any) {
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "notificationSettingVC") as!  notificationSettingVC
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    @IBAction func btnTermasandConditionClick(_ sender: Any) {
        
        let ObjcommonWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "commonWebViewVC") as!  commonWebViewVC
        ObjcommonWebViewVC.titleString = "Terms and Conditions"
        self.navigationController?.pushViewController(ObjcommonWebViewVC, animated: true)
    }
    @IBAction func btnPrivacyPolicyClick(_ sender: Any) {
        let ObjcommonWebViewVC = self.storyboard?.instantiateViewController(withIdentifier: "commonWebViewVC") as!  commonWebViewVC
        ObjcommonWebViewVC.titleString = "Privacy Policy"
        self.navigationController?.pushViewController(ObjcommonWebViewVC, animated: true)
    }
    
    @IBAction func btnDeactiveAccClick(_ sender: Any) {
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage:AlertMessage.deactiveMessage, buttons: ["No","Yes"]) { (i) in
            if(i == 1){
                self.WSDeactiveAccount(Parameter: [:])
            }
                       
        }
        
    }

    @IBAction func btnContactUsClick(_ sender: Any) {
        print(USER.shared.support_email)
        self.launchEmail()
    }
    // MARK: - WEB Service
    func WSGetUserProfile(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callGetAPI(WithType: .get_user_data, isAuth: true, passString: "", WithParams: Parameter, Success: { (DataResponce, Status, Message) in

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
                    if let outcome = dataResponce["data"] as? NSDictionary {
                        USER.shared.setData(dict:outcome)
                    }
                    self.lblStorage.text = "\(USER.shared.storage_main) of 2 GB" 
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
    func WSchangelocation(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .change_location_service, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    //self.WSGetAllData(Parameter: [:])
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        USER.shared.setData(dict: outcome)
                        self.setData()
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
    func WSGetAllData(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .notification, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        USER.shared.setData(dict: outcome)
                        self.setData()
                        
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
    func WSDeactiveAccount(Parameter:[String:Any]) -> Void {
          ServiceManager.shared.callAPIPost(WithType: .deactivate_acc, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
              if(Status == true){
                  let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                  let StatusCode = DataResponce?["status"] as? Int
                  if (StatusCode == 200){
                    USER.shared.clear()
                    USER.shared.isLogout = true
                    USER.shared.save()
                    appDelegate.setLoginVC()
                    
                   
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
    func WSchangeVoice(Parameter:[String:Any]) -> Void {
          ServiceManager.shared.callAPIPost(WithType: .change_voice_action, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
//                    /self.WSGetAllData(Parameter: [:])
                      if let outcome = dataResponce["data"] as? NSDictionary{
                        USER.shared.setData(dict: outcome)
                        self.setData()
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

}

extension settingVC {
    func addSiriButton(to view: UIView) {
        if #available(iOS 12.0, *) {
            let siriButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
            
            siriButton.shortcut = INShortcut(intent: intent )
            siriButton.delegate = self
            siriButton.translatesAutoresizingMaskIntoConstraints = false
            //siriButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            view.addSubview(siriButton)
            
            
            view.leftAnchor.constraint(equalTo: siriButton.leftAnchor ).isActive = true
            //view.centerXAnchor.constraint(equalTo: siriButton.centerXAnchor ).isActive = true
            view.centerYAnchor.constraint(equalTo: siriButton.centerYAnchor).isActive = true
           }
       
       }
       
       func showMessage() {
           let alert = UIAlertController(title: "Done!", message: "This is your first shortcut action!", preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    @available(iOS 12.0, *)
    public var intent: DoSomethingIntent {
        let testIntent = DoSomethingIntent()
        testIntent.suggestedInvocationPhrase = "Activate ProtectMe"
        return testIntent
    }
}

extension settingVC: INUIAddVoiceShortcutButtonDelegate {
    @available(iOS 12.0, *)
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        addVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        editVoiceShortcutViewController.modalPresentationStyle = .formSheet
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    
}

extension settingVC: INUIAddVoiceShortcutViewControllerDelegate {
    @available(iOS 12.0, *)
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension settingVC: INUIEditVoiceShortcutViewControllerDelegate {
    @available(iOS 12.0, *)
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 12.0, *)
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
