//
//  resetPasswordVC.swift
//  ProtectMe
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class resetPasswordVC: UIViewController {
    @IBOutlet weak var txtOldpassword:AIBaseTextField!{
        didSet{
            txtOldpassword.leftIcon = #imageLiteral(resourceName: "ic_password")
            txtOldpassword.validationType = .password
            txtOldpassword.config.textFieldKeyboardType = .password
            txtOldpassword.config.minLength = 6
            txtOldpassword.config.maxLength = 16
        }
    }
    @IBOutlet weak var txtNewpassword:AIBaseTextField!{
        didSet{
            txtNewpassword.leftIcon = #imageLiteral(resourceName: "ic_password")
            txtNewpassword.validationType = .password
            txtNewpassword.config.textFieldKeyboardType = .password
            txtNewpassword.config.minLength = 6
            txtNewpassword.config.maxLength = 16
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

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackClick(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
    @IBAction func btnChangePassword(_ sender: Any) {
        guard let ptext = txtOldpassword.text, !ptext.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMissing)
            return
        }
//        guard let pltext = txtOldpassword.text,  !pltext.isHaveMinmumPassword() == false else {
//            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMin6DigitMissing)
//            return
//        }
        guard let ntext = txtNewpassword.text, !ntext.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: "Please enter new password.")
            return
        }
        guard let ctext = txtConfirmpassword.text, !ctext.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: "Please enter confirm password.")
                return
            }
        guard  ntext == ctext else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordNotMatch)
                return
                  }
//        guard let nmtext = txtNewpassword.text,  !nmtext.isHaveMinmumPassword() == false else {
//            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.PasswordMin6DigitMissing)
//            return
//        }
        WSChangePassword(Parameter: ["vOldPassword":self.txtOldpassword.text!,"vNewPassword":self.txtNewpassword.text!,"id":USER.shared.id])
    }
    func WSChangePassword(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .change_password, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    
                    if let outcome = DataResponce?["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: outcome, buttons: ["Dismiss"]) { (i) in
                            self.popTo()
                        }
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

}
