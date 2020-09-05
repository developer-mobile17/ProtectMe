//
//  notificationSettingVC.swift
//  ProtectMe
//
//  Created by Mac on 11/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class notificationSettingVC: UIViewController {
    var isNotificationLinkedAccOn:Bool = true
    var isSenderAccActivityOn:Bool = true
    var isEmailNotificationsOn:Bool = true
    @IBOutlet weak var lblType:UILabel!
    @IBOutlet weak var btnNewLinkedAccount:UIButton!
    @IBOutlet weak var btnSenderLinkedAccount:UIButton!
    
    @IBOutlet weak var lblInfoDescription:UILabel!
    @IBOutlet weak var btnLinkedAccount:UIButton!
    @IBOutlet weak var btnsenderactivity:UIButton!
    @IBOutlet weak var btnEmailNotifications:UIButton!


    @IBOutlet weak var ViewPopup:UIControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()

    }
    @IBAction func btnSenderAccActivityClick(_ sender: UIButton) {
        isSenderAccActivityOn = !isSenderAccActivityOn
        if(isSenderAccActivityOn == true){
            self.WSsender_account_setting(Parameter: ["sender_account_activity":"1"])
            sender.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            self.WSsender_account_setting(Parameter: ["sender_account_activity":"0"])

            sender.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
    }
    @IBAction func btnNotificationLinkedAccClick(_ sender: UIButton) {
        isNotificationLinkedAccOn = !isNotificationLinkedAccOn
        if(isNotificationLinkedAccOn == true){
            self.WSnew_link_account_setting(Parameter: ["new_link_account":"1"])
            sender.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            self.WSnew_link_account_setting(Parameter: ["new_link_account":"0"])

            sender.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
    }
    @IBAction func btnEmailNotificationClick(_ sender: UIButton) {
        isEmailNotificationsOn = !isEmailNotificationsOn
        if(isEmailNotificationsOn == true){
            self.WSnchange_email_notification(Parameter: ["type":"1"])
            sender.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            self.WSnchange_email_notification(Parameter: ["type":"0"])

            sender.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
    }

    @IBAction func btnBackClick(_ sender: Any) {
        self.popTo()
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
        if(sender == self.btnNewLinkedAccount){
            self.lblType.text = "New Linked Accounts"
            self.lblInfoDescription.text = "Receive a notification when a user requests to link you to their account."

        }
        else{
            self.lblType.text = "Sender Account Activity"
            self.lblInfoDescription.text = "Receive a notification when a user shaes a video or image with you."
        }
        self.ViewPopup.frame = UIScreen.main.bounds
        //self.view.addSubview(self.ViewPopup)
        self.navigationController?.view.addSubview(self.ViewPopup)

        
    }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        self.ViewPopup.removeFromSuperview()
    }

    // MARK: - WEB Service
      func WSsender_account_setting(Parameter:[String:Any]) -> Void {
          ServiceManager.shared.callAPIPost(WithType: .sender_account_setting, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                      self.WSGetAllData(Parameter: [:])
                      if let outcome = dataResponce["data"] as? NSDictionary{
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
    func setData(){
        print(USER.shared.location_service)
        isNotificationLinkedAccOn = USER.shared.notification.StrTobool!
        isEmailNotificationsOn = USER.shared.email_notification.StrTobool!
        isSenderAccActivityOn = USER.shared.sender_account_activity_notification.StrTobool!
        print(USER.shared.notification)
        if(isSenderAccActivityOn == true){
            btnsenderactivity.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            btnsenderactivity.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
         if(isNotificationLinkedAccOn == true){
            btnLinkedAccount.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
        }
        else{
            btnLinkedAccount.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
        }
        if(isEmailNotificationsOn == true){
                   btnEmailNotifications.setImage(#imageLiteral(resourceName: "ic_on"), for: .normal)
               }
               else{
                   btnEmailNotifications.setImage(#imageLiteral(resourceName: "ic_off"), for: .normal)
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
    func WSnchange_email_notification(Parameter:[String:Any]) -> Void {
                ServiceManager.shared.callAPIPost(WithType: .change_email_notification, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                          self.WSGetAllData(Parameter: [:])
    //                        if let outcome = dataResponce["data"] as? NSDictionary{
    //                        }
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
      func WSnew_link_account_setting(Parameter:[String:Any]) -> Void {
            ServiceManager.shared.callAPIPost(WithType: .new_link_account_setting, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                      self.WSGetAllData(Parameter: [:])
//                        if let outcome = dataResponce["data"] as? NSDictionary{
//                        }
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
