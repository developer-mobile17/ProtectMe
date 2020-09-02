//
//  linkAccountVC.swift
//  ProtectMe
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class linkAccountVC: UIViewController {
    var isHidden:Bool = true
    var updateAcc:Bool = false
    var type = ""
    var objlisnkedListModel:lisnkedListModel = lisnkedListModel()
    @IBOutlet weak var ViewEmailPopup:UIControl!
    @IBOutlet weak var lblEmailPopup:UILabel!

    @IBOutlet weak var ViewPopup:UIControl!
         @IBOutlet weak var txtType:AITextFieldPickerView!{
               didSet{
                txtType.leftIcon = #imageLiteral(resourceName: "ic_name")
                txtType.arrInput = ["Receiver","Sender"]
               }
           }
         @IBOutlet weak var txtEmail:AIBaseTextField!{
               didSet{
                    txtEmail.leftIcon = #imageLiteral(resourceName: "ic_email")
                   txtEmail.validationType = .email
                   txtEmail.config.textFieldKeyboardType = .email
               }
           }
           @IBOutlet weak var txtname:AIBaseTextField!{
               didSet{
                txtname.leftIcon = #imageLiteral(resourceName: "ic_name")
                txtname.validationType = .name
                txtname.config.textFieldKeyboardType = .name
               }
           }
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    override func viewWillAppear(_ animated: Bool) {
        
        self.txtType.pickerViewdidSelectRowHandler = { [unowned self]( txtField, selectedIndex) in
                     if(selectedIndex == 0)
                     {//receivers
                         self.type = "1"
                         self.txtType.text = "Receiver"
                     }
                     else{
                         self.type = "0"
                         self.txtType.text = "Sender"
                     }
                     
                 }
           if(isHidden == true)
           {
               self.navigationController?.navigationBar.isHidden = true
           }
           else{
               self.navigationController?.navigationBar.isHidden = false
           }
        if(self.updateAcc == true){
            if(self.objlisnkedListModel.account_type == "1"){
                self.txtType.text = "Receiver"
                self.type = "1"

            }
            else{
                self.txtType.text = "Sender"
                self.type = "0"

            }
            self.txtname.text = self.objlisnkedListModel.name
            
            self.txtEmail.text = self.objlisnkedListModel.email
        }
       }    
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
            view.endEditing(true)

        self.ViewPopup.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewPopup)

           //self.view.addSubview(self.ViewPopup)
             
         }
    @IBAction func btnHideEmailPopup(_ sender: Any)
    {
        self.ViewEmailPopup.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
         @IBAction func btnHandlerBlackBg(_ sender: Any)
         {
                   self.ViewPopup.removeFromSuperview()
         }
       
    @IBAction func btnAddClick(_ sender: Any) {
        guard let name = txtname.text, !name.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.NameMissing)
                return
            }
            guard let email = txtEmail.text, !email.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
                return
            }
            guard let validEmail = txtEmail.text,  !validEmail.isValidEmail() == false else {
                showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
                return
            }
            guard let type = txtType.text, !type.isEmpty else {
                showAlertWithTitleFromVC(vc: self, andMessage: "Please select type.")
                return
            }
        if(self.updateAcc == false){
            WSLinkAccountpopup(Parameter: ["name":txtname.text!,"email":txtEmail.text!,"type":self.type])
        }
        else{
            WSUpdateAccount(Parameter: ["name":txtname.text!,"email":txtEmail.text!,"type":self.type,"account_id":self.objlisnkedListModel.id])
        }
       
        //
    }
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSkipClick(_ sender: Any) {
         let vc = storyBoards.Main.instantiateViewController(withIdentifier: "recordVC") as! recordVC
           self.navigationController?.pushViewController(vc, animated: true)
    
}
    @IBAction func btnLoginClick(_ sender: Any) {
                let vc = storyBoards.Main.instantiateViewController(withIdentifier: "signinVC") as! signinVC
                  self.navigationController?.pushViewController(vc, animated: true)
           
       }
    @IBAction func btnLinkAccountClick(_ sender: Any) {
//       let vc = storyBoards.Main.instantiateViewController(withIdentifier: "recordVC") as! recordVC
//        self.navigationController?.pushViewController(vc, animated: true)
        guard let name = txtname.text, !name.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.NameMissing)
            return
        }
        guard let email = txtEmail.text, !email.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
            return
        }
        guard let validEmail = txtEmail.text,  !validEmail.isValidEmail() == false else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
            return
        }
        guard let type = txtType.text, !type.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: "Please select type.")
            return
        }

        
        WSLinkAccount(Parameter: ["name":txtname.text!,"email":txtEmail.text!,"type":self.type])
    }
    @IBAction func btnRegisterClick(_ sender: Any) {
        guard let name = txtname.text, !name.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.NameMissing)
            return
        }
        guard let email = txtEmail.text, !email.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.EmailNameMissing)
            return
        }
        guard let validEmail = txtEmail.text,  !validEmail.isValidEmail() == false else {
            showAlertWithTitleFromVC(vc: self, andMessage: AlertMessage.ValidEmail)
            return
        }
        guard let type = txtType.text, !type.isEmpty else {
            showAlertWithTitleFromVC(vc: self, andMessage: "Please select type.")
            return
        }

        
        WSLinkAccount(Parameter: ["name":txtname.text!,"email":txtEmail.text!,"type":self.type])
                
//                let vc = storyBoards.Main.instantiateViewController(withIdentifier: "linkAccountVC") as! linkAccountVC
//                self.navigationController?.pushViewController(vc, animated: true)
                }
    
// MARK: - WEB Service
    func WSUpdateAccount(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .edit_linked_account, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    self.ViewEmailPopup.frame = UIScreen.main.bounds
                    self.navigationController?.view.addSubview(self.ViewEmailPopup)

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
    func WSLinkAccountpopup(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .add_linked_account, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    self.lblEmailPopup.text = "An email confirmation has been sent to " + (self.txtname.text ?? "") 
                    self.ViewEmailPopup.frame = UIScreen.main.bounds
                    self.navigationController?.view.addSubview(self.ViewEmailPopup)

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
    func WSLinkAccount(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .add_linked_account, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    let vc = storyBoards.Main.instantiateViewController(withIdentifier: "recordVC") as! recordVC
                     self.navigationController?.pushViewController(vc, animated: true)

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
            }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


