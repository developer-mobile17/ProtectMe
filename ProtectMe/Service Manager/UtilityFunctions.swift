//
//  UtilFunctions.swift
//  SpiritVibe
//
//  Created by Mac on 26/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//
import Foundation
import UIKit
import NVActivityIndicatorView





//class LoadingDailog: UIViewController, NVActivityIndicatorViewable {
//    
//    //MARK: - Shared Instance
//    static let sharedInstance : LoadingDailog = {
//        let instance = LoadingDailog()
//        return instance
//    }()
//    
//    func startLoader() {
//        startAnimating(nil, message: nil, messageFont: nil, type: .ballRotateChase, color: UIColor.ThemeRedColor, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
//    }
//    
//    func stopLoader() {
//        self.stopAnimating()
//    }
//}
let INTERNET_MESSAGE:String = "Please check your internet connection and try again."
func SHOW_INTERNET_ALERT(){
    showAlertWithTitleFromVC(vc: (appDelegate.window?.rootViewController)!, title:Constant.APP_NAME, andMessage: INTERNET_MESSAGE, buttons: ["Dismiss"]) { (index) in
    }
}



//MARK:- CUSTOM LOADER

func SHOW_CUSTOM_LOADER(){
    appDelegate.SHOW_CUSTOM_LOADER()
}

func SHOW_CUSTOM_LOADER_WITH_TEXT(text:String){
//    SVProgressHUD.setDefaultStyle(.custom)
//    //SVProgressHUD.setDefaultMaskType(.custom)
//    SVProgressHUD.setDefaultAnimationType(.flat)
//    SVProgressHUD.setDefaultMaskType(.custom)
//
//    SVProgressHUD.setBackgroundColor(UIColor.clear)
//    SVProgressHUD.setRingRadius(30)
//    SVProgressHUD.setRingThickness(5)
//    SVProgressHUD.setForegroundColor(UIColor.themeBlueColor)
//
//    if(text.count > 0){
//        SVProgressHUD.show(withStatus: text)
//    }else{
//        SVProgressHUD.show()
//    }
}

func HIDE_CUSTOM_LOADER(){
    
    //    AIDialogueLoader.shared.hide()
    appDelegate.HIDE_CUSTOM_LOADER()
   // SVProgressHUD.dismiss()
}



//----------------------------------------------------------------
//MARK:- PROPORTIONAL SIZE -
//let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//let SCREEN_WIDTH = UIScreen.main.bounds.size.width
//----------------------------------------------------------------
func GET_PROPORTIONAL_WIDTH (width:CGFloat) -> CGFloat {
//    return ((SCREEN_WIDTH * width)/750)
    return ((UIScreen.main.bounds.size.width * width)/375)
}
//----------------------------------------------------------------
func GET_PROPORTIONAL_HEIGHT (height:CGFloat) -> CGFloat {
//    return ((SCREEN_HEIGHT * height)/1334)
    print(UIScreen.main.bounds.size.height)
    return ((UIScreen.main.bounds.size.height * height)/667)
}

func GET_PROPORTIONAL_HEIGHT_ACCORDING_WIDTH (height:CGFloat) -> CGFloat {
    //    return ((SCREEN_HEIGHT * height)/1334)
        if UIScreen.main.bounds.size.width == 375 {
            return height
        }else if UIScreen.main.bounds.size.width == 414 {
            return ((736 * height)/667)
        }
        else{

            return height//((UIScreen.main.bounds.size.height * height)/667)
        }
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//MARK:- DEVICE CHECK -
//Check IsiPhone Device
func IS_IPHONE_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .phone
    return deviceType
}
//----------------------------------------------------------------
//Check IsiPad Device
func IS_IPAD_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad
    return deviceType
}
//----------------------------------------------------------------
//iPhone 4 OR 4S
func IS_IPHONE_4_OR_4S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 480
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == UIScreen.main.bounds.size.height)    {
        device = true
    }
    return device
}
//----------------------------------------------------------------
//iPhone 5 OR OR 5C OR 4S
func IS_IPHONE_5_OR_5S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 568
    var device:Bool = false
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == UIScreen.main.bounds.size.height)    {
        device = true
    }
    return device
}
//----------------------------------------------------------------
//iPhone 6 OR 6S
func IS_IPHONE_6_OR_6S()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 667
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == UIScreen.main.bounds.size.height)    {
        device = true
    }
    return device
}
//----------------------------------------------------------------
//iPhone 6Plus OR 6SPlus -
func IS_IPHONE_6P_OR_6SP()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 736
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == UIScreen.main.bounds.size.height)    {
        device = true
    }
    return device
}

//iPhone 6Plus OR 6SPlus -
func IS_IPHONE_x()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 812
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == UIScreen.main.bounds.size.height)    {
        device = true
    }
    return device
}

func IS_IPHONE_xR()->Bool{
    let SCREEN_HEIGHT_TO_CHECK_AGAINST:CGFloat = 896
    var device:Bool = false
    
    if(SCREEN_HEIGHT_TO_CHECK_AGAINST == UIScreen.main.bounds.size.height)    {
        device = true
    }
    return device
}
//

//----------------------------------------------------------------
//MARK:- DEVICE ORIENTATION CHECK -
func IS_DEVICE_PORTRAIT() -> Bool {
    return UIDevice.current.orientation.isPortrait
}
//----------------------------------------------------------------
func IS_DEVICE_LANDSCAPE() -> Bool {
    return UIDevice.current.orientation.isLandscape
}

//----------------------------------------------------------------
//MARK:- SYSTEM VERSION CHECK -
func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version,
                                                  options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
}
//----------------------------------------------------------------
func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version,
                                                  options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
}
//----------------------------------------------------------------
func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version,
                                                  options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
}
//----------------------------------------------------------------
func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version,
                                                  options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
}
//----------------------------------------------------------------
func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version,
                                                  options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
}
//----------------------------------------------------------------



//MARK:- ALERT

func showAlertWithTitleFromVC(vc:UIViewController, andMessage message:String)
{
    
    showAlertWithTitleFromVC(vc: vc, title:Constant.APP_NAME, andMessage: message, buttons: ["Dismiss"]) { (index) in
    }
}
func showAutoDismissAlert(vc:UIViewController,msg:String,time:Double, completion:((_ index:Int) -> Void)!) -> Void
{
    let alert = UIAlertController(title: Constant.APP_NAME, message: msg, preferredStyle: .alert)
    vc.present(alert, animated: true, completion: nil)
    
    // change to desired number of seconds (in this case 3 seconds)
    let when = DispatchTime.now() + time
    DispatchQueue.main.asyncAfter(deadline: when){
        // your code with delay
        alert.dismiss(animated: true, completion: nil)
        completion(0)
    }
}


func showAlertWithTitleFromVC(vc:UIViewController, title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    var newMessage = message
    if newMessage == "The Internet connection appears to be offline." {
        newMessage = INTERNET_MESSAGE
    }
    
    
    let alertController = UIAlertController(title: title, message: newMessage, preferredStyle: .alert)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        alertController.addAction(action)
    }
    vc.present(alertController, animated: true, completion: nil)
}


//MARK:- ACTION SHEET
func showActionSheetWithTitleFromVC(vc:UIViewController, title:String, andMessage message:String, buttons:[String],canCancel:Bool, completion:((_ index:Int) -> Void)!) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    
    
    
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        alertController.addAction(action)
    }
    
    if(canCancel){
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(buttons.count)
            }
        })
        
        alertController.addAction(action)
    }
    
    vc.present(alertController, animated: true, completion: nil)
}



extension String {
    
    func isValidMobileNumber() -> Bool{
        
        if self.length < 10
        {
            return false
        }
        else if self.length > 10
        {
            return true
        }
        else
        {
            return true
        }
    }
    
    func isValidFaxNumber() -> Bool{
        
        if self.length < 12
        {
            return false
        }
        else if self.length > 12
        {
            return false
        }
        else
        {
            return true
        }
    }
    public func isHaveMinmumPassword() -> Bool {
        if self.length < 6
        {
            return false
        }
        else if self.length > 6
        {
            return true
        }
        else
        {
            return true
        }
    }

    public func isValidPassword() -> Bool {
       // let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
       // let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"//mina
        let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$"//mina

        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    
    func isValidPostalCode() -> Bool {
        do {//  /[A-Z]{1,2}[0-9]{1,2}\s?[0-9]{1,2}[A-Z]{1,2}/i
            let regex = try NSRegularExpression(pattern: "[A-Z]{1,2}[0-9]{1,2}\\s[0-9]{1,2}[A-Z]{1,2}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }

    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
//    var length: Int {
//        return self.count
//    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
}

