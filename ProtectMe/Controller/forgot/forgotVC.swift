//
//  forgotVC.swift
//  ProtectMe
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class forgotVC: UIViewController {
    @IBOutlet weak var txtEmail:AIBaseTextField!{
             didSet{
                txtEmail.leftIcon = #imageLiteral(resourceName: "ic_email")
                txtEmail.validationType = .email
                txtEmail.config.textFieldKeyboardType = .email
             }
         }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackClick(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
    @IBAction func btnForgotClick(_ sender: Any) {
               let vc = storyBoards.Main.instantiateViewController(withIdentifier: "resetPasswordVC") as! resetPasswordVC
                 self.navigationController?.pushViewController(vc, animated: true)
          
      }
     @IBAction func btnResendClick(_ sender: Any) {
         guard let email = txtEmail.text, !email.isEmpty else {
             showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
             return
         }
         guard let validEmail = txtEmail.text,  !validEmail.isValidEmail() == false else {
             showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
             return
         }
        WSForgot(Parameter: ["email":self.txtEmail.text!])
//        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "resetPasswordVC") as! resetPasswordVC
//            self.navigationController?.pushViewController(vc, animated: true)
      
    //     self.navigationController?.popViewController(animated: true)
     }
        func WSForgot(Parameter:[String:String]) -> Void {
            ServiceManager.shared.callAPIPost(WithType: .forgot, isAuth: false, WithParams: Parameter, Success:  { (DataResponce, Status, Message) in
                if(Status == true){
                    let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                    let StatusCode = DataResponce?["status"] as? Int
                    if (StatusCode == 200){
                        if let sucessmsg = DataResponce?["message"] as? String {
                            showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: sucessmsg, buttons: ["Dismiss"]) { (i) in
                            self.popTo()
                                                }

                        }
    //                    showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: sucessmsg, buttons: ["Dismiss"]) { (i) in
    //                        self.popTo()
    //                    }
    //
    //                    }
    //                    else{
    //                    print("sucess msg not get")
    //                    }
    //
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
//
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
