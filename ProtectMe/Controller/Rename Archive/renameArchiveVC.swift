//
//  renameArchiveVC.swift
//  ProtectMe
//
//  Created by Mac on 11/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
protocol sendbacktoName {
    func changename( name:String,index:IndexPath)
}
class renameArchiveVC: UIViewController {
    var FieldType = ""
    var txtValue = ""
    var titleString:String = ""
    var alertStr = ""
    var fileID = ""
    var fileName = ""

    let ind:IndexPath? = nil
    var delegate:sendbacktoName!
    @IBOutlet weak var txtName:AIBaseTextField!{
        didSet{
       // txtName.leftIcon = #imageLiteral(resourceName: "ic_name")
       
        }
    }
   // @IBOutlet weak var txtName:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRenameActionClick(_ sender: Any) {
        guard let result = self.txtName.text, !result.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: alertStr)
            return
        }
        if(FieldType == "email"){
            
            guard let validEmail = txtName.text,  !validEmail.isValidEmail() == false else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
                return
            }
            self.WSUpdateProfile(Parameter: ["email":self.txtName.text!])
        }
        else if(FieldType == "name"){
          self.WSUpdateProfile(Parameter: ["name":self.txtName.text!])
        }
        else{
            WSRenameFile(Parameter: ["id":fileID,"name":self.txtName.text!])
//            self.delegate?.changename(name: self.txtName.text!, index: ind!)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        txtName.becomeFirstResponder()
        self.title = self.titleString
        self.txtName.text = txtValue
        if(FieldType == "email"){
            txtName.validationType = .email
        txtName.config.textFieldKeyboardType = .email
            txtName.leftIcon = #imageLiteral(resourceName: "ic_email")
            alertStr = "please enter email."
        }
        else if(FieldType == "name"){
            txtName.validationType = .name
                   txtName.config.textFieldKeyboardType = .name
            txtName.leftIcon = #imageLiteral(resourceName: "ic_name")
            alertStr = "please enter name."
        }
        else{
            let img = #imageLiteral(resourceName: "ic_Adetails")
            alertStr = "please enter filename."
            txtName.config.textFieldKeyboardType = .name
            //txtName.leftIcon = #imageLiteral(resourceName: "ic_Adetails")
            txtName.leftIcon  = img
            //txtName.leftViewPadding = 12
            txtName.tintColor = .clrDeselect
        }

    }
    @IBAction func btnBackClick(_ sender: Any) {
        self.popTo()
    }
    func WSRenameFile(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .rename_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    self.popTo()

//                    if let outcome = dataResponce["data"] as? NSDictionary{
//                        USER.shared.setData(dict: outcome)
//                    }
//                    if let message = dataResponce["message"] as? String{
//                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage:message , buttons: ["Dismiss"]) { (i) in
//                            self.popTo()
//                        }
//
//                    }
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
    func WSUpdateProfile(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .edit_profile, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let outcome = dataResponce["data"] as? NSDictionary{
                                      USER.shared.setData(dict: outcome)
                    }
                    if let message = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage:message , buttons: ["Dismiss"]) { (i) in
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
                                appDelegate.setLoginVC()
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


}
