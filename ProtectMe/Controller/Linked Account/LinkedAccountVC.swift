//
//  archiveVC.swift
//  ProtectMe
//
//  Created by Mac on 09/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class LinkedAccountVC: baseVC {
    @IBOutlet weak var tblLinedAcc:UITableView!
    @IBOutlet weak var ViewOptionMenu:UIControl!
    @IBOutlet weak var ViewAcceptRequest:UIControl!
    @IBOutlet weak var ViewEmailConfirmation:UIControl!

    @IBOutlet weak var ViewResendrequest:UIControl!
    @IBOutlet weak var btnSender:UIButton!
    @IBOutlet weak var btnReciver:UIButton!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblMessagePopup:UILabel!

    var btnSelected:UIButton = UIButton()
    

    var selectedUnlinkINdex = 0
    var selectedType = "0"
    var arrOption = [UIButton]()
    var arrLinkedAccList:[lisnkedListModel] = [lisnkedListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrOption = [btnSender,btnReciver]
        self.tblLinedAcc.delegate = self
        self.tblLinedAcc.dataSource = self
        self.tblLinedAcc.register(UINib(nibName: "LinkedAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkedAccountTableViewCell")

        //self.tblLinedAcc.register(LinkedAccountTableViewCell.self, forCellReuseIdentifier:"LinkedAccountTableViewCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if(USER.shared.LinkedAccSenederSelected == true ){
            self.btnSelected = self.btnSender
            self.btnSelectOptions(self.btnSelected)
            USER.shared.LinkedAccSenederSelected = !USER.shared.LinkedAccSenederSelected
            USER.shared.save()
        }
        else{
            self.btnSelected = self.btnReciver
            self.btnSelectOptions(self.btnSelected)
        }
        
    }
    @IBAction func btnAcceptClick(_ sender: UIButton) {
        print("self.arrLinkedAccList[sender.tag].linked_account_id",self.arrLinkedAccList[sender.tag].linked_account_id)
        WSlinked_account_action(Parameter: ["linked_account_id":self.arrLinkedAccList[sender.tag].id,"action":"1"])
      
      //self.view.addSubview(self.ViewOptionMenu)
    }
    @IBAction func btnRejectClick(_ sender: UIButton) {
        print("self.arrLinkedAccList[sender.tag].linked_account_id",self.arrLinkedAccList[sender.tag].linked_account_id)
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Are you sure you want to reject \(self.arrLinkedAccList[sender.tag].name) link request?", buttons: ["Yes","Cancel"]) { (i) in
            if(i == 0){
                self.WSlinked_account_action(Parameter: ["linked_account_id":self.arrLinkedAccList[sender.tag].id,"action":"0"])
            }
            else{
                    
            }
        }
    }
    @IBAction func btnOptionMenuClick(_ sender: UIButton) {
        self.btnSelected = sender
        if(self.arrLinkedAccList[sender.tag].user_id == USER.shared.id){
             self.lblEmail.text = self.arrLinkedAccList[sender.tag].email
             self.lblName.text = self.arrLinkedAccList[sender.tag].name
        }
        else{
            self.lblEmail.text = self.arrLinkedAccList[sender.tag].inserted_by_email
            self.lblName.text = self.arrLinkedAccList[sender.tag].inserted_by_name
        }
        self.selectedUnlinkINdex = sender.tag
        
        if(self.arrLinkedAccList[sender.tag].user_id == USER.shared.id){
           if (arrLinkedAccList[sender.tag].status == "2"){
                self.ViewResendrequest.isHidden = false
            }
           else{
                self.ViewResendrequest.isHidden = true
            }
        }
        else{
            self.ViewResendrequest.isHidden = true
        }
        self.ViewOptionMenu.frame = UIScreen.main.bounds
        self.navigationController?.view.addSubview(self.ViewOptionMenu)
            
        //self.view.addSubview(self.ViewOptionMenu)
      }
    override func viewWillDisappear(_ animated: Bool) {
        self.btnHandlerBlackBg(self)
    }
    @IBAction func btnUpdateAcc(_ sender: Any){
      let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "otherlinkaccountVC") as!  linkAccountVC
        OBJchangepasswordVC.updateAcc = true
        print("name:",self.arrLinkedAccList[self.selectedUnlinkINdex].name)
        print("email",self.arrLinkedAccList[self.selectedUnlinkINdex].email)
        print("type",self.arrLinkedAccList[self.selectedUnlinkINdex].account_type)
        OBJchangepasswordVC.objlisnkedListModel = self.arrLinkedAccList[self.selectedUnlinkINdex]
          OBJchangepasswordVC.isHidden = false

      self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
      }
    @IBAction func btnAddNewAcc(_ sender: Any){
    let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "otherlinkaccountVC") as!  linkAccountVC
        OBJchangepasswordVC.isHidden = false

    self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    @IBAction func btnSelectOptions(_ sender: UIButton) {
        self.selectOptions(selected: sender)
    }
    func selectOptions(selected:UIButton)  {
            if(selected == btnSender){
                self.btnSelected = btnSender
                btnSender.setTitleColor(UIColor.clrSkyBlue, for: .normal)
                btnReciver.setTitleColor(UIColor.lightGray, for: .normal)
                self.WSLinkedAccList(Parameter: ["type":"0"])
            }
            else{
                self.btnSelected = selected
                btnReciver.setTitleColor(UIColor.clrSkyBlue, for: .normal)
                btnSender.setTitleColor(UIColor.lightGray, for: .normal)
                self.WSLinkedAccList(Parameter: ["type":"1"])
            }
        
        

    }

    @IBAction func btnLinkNewAcc(_ sender: Any){
        self.popTo()
    }
    @IBAction func btnResendAcc(_ sender: UIButton){
        self.WSResendRequest(Parameter: ["id":self.arrLinkedAccList[selectedUnlinkINdex].id])
    }
    @IBAction func btnUnLinkNewAcc(_ sender: UIButton){
        print(selectedUnlinkINdex)
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Are you sure you want to unlink this user?", buttons: ["Yes","Cancel"]) { (i) in
            if(i == 0){
                self.WSUnlinkAcc(Parameter: ["linked_account_id":self.arrLinkedAccList[self.selectedUnlinkINdex].id])

            }
        }
       }
    @IBAction func btnHandlerBlackBg(_ sender: Any)
    {
        self.ViewAcceptRequest.removeFromSuperview()
        self.ViewOptionMenu.removeFromSuperview()
        self.ViewEmailConfirmation.removeFromSuperview()
    }
    // MARK: - WEB Service
    func WSResendRequest(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .resend_request, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    self.btnHandlerBlackBg(self)
                    self.ViewEmailConfirmation.frame = UIScreen.main.bounds
                    self.navigationController?.view.addSubview(self.ViewEmailConfirmation)
//                    if let errorMessage:String = dataResponce["message"] as? String{
//                            showAlertWithTitleFromVC(vc: self, andMessage: errorMessage)
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
    func WSlinked_account_action(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .linked_account_action, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    if(Parameter["action"] == "1"){
                        self.ViewAcceptRequest.frame = UIScreen.main.bounds
                        self.navigationController?.view.addSubview(self.ViewAcceptRequest)
                    }
                    self.selectOptions(selected: self.btnSelected)
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
    func WSUnlinkAcc(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .unlink_account, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    if let usernm = self.arrLinkedAccList[self.selectedUnlinkINdex].name as? String{
                        let a = usernm + " will be unlinked within the next 24 hours"
                        showAlertWithTitleFromVC(vc: self, andMessage: a)
                        self.ViewOptionMenu.removeFromSuperview()
                        self.selectOptions(selected: self.btnSelected)
                        //showAlert(title: Constant.APP_NAME as NSString, message: usernm + "will be unlinked within the next 24 hours")
                    }
                    if let archived_counter = dataResponce["archived_counter"] as? Int{
                        USER.shared.archived_counter = String(archived_counter)
                        USER.shared.save()
                    }
                                       if let linked_account_counters = dataResponce["linked_account_counters"] as? Int{
                                    USER.shared.linked_account_counters = String(linked_account_counters)
                                       USER.shared.save()
                                       }
//                    if let msg = DataResponce?["message"] as? String{
//                        //showAlertWithTitleFromVC(vc: self, andMessage: msg)
//                        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME as String, andMessage: msg, buttons: ["Dismiss"]) { (i) in
//                            self.ViewOptionMenu.removeFromSuperview()
//                            self.selectOptions(selected: self.btnSelected)
//                                                      // Fallback on earlier versions
//                                              }
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
    func WSClearCount(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .reset_archived_counter, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    
                }
                else if(StatusCode == 401)
                {
                    if let errorMessage:String = Message{
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
    func WSLinkedAccList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .linked_account_list, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    if let outcome = dataResponce["data"] as? [NSDictionary]{
                         self.arrLinkedAccList.removeAll()
                        for a : Int in (0..<(outcome.count))
                        {
                            let objlisnkedListModel : lisnkedListModel = lisnkedListModel()
                            objlisnkedListModel.name = outcome[a]["name"] as? String ?? ""
                            objlisnkedListModel.id = outcome[a]["id"] as? String ?? ""
                            objlisnkedListModel.user_id = outcome[a]["user_id"] as? String ?? ""
                            objlisnkedListModel.account_type = outcome[a]["account_type"] as? String ?? ""
                            objlisnkedListModel.email = outcome[a]["email"] as? String ?? ""
                            objlisnkedListModel.created = outcome[a]["created"] as? String ?? ""
                            objlisnkedListModel.updated = outcome[a]["updated"] as? String ?? ""
                            objlisnkedListModel.linked_account_id = outcome[a]["linked_account_id"] as? String ?? ""
                            objlisnkedListModel.status = outcome[a]["status"] as? String ?? ""
                            objlisnkedListModel.inserted_by_email = outcome[a]["inserted_by_email"] as? String ?? ""
                            objlisnkedListModel.inserted_by_name = outcome[a]["inserted_by_name"] as? String ?? ""
                            
                            objlisnkedListModel.action_button_show = outcome[a]["action_button_show"] as? String ?? ""
                            if(objlisnkedListModel.status != "0"){
                            self.arrLinkedAccList.append(objlisnkedListModel)
                            }
                            print("status :" ,objlisnkedListModel.status)
                        }
                        self.tblLinedAcc.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LinkedAccountVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLinkedAccList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LinkedAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LinkedAccountTableViewCell", for: indexPath) as! LinkedAccountTableViewCell
        cell.selectionStyle = .none
        cell.btnOption.tag = indexPath.row
        cell.btnOption.addTarget(self, action: #selector(self.btnOptionMenuClick(_:)),for: .touchUpInside)
        cell.btnAccepOption.tag = indexPath.row
        cell.btnAccepOption.addTarget(self, action: #selector(self.btnAcceptClick(_:)),for: .touchUpInside)
        cell.btnRejectOption.tag = indexPath.row
        cell.btnRejectOption.addTarget(self, action: #selector(self.btnRejectClick(_:)),for: .touchUpInside)

        if(self.arrLinkedAccList[indexPath.row].user_id == USER.shared.id){
         
            if (arrLinkedAccList[indexPath.row].status == "2"){
                print("pending list : who sended request")
                    cell.lblpending.isHidden = false
                                  cell.imgLink.isHidden = true
                                  cell.lodr.startAnimating()
                                  cell.btnOption.isHidden = false
                                  cell.btnAccepOption.isHidden = true
                                  cell.btnRejectOption.isHidden = true
                                  cell.imgThreeDot.isHidden = false
                                  cell.lblTitle.text = arrLinkedAccList[indexPath.row].email
            }
            else{
                print("Normal list : who sended request")
                cell.lblpending.isHidden = true
                    cell.imgLink.isHidden = false
                    cell.lodr.stopAnimating()
                    cell.btnOption.isHidden = false
                    cell.btnAccepOption.isHidden = true
                    cell.btnRejectOption.isHidden = true
                    cell.imgThreeDot.isHidden = false
                cell.lblTitle.text = arrLinkedAccList[indexPath.row].email
            }
//
//            cell.lblpending.isHidden = false
//            cell.imgLink.isHidden = true
//            cell.lodr.startAnimating()
//            cell.btnOption.isHidden = false
//            cell.btnAccepOption.isHidden = true
//            cell.btnRejectOption.isHidden = true
//            cell.imgThreeDot.isHidden = true
//            cell.lblTitle.text = arrLinkedAccList[indexPath.row].email
        }
        else{
            cell.lblTitle.text = self.arrLinkedAccList[indexPath.row].inserted_by_email
            if(arrLinkedAccList[indexPath.row].action_button_show.lowercased() == "yes" && arrLinkedAccList[indexPath.row].status == "2"){
                print("pending list : who recived the request")

                    cell.lblpending.isHidden = false
                    cell.imgLink.isHidden = true
                    cell.lodr.startAnimating()
                    cell.btnOption.isHidden = true
                    cell.btnAccepOption.isHidden = false
                    cell.btnRejectOption.isHidden = false
                    cell.imgThreeDot.isHidden = true
                cell.lblTitle.text = arrLinkedAccList[indexPath.row].inserted_by_email
            }
            else{
                print("Normal list : who recived the request")
                cell.lblpending.isHidden = true
                cell.imgLink.isHidden = false
                cell.lodr.stopAnimating()
                cell.btnOption.isHidden = false
                cell.btnAccepOption.isHidden = true
                cell.btnRejectOption.isHidden = true
                cell.imgThreeDot.isHidden = false
                cell.lblTitle.text = arrLinkedAccList[indexPath.row].inserted_by_email
            }
        }
        return cell
    }
    
    
}
