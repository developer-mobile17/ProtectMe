//
//  forgotVC.swift
//  ProtectMe
//
//  Created by Mac on 01/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class setProfileVC: UIViewController {
    var socialID = ""
    var name = ""
    var socialData:socialModel = socialModel()


    @IBOutlet weak var txtEmail:AIBaseTextField!{
             didSet{
                txtEmail.leftIcon = #imageLiteral(resourceName: "ic_email")
                txtEmail.validationType = .email
                txtEmail.config.textFieldKeyboardType = .email
             }
    }
    @IBOutlet weak var txtName:AIBaseTextField!{
        didSet{
                  txtName.leftIcon = #imageLiteral(resourceName: "ic_name")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.txtName.text = self.name
    }
    @IBAction func btnBackClick(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
       }
//    @IBAction func btnForgotClick(_ sender: Any) {
//               let vc = storyBoards.Main.instantiateViewController(withIdentifier: "resetPasswordVC") as! resetPasswordVC
//                 self.navigationController?.pushViewController(vc, animated: true)
//
//      }
     @IBAction func btnResendClick(_ sender: Any) {
        guard let name = txtName.text, !name.isEmpty else {
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
        var registerDetail:[String:Any] = [String : Any]()
        registerDetail["name"]          = self.txtName.text
        registerDetail["email"]         = self.txtEmail.text
        registerDetail["type"]          = self.socialData.type
        registerDetail["vPushToken"]    = self.socialData.vPushToken
        registerDetail["eDeviceType"]   = self.socialData.eDeviceType
        registerDetail["id"]            = self.socialData.id
        registerDetail["checkExist"]    = self.socialData.checkExist
        registerDetail["longitude"]     = self.socialData.longitude
        
        registerDetail["latitude"]      = self.socialData.latitude
        self.WSSocialLogin(Parameter: registerDetail )
//        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "resetPasswordVC") as! resetPasswordVC
//            self.navigationController?.pushViewController(vc, animated: true)
      
    //     self.navigationController?.popViewController(animated: true)
     }
              func WSSocialLogin(Parameter:[String:Any]) -> Void {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
