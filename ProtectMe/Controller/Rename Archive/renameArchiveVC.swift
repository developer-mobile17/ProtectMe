//
//  renameArchiveVC.swift
//  ProtectMe
//
//  Created by Mac on 11/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

protocol sendbacktoName {
    func getselectedvire(view:String)
    func changename( name:String,index:IndexPath)
}
class renameArchiveVC: UIViewController {
    @IBOutlet weak var ViewEmailConfirmation:UIControl!
    @IBOutlet weak var lblMessagePopup:UILabel!

    var FieldType = ""
    var txtValue = ""
    var selectedView = ""
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
        else if(FieldType == "folder"){
            self.WSRenameFolder(Parameter: ["id":fileID,"name":self.txtName.text!])
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
            txtName.validationType = .none
            txtName.config.textFieldKeyboardType = .none
            txtName.leftIcon = #imageLiteral(resourceName: "ic_name")
            alertStr = "please enter name."
        }
        else if(FieldType == "folder"){
        let img = #imageLiteral(resourceName: "ic_foldericon")
                alertStr = "please enter foldername."
                txtName.config.textFieldKeyboardType = .none
                txtName.validationType = .none
                //txtName.leftIcon = #imageLiteral(resourceName: "ic_Adetails")
                txtName.leftIcon  = img
                //txtName.leftViewPadding = 12
                txtName.tintColor = .clrDeselect
        }
        else{
            let img = #imageLiteral(resourceName: "ic_Adetails")
            alertStr = "please enter filename."
            txtName.config.textFieldKeyboardType = .none
            txtName.validationType = .none
            //txtName.leftIcon = #imageLiteral(resourceName: "ic_Adetails")
            txtName.leftIcon  = img
            //txtName.leftViewPadding = 12
            txtName.tintColor = .clrDeselect
        }

    }
    @IBAction func btncloseEmailUpdate(_ sender: Any) {
        self.ViewEmailConfirmation.removeFromSuperview()
        self.popTo()

    }
    @IBAction func btnBackClick(_ sender: Any) {
        self.popTo()
    }
        func WSRenameFolder(Parameter:[String:Any]) -> Void {
            ServiceManager.shared.callAPIPost(WithType: .rename_folder, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                        self.delegate?.getselectedvire(view: self.selectedView)
                        self.popTo()
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
    func WSRenameFile(Parameter:[String:Any]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .rename_file, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    self.delegate?.getselectedvire(view: self.selectedView)
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
                                USER.shared.isLogout = true
                                USER.shared.save()
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
                    if let archived_counter = dataResponce["archived_counter"] as? String{
                        USER.shared.archived_counter = archived_counter
                        USER.shared.save()
                    }
                    if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                        USER.shared.linked_account_counters = String(linked_account_counters)
                        USER.shared.save()
                    }
                    if let outcome = dataResponce["data"] as? NSDictionary{
                        USER.shared.setData(dict: outcome)
                    }
                    if(self.FieldType == "email"){
                    self.lblMessagePopup.text = "An email confirmation has been sent to the updated " + self.txtName.text!
                    self.ViewEmailConfirmation.frame = UIScreen.main.bounds
                    self.navigationController?.view.addSubview(self.ViewEmailConfirmation)
                    }
                    else{
                    if let message = dataResponce["message"] as? String{
                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage:message , buttons: ["Dismiss"]) { (i) in
                            self.popTo()
                        }

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
