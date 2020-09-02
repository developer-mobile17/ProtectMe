//
//  multiSelectionVC.swift
//  ProtectMe
//
//  Created by Mac on 25/08/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import SDWebImage


class multiSelectionVC: UIViewController {
    @IBOutlet weak var tblVideoList:UITableView!
    var FolderId = ""
    var arrarchivedList:[archivedListModel] = [archivedListModel]()
    var arrId:[String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVideoList.register(UINib(nibName: "multiselectionTableViewCell", bundle: nil), forCellReuseIdentifier: "multiselectionTableViewCell")
        self.tblVideoList.dataSource = self
        self.tblVideoList.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   self.WSArchiveList(Parameter: ["type":"recent","filter":"0","semi_filter":"0"])    }
    @IBAction func btnMoveAction(_ sender: UIButton) {
        let commaSapratedStrIDS = (arrarchivedList.map{String($0.id!)}).joined(separator: ",")
        let trimmedString = commaSapratedStrIDS.trimmingCharacters(in: .whitespaces).dropFirst()
        print(commaSapratedStrIDS)
        print(trimmedString)
        self.WSMoveFileHere(Parameter: ["file_id":String(trimmedString),"folder_id":self.FolderId])

        
    }
    @IBAction func btnCancleAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnCheckBoxAction(_ sender: UIButton)
    {
        let index = IndexPath(row: sender.tag, section: 0)
        self.arrarchivedList[sender.tag].isChecked = !self.arrarchivedList[index.row].isChecked
        self.tblVideoList.reloadRows(at: [index], with: .fade)
    }
    @IBAction func btnBackAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - WEB Service
    func WSMoveFileHere(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .move, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    // Completed '
                    showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "Completed", buttons: ["Okay"]) { (i) in
                        self.navigationController?.popViewController(animated: true)
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
    func WSArchiveList(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callAPIPost(WithType: .archived_list, isAuth: true, WithParams: Parameter, Success: { (DataResponce, Status, Message) in
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
                    if let outcome = dataResponce["data"] as? [NSDictionary]{
                        self.arrarchivedList.removeAll()
                        for a : Int in (0..<(outcome.count))
                        {
                            let objarchivedList : archivedListModel = archivedListModel()
                            objarchivedList.city         = outcome[a]["city"] as? String ?? ""
                            objarchivedList.country      = outcome[a]["country"] as? String ?? ""
                            objarchivedList.created      = outcome[a]["created"] as? String ?? ""
                            objarchivedList.file_size    = outcome[a]["file_size"] as? String ?? ""
                            objarchivedList.folder_id    = outcome[a]["folder_id"] as? String ?? ""
                            objarchivedList.folder_name  = outcome[a]["folder_name"] as? String ?? ""
                            objarchivedList.id           = outcome[a]["id"] as? String ?? ""
                            objarchivedList.image_name   = outcome[a]["image_name"] as? String ?? ""
                            objarchivedList.image_path   = outcome[a]["image_path"] as? String ?? ""
                            objarchivedList.longitude     = outcome[a]["longitude"] as? String ?? ""
                            objarchivedList.latitude    = outcome[a]["latitude"] as? String ?? ""
                            objarchivedList.state        = outcome[a]["state"] as? String ?? ""
                            objarchivedList.status       = outcome[a]["status"] as? String ?? ""
                            objarchivedList.type         = outcome[a]["type"] as? String ?? ""
                            objarchivedList.updated      = outcome[a]["updated"] as? String ?? ""
                            objarchivedList.uploaded_by     = outcome[a]["uploaded_by"] as? String ?? ""
                            objarchivedList.user_id      = outcome[a]["user_id"] as? String ?? ""
                            objarchivedList.name      = outcome[a]["name"] as? String ?? ""
                            
                            objarchivedList.thumb_image      = outcome[a]["thumb_image"] as? String ?? ""

                            self.arrarchivedList.append(objarchivedList)
                        }
                        self.tblVideoList.reloadData()
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
    // MARK: - UITableView Delegate Methods


}
extension multiSelectionVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrarchivedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:multiselectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "multiselectionTableViewCell", for: indexPath) as! multiselectionTableViewCell
        cell.selectionStyle = .none
        cell.lblName.text = arrarchivedList[indexPath.row].image_name
        cell.lblOwnerName.text = arrarchivedList[indexPath.row].uploaded_by
        cell.btncheckbox.tag = indexPath.row
        cell.btncheckbox.addTarget(self, action: #selector(self.btnCheckBoxAction(_:)), for: .touchUpInside)
        cell.videoThumb.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.videoThumb.sd_setImage(with: URL(string: arrarchivedList[indexPath.row].thumb_image!), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                         
        if(self.arrarchivedList[indexPath.row].isChecked == true)
        {
            cell.btncheckbox.setImage(#imageLiteral(resourceName: "ic_checkbox"), for: .normal)
        }
        else{
            cell.btncheckbox.setImage(#imageLiteral(resourceName: "ic_checkboxblank"), for: .normal)

        }
         return cell
    }
    
    
}
