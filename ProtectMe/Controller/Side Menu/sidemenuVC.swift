//
//  sidemenuVC.swift
//  ProtectMe
//
//  Created by Mac on 09/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import CoreLocation

class sidemenuVC: baseVC {
    typealias CompletionHandler = (_ success:Bool) -> Void

    //["img":#imageLiteral(resourceName: "ic_folders"),"name":"Folders"],
    let menuarr = [["img":#imageLiteral(resourceName: "ic_record"),"name":"Record"],["img":#imageLiteral(resourceName: "ic_archive"),"name":"Archives"],["img":#imageLiteral(resourceName: "ic_link"),"name":"Linked Accounts"],["img":#imageLiteral(resourceName: "ic_setting"),"name":"Settings"],["img":#imageLiteral(resourceName: "ic_deleted"),"name":"Deleted"],["img":#imageLiteral(resourceName: "ic_logout"),"name":"Logout"]]
    @IBOutlet weak var tblMenu:UITableView!
    @IBOutlet weak var lblName:UILabel!{
        didSet{
            lblName.text = USER.shared.name
        }
    }
    @IBOutlet weak var lblStateCountry:UILabel!{
        didSet{
            //lblStateCountry.text = "\(USER.shared.city),\(USER.shared.country)"
        }
    }
    func setUserLocation(){
          let locationManager = LocationManager.sharedInstance
          locationManager.showVerboseMessage = false
          locationManager.autoUpdate = true
            
          self.locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
                self.latitude = latitude
                self.longitude = longitude
            
                  self.locationManager.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude) { (dict, placemark, str) in
                    var city1 = ""
                          if let city = dict?["locality"] as? String{
                              city1 = city
                          }
                    var country1 = ""
                          if let country = dict?["country"] as? String{
                              country1 = country
                          }
                      USER.shared.save()
                      self.lblStateCountry.text = "\(city1),\(country1)"

                          }
                    self.locationManager.autoUpdate = false
                   }
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenu.delegate = self
        tblMenu.dataSource = self
        //lblName.text = USER.shared.name

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                self.lblStateCountry.text = "\(USER.shared.city),\(USER.shared.country)"
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                DispatchQueue.main.async {
                    self.setUserLocation()
                }
                @unknown default:
                break
            }
            } else {
                print("Location services are not enabled")
        }
        lblName.text = USER.shared.name
        self.lblStateCountry.text = "\(USER.shared.city),\(USER.shared.country)"
        
//        DispatchQueue.main.async {
//            self.locationManager.reverseGeocodeLocationWithLatLon(latitude: USER.shared.latitude.toDouble()!, longitude: USER.shared.longitude.toDouble()!) { (dict, placemark, str) in
//                  if let city = dict?["locality"] as? String{
//                      USER.shared.city = city
//                  }
//                  if let country = dict?["country"] as? String{
//                      USER.shared.country = country
//                  }
//                  USER.shared.save()
//                  }
//
//        }
    }
        // MARK: - Navigation
}
extension sidemenuVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuCell
        cell.lblMenu.text = menuarr[indexPath.row]["name"] as? String
        cell.imgMenu.image = menuarr[indexPath.row]["img"] as? UIImage
        cell.lblNotificationCount.isHidden = true
        cell.viewRound.isHidden = true
        
        if(indexPath.row == 2){
        cell.lblNotificationCount.isHidden = false
            cell.viewRound.isHidden = false

            if ( USER.shared.linked_account_counters != "0"){
                cell.lblNotificationCount.text = USER.shared.linked_account_counters
                print(USER.shared.linked_account_counters)
                cell.viewRound.isHidden = false
                cell.lblNotificationCount.isHidden = false

            }
            else{
                cell.viewRound.isHidden = true
                cell.lblNotificationCount.isHidden = true


            }
            cell.viewRound.layer.cornerRadius = cell.viewRound.layer.frame.size.height/2
            cell.lblNotificationCount.layer.cornerRadius = cell.lblNotificationCount.layer.frame.size.height/2
            cell.lblNotificationCount.clipsToBounds = true
        }
        if(indexPath.row == 1){
        cell.lblNotificationCount.isHidden = false
        if (USER.shared.archived_counter != "0"){
            cell.lblNotificationCount.text = USER.shared.archived_counter
            print(USER.shared.archived_counter)
            cell.viewRound.isHidden = false
            cell.lblNotificationCount.isHidden = false
        }
        else{
            cell.viewRound.isHidden = true
            cell.lblNotificationCount.isHidden = true
        }
            cell.viewRound.layer.cornerRadius = cell.viewRound.layer.frame.size.height/2
            cell.lblNotificationCount.layer.cornerRadius = cell.lblNotificationCount.layer.frame.size.height/2
            cell.lblNotificationCount.clipsToBounds = true
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "recordVC") as!  recordVC
            
            self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
        else if(indexPath.row == 4){
            let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "deletedVC") as!  deletedVC
                self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
            }
        else if(indexPath.row == 1){
            let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "archiveVC") as!  archiveVC
            self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
        else if(indexPath.row == 2){
            let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "LinkedAccountVC") as!  LinkedAccountVC
            self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
        else if(indexPath.row == 3){
            let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as!  settingVC
            self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
        }
        
        else if(indexPath.row == 5){
            self.LogOut()
        }
    }
    func LogOut(){
      
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage:AlertMessage.logoutMessage, buttons: ["Cancel","Logout"]) { (i) in
            if(i == 1){
                self.WSLogout(Parameter: [:])
            }
                
        }
    }
    func WSLogout(Parameter:[String:String]) -> Void {
        ServiceManager.shared.callGetAPI(WithType: .logout, isAuth: true, passString: "", WithParams: Parameter, Success:  { (DataResponce, Status, Message) in
            if(Status == true){
                let dataResponce:Dictionary<String,Any> = DataResponce as! Dictionary<String, Any>
                let StatusCode = DataResponce?["status"] as? Int
                if (StatusCode == 200){
                    
                USER.shared.clear()
                appDelegate.setLoginVC()
                USER.shared.isLogout = true
                USER.shared.save()

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
            
        }) { (dataResponce, status, errorMessage) in
            
        }
    }
    
    
}
class menuCell: UITableViewCell {
    @IBOutlet weak var imgMenu:UIImageView!
    @IBOutlet weak var lblMenu:UILabel!
    @IBOutlet weak var lblNotificationCount:UILabel!
    @IBOutlet weak var viewRound:UIView!

}
