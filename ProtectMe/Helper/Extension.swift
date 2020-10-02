//
//  Extension.swift
//  SpiritVibe
//
//  Created by Mac on 26/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

//
//  Extension.swift
//  Dailies Task
//
//  Created by Malav's iMac on 9/9/19.
//  Copyright © 2019 agileimac-7. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
//import RNCryptor

let tabBarTintColor: UIColor = UIColor.red
let navigationBarTitleColor: UIColor = UIColor.black
let navigationBarTintColor: UIColor = UIColor.blue
let navigationBarbarTintColor: UIColor = UIColor.red
fileprivate let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
   

    return dateFormatter
}()


public class btnSetTitle: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
    }

}
extension UIFont {
    /*
     Font Family Name: Avenir
     == Avenir-Regular
     == Avenir-Bold
     */
    
    
    
    
    class func appFont_SourceSansProBold(Size:CGFloat)->UIFont{
        
        if let font = UIFont.init(name: "SourceSansPro-Bold", size: CGFloat(Size).proportionalFontSize()){
            return font
        } else {
            return UIFont (name: "HelveticaNeue", size: CGFloat(Size).proportionalFontSize())!
        }
    }
    
    
    class func appFont_SourceSansProSemiBold(Size:CGFloat)->UIFont{
        
        if let font = UIFont.init(name: "SourceSansPro-SemiBold", size: CGFloat(Size).proportionalFontSize()){
            return font
        } else {
            return UIFont (name: "HelveticaNeue", size: CGFloat(Size).proportionalFontSize())!
        }
    }
    class func appFont_SourceSansProRegular(Size:CGFloat)->UIFont{
           
           if let font = UIFont.init(name: "SourceSansPro-Regular", size: CGFloat(Size).proportionalFontSize()){
               return font
           } else {
               return UIFont (name: "HelveticaNeue", size: CGFloat(Size).proportionalFontSize())!
           }
       }
    class func appFont_SourceSansProMedium(Size:CGFloat)->UIFont{
        
        if let font = UIFont.init(name: "SourceSansPro-Medium", size: CGFloat(Size).proportionalFontSize()){
            return font
        } else {
            return UIFont (name: "HelveticaNeue", size: CGFloat(Size).proportionalFontSize())!
        }
    }
   
   
}

 

extension UIFont {
    var bold: UIFont { return withWeight(.bold) }
    var semibold: UIFont { return withWeight(.semibold) }
    
    private func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = weight
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

extension CGFloat{
    
    init?(_ str: String) {
        guard let float = Float(str) else { return nil }
        self = CGFloat(float)
    }
    
    
    func twoDigitValue() -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp //NumberFormatter.roundingMode.roundHalfUp
        
        
        //        let str : NSString = formatter.stringFromNumber(NSNumber(self))!
        let str = formatter.string(from: NSNumber(value: Double(self)))
        return str! as String;
    }
    
    
    
    func proportionalFontSize() -> CGFloat {
        
        var sizeToCheckAgainst = self
        
        if(IS_IPAD_DEVICE())    {
            //            sizeToCheckAgainst += 12
        }
        else {
            if(IS_IPHONE_6P_OR_6SP()) {
                sizeToCheckAgainst += 1
            }
            else if(IS_IPHONE_6_OR_6S()) {
                sizeToCheckAgainst += 0
            }
            else if(IS_IPHONE_5_OR_5S()) {
                sizeToCheckAgainst -= 1
            }
            else if(IS_IPHONE_4_OR_4S()) {
                sizeToCheckAgainst -= 2
            }
        }
        return sizeToCheckAgainst
    }
}

extension UIViewController {
    func UTCToLocalAM(date:String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
            return dateFormatter.string(from: dt!)
        }
    
//    func setTabBarVisiblee(visible: Bool, animated: Bool) {
//
//        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
//
//        // bail if the current state matches the desired state
//        if (tabBarIsVisiblee() == visible) { return }
//
//        // get a frame calculation ready
//        let frame = self.tabBarController?.tabBar.frame
//        let height = frame?.size.height
//        let offsetY = (visible ? -height! : height)
//
//        // zero duration means no animation
//        let duration: TimeInterval = (animated ? 0.3 : 0.0)
//
//        //  animate the tabBar
//        if frame != nil {
//            UIView.animate(withDuration: duration) {
//                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
//                return
//            }
//        }
//    }
//
//    func tabBarIsVisiblee() -> Bool {
//        return self.tabBar.frame.origin.y < self.view.frame.maxY
//    }
     func createString(value: AnyObject) -> String
     {
         var returnString: String = ""
         if let str: String = value as? String
         {
             returnString = str
         }
         else if let str: Int = value as? Int
         {
             returnString = String.init(format: "%d", str)
         }
             
         else if let _: NSNull = value as? NSNull
         {
             returnString = String.init(format: "")
         }
         return returnString
     }

     func getDictionaryFromDictionary(dictionary:NSDictionary, key:String) -> NSDictionary {
         
         if let value = dictionary[key] as? NSDictionary {
             
             let string = NSString.init(format: "%@", value as CVarArg) as String
             if (string == "null" || string == "NULL" || string == "nil") {
                 return NSDictionary()
             }
             return value
         }
         return NSDictionary()
     }
     //MARK: - Get Array From Dictionary
     func getArrayFromDictionary(dictionary:NSDictionary, key:String) -> NSArray {
         
         if let value = dictionary[key] as? NSArray {
             
             let string = NSString.init(format: "%@", value as CVarArg) as String
             if (string == "null" || string == "NULL" || string == "nil") {
                 return NSArray()
             }
             return value
         }
         return NSArray()
     }

     //MARK: - Get Array From Dictionary
     func getDictionryArrayFromDictionary(dictionary:NSDictionary, key:String) -> [NSDictionary] {
         
         if let value = dictionary[key] as? [NSDictionary] {
             
             let string = NSString.init(format: "%@", value as CVarArg) as String
             if (string == "null" || string == "NULL" || string == "nil") {
                 return [NSDictionary]()
             }
             return value
         }
         return [NSDictionary]()
     }
    func reloadViewFromNib() {
          let parent = view.superview
          view.removeFromSuperview()
          view = nil
          parent?.addSubview(view) // This line causes the view to be reloaded
      }
    // get top most view controller helper method.
    static var topMostViewController : UIViewController {
        get {
            return UIViewController.topViewController(rootViewController: UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
    
    fileprivate static func topViewController(rootViewController: UIViewController) -> UIViewController {
        guard rootViewController.presentedViewController != nil else {
            if rootViewController is UITabBarController {
                let tabbarVC = rootViewController as! UITabBarController
                let selectedViewController = tabbarVC.selectedViewController
                return UIViewController.topViewController(rootViewController: selectedViewController!)
            }
                
            else if rootViewController is UINavigationController {
                let navVC = rootViewController as! UINavigationController
                return UIViewController.topViewController(rootViewController: navVC.viewControllers.last!)
            }
            
            return rootViewController
        }
        
        return topViewController(rootViewController: rootViewController.presentedViewController!)
    }
}
extension TimeZone {

    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }

    func offsetInHours() -> String
    {

        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}
extension Date {
    
    func toLocalTime() -> Date? {
        let tz = NSTimeZone.default as NSTimeZone
        let seconds = tz.secondsFromGMT(for: self as Date)
        return Date(timeInterval: TimeInterval(seconds), since: self as Date)
    }

    func toGlobalTime() -> Date? {
        let tz = NSTimeZone.default as NSTimeZone
        let seconds = -tz.secondsFromGMT(for: self as Date)
        return Date(timeInterval: TimeInterval(seconds), since: self as Date)
    }
}
//extension UITabBarController {
//    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
//        if (tabBarIsVisible() == visible) { return }
//        let frame = self.tabBar.frame
//        let height = frame.size.height
//        let offsetY = (visible ? -height : height)
//
//        // animation
//        UIViewPropertyAnimator(duration: duration, curve: .linear) {
//            //self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
//            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
//            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
//            self.view.setNeedsDisplay()
//            self.view.layoutIfNeeded()
//        }.startAnimation()
//    }
//
//    func tabBarIsVisible() ->Bool {
//        return self.tabBar.frame.origin.y < self.view.frame.maxY
//    }
//}
public extension UIViewController {
    
    
//    func UTCToLocal(date:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        return dateFormatter.string(from: dt!)
//    }
 
   func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = fromFormat
   // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX

       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        print(dateFormatter.dateFormat)
    print(dateFormatter.timeZone)
       let dt = dateFormatter.date(from: date)
       dateFormatter.timeZone = TimeZone.current
       dateFormatter.dateFormat = toFormat
    print(dateFormatter.dateFormat)
    print(dateFormatter.timeZone)

   return dateFormatter.string(from: dt!)
   }
    func UTCToLocalWithFormat(date:String,FirstFormat:String,SecondFormat:String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = FirstFormat
         dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
         let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        print(TimeZone.current.offsetFromUTC()) // output is +0530
        print(TimeZone.current.offsetInHours()) // output is "+05:30"

         return dateFormatter.string(from: dt!)
     }
    // MARK: - NavigationController Functions
    /// Set Appearance of UINavigationBar.
    func hideshowimg(val:Bool) -> Bool {
        if(val == true)
        {
            return false
        }
        else{
            return true
        }
    }
    
    func setWhiteStatusBar(){
        if #available(iOS 13.0, *) {
                      let app = UIApplication.shared
                      let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                      let statusbarView = UIView()
                      statusbarView.backgroundColor = .init(red: 34.0/255, green: 42.0/255, blue: 52.0/255, alpha: 1.0)
                      view.addSubview(statusbarView)
                      statusbarView.translatesAutoresizingMaskIntoConstraints = false
                      statusbarView.heightAnchor
                          .constraint(equalToConstant: statusBarHeight).isActive = true
                      statusbarView.widthAnchor
                          .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                      statusbarView.topAnchor
                          .constraint(equalTo: view.topAnchor).isActive = true
                      statusbarView.centerXAnchor
                          .constraint(equalTo: view.centerXAnchor).isActive = true
                  } else {
                      let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                      statusBar?.backgroundColor = .init(red: 34.0/255, green: 42.0/255, blue: 52.0/255, alpha: 1.0)
                        
                  }
    }

    func setAppearanceOfNavigationBar() {
        
        // Set navigationbar tittle,bar item , backgeound color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = navigationBarTintColor
        self.navigationController?.navigationBar.barTintColor = navigationBarbarTintColor
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: navigationBarTitleColor,
                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0) ]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key: AnyObject]
        
        // Set navigationbar back image(remove 'Back' from navagation)
        let backImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        // Set status bar
        // self.setStatusBar()
        
        // Set image in navigation title
        // let imageViewTitle = UIImageView(image:ImageNamed(name: "skilliTextLogo"))
        // imageViewTitle.contentMode = .scaleAspectFit
        // self.navigationItem.titleView = imageViewTitle
    }
   
    /// - Parameter viewController: your viewcontroller(String)
    func pushTo(_ viewController: String) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: viewController))!, animated: true)
    }
    
    /// Default pop mathord.
    func popTo() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Default pop to root controller.
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /// Default present methord
    ///
    /// - Parameter viewController: your viewcontroller(String)
    func presentTo(_ viewController: String) {
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: viewController)
        let navController = UINavigationController(rootViewController: VC1!)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    /// Default dismiss methord
    func dismissTo() {
        self.navigationController?.dismiss(animated: true, completion: {})
    }
    
    // MARK: - NavigationBar Functions
    /// Remove navigation bar item
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    /// Show or hide navigation bar
    ///
    /// - Parameter isShow: Bool(true, false)
    func showNavigationBar(_ isShow: Bool) {
        self.navigationController?.isNavigationBarHidden = !isShow
    }
    
    // Right,left buttons
    /// Set left side Navigationbar button image.
    ///
    /// - Parameters:
    ///   - Name: set image name
    ///   - selector: return selector
    func setLeftBarButtonImage(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: selector)
        }
    }
    
    /// Set left side Navigationbar button title.
    ///
    /// - Parameters:
    ///   - Name: button name
    ///   - selector: return selector
    func setLeftBarButtonTitle(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: name, style: UIBarButtonItem.Style.plain, target: self, action: selector)
        }
    }
    
    /// Set right side Navigationbar button image.
    ///
    /// - Parameters:
    ///   - Name: set image name
    ///   - selector: return selector
    func setRightBarButtonImage(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: selector)
        }
    }
    
    /// Set right side Navigationbar button title.
    ///
    /// - Parameters:
    ///   - Name: button name
    ///   - selector: return selector
    func setRightBarButtonTitle(_ name: String, selector: Selector) {
        if self.navigationController != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: name, style: UIBarButtonItem.Style.plain, target: self, action: selector)
        }
    }
    
    /// Set right side two Navigationbar button image.
    ///
    /// - Parameters:
    ///   - btn1Name: First button image name
    ///   - selector1: Second button selector
    ///   - btn2Name: First button image name
    ///   - selector2: Second button selector
    func setThreeRightBarButtonImage(_ btn1Name: String, selector1: Selector, btn2Name: String, selector2: Selector, btn3Name: String, selector3: Selector) {
        if self.navigationController != nil {
            let barBtn1: UIBarButtonItem =  UIBarButtonItem(image: UIImage(named: btn1Name), style: .plain, target: self, action: selector1)
            let barBtn2: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: btn2Name), style: .plain, target: self, action: selector2)
            let barBtn3: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: btn3Name), style: .plain, target: self, action: selector3)
            let buttons: [UIBarButtonItem] = [barBtn1, barBtn2,barBtn3]
            self.navigationItem.rightBarButtonItems = buttons
        }
    }
    
    /*
     func setRightBarButtonTitle(_ Name : String, selector : Selector) {
     
     if (self.navigationController != nil) {
     var barButton : UIBarButtonItem = UIBarButtonItem()
     barButton = UIBarButtonItem.init(title:Name.localized, style: UIBarButtonItemStyle.plain, target: self, action: selector)
     barButton.setTitleTextAttributes([ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.0),
     NSAttributedStringKey.foregroundColor : UIColor.white,
     NSAttributedStringKey.backgroundColor:UIColor.white],
     for: UIControlState())
     self.navigationItem.rightBarButtonItem = barButton
     }
     }
     */
    
    // MARK: - TabBar Functions
    /// Set TabBar visiblity
    ///
    
    /// Set AppearanceOfTabBar
    func setAppearanceOfTabBar() {
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.tintColor = tabBarTintColor
    }
    //check used skipped
    func GoTOLoginWhenUserSkip() -> Void{
        if(USER.shared.id == ""){
                   showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: AlertMessage.LoginToContinue, buttons: ["Okay"]) { (i) in
                       if #available(iOS 13.0, *) {
                        //   sceneDelegate.setLoginVC()
                       } else {
                          // appDelegate.setLoginVC()
                                                           // Fallback on earlier versions
                       }
                   }
               }
    }
    /// Remove TabBar
    func removeTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    func loginToContinue(){
      
        showAlertWithTitleFromVC(vc: self, title: Constant.APP_NAME, andMessage: "PLease login to continue.", buttons: ["Okay"]) { (i) in
            if #available(iOS 13.0, *) {
             //   sceneDelegate.setLoginVC()
                  } else {
               //       appDelegate.setLoginVC()
                  }
        }
    }
    // MARK: - UIViewController Functions
    /// Load your VieweContoller
    ///
    /// - Returns: self
    class func loadController(strStoryBoardName: String = "Main") -> Self {
        return instantiateViewControllerFromMainStoryBoard(strStoryBoardName: strStoryBoardName)
    }
    
    /// Set instantiat ViewController
    ///
    /// - Returns: self
    private class func instantiateViewControllerFromMainStoryBoard<T>(strStoryBoardName: String) -> T {
        guard let controller  = UIStoryboard(name: strStoryBoardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as? T else {
            fatalError("Unable to find View controller with identifier")
        }
        return controller
    }
    
    /// Set status bar background color
    ///
    /// - Parameter color: your color
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    /// Set status bar style
    ///
    /// - Parameter style: statusbar style
    func setStatusBar(style: UIStatusBarStyle = .lightContent) {
        
        UIApplication.shared.statusBarStyle = style
    }
    
    /// Return Top Controller from window
    static var topMostController: UIViewController {
        if let topVC = UIViewController.topViewController() {
            return topVC
        }
        else if let window =  UIApplication.shared.delegate!.window, let rootVC = window?.rootViewController {
            return rootVC
        }
        return UIViewController()
    }
    
    private class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension UITextField{
    func TextFieldshadow(view:UITextField){
     let Shape = CAShapeLayer()
      let myPath = UIBezierPath(ovalIn: view.frame)
     Shape.shadowPath = myPath.cgPath
     Shape.shadowColor = UIColor.lightGray.cgColor
     Shape.shadowOffset = CGSize(width: 0, height: 3)
     Shape.shadowRadius  = 5
     Shape.shadowOpacity = 0.8
     view.layer.insertSublayer(Shape, at: 0)

    }
}
extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appFont_SourceSansProMedium(Size: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.appFont_SourceSansProMedium(Size: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
extension UIColor {
    static var randomColor: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}
extension UIColor {
    
    static let clrSkyBlue:UIColor = UIColor.init(red: 88/255.0, green: 173/255.0, blue: 237/255.0, alpha: 1.0)
    static let clrDeselect:UIColor = UIColor.init(red: 79/255.0, green: 162/255.0, blue: 145/255.0, alpha: 1.0)
    
    //extra
    static let selectedTableCell =  UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
     static let online =  UIColor(red: 31.0/255.0, green: 209.0/255.0, blue: 66.0/255.0, alpha: 1.0)
     static let offline =  UIColor(red: 188.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    
    static let gradiant1 =  UIColor(red: 255.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0)
       static let gradiant2 =  UIColor(red: 252.0/255.0, green: 191.0/255.0, blue: 122.0/255.0, alpha: 1.0)
    static let NavigationColor =  UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)

    
    
    static let HeaderTitleBlackColor =  UIColor(red: 49.0/255.0, green: 48.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    static let HeaderInfoGrayColor:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let PlaceholderGrayColor:UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
     static let TextFieldGrayColor:UIColor = UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    static let SubmitButtonColor:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
     static let TitleButtonColor:UIColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    static let BodyInfoLightGrayColor:UIColor = UIColor.init(red: 199.0/255.0, green: 199.0/255.0, blue: 199.0/255.0, alpha: 1.0)
    static let ThemeRedColor:UIColor = UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let Themegradiant1:UIColor = UIColor.init(red: 118.0/255.0, green: 112.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    static let Themegradiant2:UIColor = UIColor.init(red: 240.0/255.0, green: 174.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    static let TextFieldBorderColor:UIColor = UIColor.init(red: 226.0/255.0, green: 230.0/255.0, blue: 234.0/255.0, alpha: 1.0)
    static let themeBlueColor:UIColor = UIColor.init(red: 99.0/255.0, green: 186.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    static let cellBorderColor:UIColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    static let dashedBorder:UIColor = UIColor.init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 0.1)
    
    
    
    static let themeShadowColor:UIColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1)
    
    static let themeGrayColor:UIColor = UIColor.init(red: 166/255.0, green: 166/255.0, blue: 166/255.0, alpha: 1.0)
    
    static let themeBlueColorUneri:UIColor = UIColor.init(red: 13/255.0, green: 116/255.0, blue: 148/255.0, alpha: 1.0)

    static let themeGreenColorUneri =  UIColor(red: 55.0/255.0, green: 158.0/255.0, blue: 135.0/255.0, alpha: 1.0)

    
    static let redColor:UIColor = UIColor.init(red: 250/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    
    static let orangeColor:UIColor = UIColor.init(red: 248/255.0, green: 90/255.0, blue: 84/255.0, alpha: 1.0)

    
    static let yellowColor:UIColor = UIColor.init(red: 255/255.0, green: 196/255.0, blue: 03/255.0, alpha: 1.0)

    static let approveColor:UIColor = UIColor.init(red: 100/255.0, green: 183/255.0, blue: 163/255.0, alpha: 1.0)

    static let navcoler:UIColor = UIColor.init(red: 32/255.0, green: 42/255.0, blue: 52/255.0, alpha: 1.0)

    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func themeTintColor() -> UIColor {
        return UIColor.init(red: 0, green: 122, blue: 255)
    }
    
    
}
extension String {
 
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

public extension UIAlertController {
    
    /// Show AlertController with message only
    ///
    /// - Parameters:
    ///   - message: set your message
    ///   - buttonTitles: set button array
    ///   - buttonAction: return button click block
    static func showAlert(withMessage message: String,
                                 buttonTitles: [String] = ["Okay"],
                                 buttonAction: ((_ index: Int) -> Void)? = nil) {
        var appName = ""
        if let dict = Bundle.main.infoDictionary, let name = dict[kCFBundleNameKey as String] as? String {
            appName = name
        }
        
        self.showAlert(withTitle: appName,
                       withMessage: message,
                       buttonTitles: buttonTitles,
                       buttonAction: buttonAction)
        
    }
    
    /// Show AlertController with message and title
    ///
    /// - Parameters:
    ///   - title: set your title
    ///   - message: set your message
    ///   - buttonTitles: set button array
    ///   - buttonAction: return button click block
    static func showAlert(withTitle title: String,
                                 withMessage message: String,
                                 buttonTitles: [String],
                                 buttonAction: ((_ index: Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for btn in buttonTitles {
            alertController.addAction(UIAlertAction(title: btn, style: .default, handler: { (_) in
                if let validHandler = buttonAction {
                    validHandler(buttonTitles.firstIndex(of: btn)!)
                }
            }))
        }
        // (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alertController, animated: true, completion: nil)
        UIApplication.shared.delegate!.window!?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    /// Show Actionsheet with message only
    ///
    /// - Parameters:
    ///   - vc: where you display (UIViewController)
    ///   - message: your message
    ///   - buttons: button array
    ///   - canCancel: with cancel button
    ///   - completion: completion handler
    static func showActionSheetFromVC(_ viewController: UIViewController,
                                             andMessage message: String,
                                             buttons: [String],
                                             canCancel: Bool,
                                             completion: ((_ index: Int) -> Void)?) {
        var appName = ""
        if let dict = Bundle.main.infoDictionary, let name = dict[kCFBundleNameKey as String] as? String {
            appName = name
        }
        
        self.showActionSheetWithTitleFromVC(viewController,
                                            title: appName,
                                            andMessage: message,
                                            buttons: buttons,
                                            canCancel: canCancel,
                                            completion: completion)
    }
    
    /// Show Actionsheet with message and title
    ///
    /// - Parameters:
    ///   - vc: where you display (UIViewController)
    ///   - title: Alert title
    ///   - message: your message
    ///   - buttons: button array
    ///   - canCancel: with cancel button
    ///   - completion: completion handler
    static func showActionSheetWithTitleFromCurrentVC(_ message: String,
                                               buttons: [String],
                                               canCancel: Bool,
                                               completion: ((_ index: Int) -> Void)?) {
        
        
        if let viewController = appDelegate.window?.rootViewController
        {
        var appName = ""
        if let dict = Bundle.main.infoDictionary, let name = dict[kCFBundleNameKey as String] as? String {
            appName = name
        }
        
        
        
        let alertController = UIAlertController(title: appName, message: message, preferredStyle: .actionSheet)
        
        for index in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[index], style: .default, handler: { (_) in
                if let handler = completion {
                    handler(index)
                }
            })
            alertController.addAction(action)
        }
        
        if canCancel {
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                if let handler = completion {
                    handler(buttons.count)
                }
            })
            
            alertController.addAction(action)
        }
        
        if UIDevice.isIpad {
            
            if viewController.view != nil {
                alertController.popoverPresentationController?.sourceView = viewController.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: (viewController.view?.frame.size.height)!, width: 1.0, height: 1.0)
            } else {
                alertController.popoverPresentationController?.sourceView = UIApplication.shared.delegate!.window!?.rootViewController!.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
            }
        }
        viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// Show Actionsheet with message and title
    ///
    /// - Parameters:
    ///   - vc: where you display (UIViewController)
    ///   - title: Alert title
    ///   - message: your message
    ///   - buttons: button array
    ///   - canCancel: with cancel button
    ///   - completion: completion handler
    static func showActionSheetWithTitleFromVC(_ viewController: UIViewController,
                                                      title: String,
                                                      andMessage message: String,
                                                      buttons: [String],
                                                      canCancel: Bool,
                                                      completion: ((_ index: Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for index in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[index], style: .default, handler: { (_) in
                if let handler = completion {
                    handler(index)
                }
            })
            alertController.addAction(action)
        }
        
        if canCancel {
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                if let handler = completion {
                    handler(buttons.count)
                }
            })
            
            alertController.addAction(action)
        }
        
        if UIDevice.isIpad {
            
            if viewController.view != nil {
                alertController.popoverPresentationController?.sourceView = viewController.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: (viewController.view?.frame.size.height)!, width: 1.0, height: 1.0)
            } else {
                alertController.popoverPresentationController?.sourceView = UIApplication.shared.delegate!.window!?.rootViewController!.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
            }
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}


public extension UIDevice {
    
    enum DeviceType: Int {
        case iPhone4or4s
        case iPhone5or5s
        case iPhone6or6s
        case iPhone6por6sp
        case iPhoneXorXs
        case iPhoneXrorXsMax
        case iPad
    }
    
    /// Check Decide type
    static var deviceType: DeviceType {
        // Need to match width also because if device is in portrait mode height will be different.
        if UIDevice.screenHeight == 480 || UIDevice.screenWidth == 480 {
            return DeviceType.iPhone4or4s
        } else if UIDevice.screenHeight == 568 || UIDevice.screenWidth == 568 {
            return DeviceType.iPhone5or5s
        } else if UIDevice.screenHeight == 667 || UIDevice.screenWidth == 667 {
            return DeviceType.iPhone6or6s
        } else if UIDevice.screenHeight == 736 || UIDevice.screenWidth == 736 {
            return DeviceType.iPhone6por6sp
        } else if UIDevice.screenHeight == 812 || UIDevice.screenWidth == 812 {
            return DeviceType.iPhoneXorXs
        } else if UIDevice.screenHeight == 896 || UIDevice.screenWidth == 896 {
            return DeviceType.iPhoneXorXs
        } else {
            return DeviceType.iPad
        }
    }
    
    /// Check device is Portrait mode
    static var isPortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    /// Check device is Landscape mode
    static var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    // MARK: - Device Screen Height
    
    /// Return screen height
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    // MARK: - Device Screen Width
    
    /// Return screen width
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// Return screen size
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// Return device model name
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    // MARK: - Device is iPad
    /// Return is iPad device
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // MARK: - Device is iPhone
    
    /// Return is iPhone device
    static var isIphone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}


extension UIView {
    //  Converted to Swift 5.2 by Swiftify v5.2.31636 - https://swiftify.com/


    func diffroundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
class lefttopcorner: UIView {
    override init (frame : CGRect) {
        super.init(frame : frame)
        let rectShape = CAShapeLayer()
              rectShape.bounds = frame
        rectShape.position = self.layer.position
              rectShape.path = UIBezierPath(roundedRect: self.layer.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
              // Masking the View
        //rectShape.borderColor = UIColor.cellBorderColor.cgColor
        rectShape.borderWidth = 1
              self.layer.mask = rectShape
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width:  self.layer.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height:  self.layer.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.layer.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.layer.frame.size.height)
        self.layer.addSublayer(border)
    }



    

    
    func roundCornersWithBorder(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    

    func addDropShadow(onoff:Bool) -> Void {
        if(onoff == true)
        {
            self.layer.masksToBounds = false;
                   self.layer.shadowOffset = CGSize.init(width: 0, height: 0);
                   self.layer.shadowRadius = 3;
                   self.layer.shadowColor = UIColor.black.cgColor
                   self.layer.shadowOpacity = 0.2;
        }
        else{
            self.layer.masksToBounds = false;
                   self.layer.shadowOffset = CGSize.init(width: 0, height: 0);
                   self.layer.shadowRadius = 3;
                   self.layer.shadowColor = UIColor.clear.cgColor
                   self.layer.shadowOpacity = 0;
        }
       
    }
    
    func addDropShadowLight() -> Void {
           
           self.layer.masksToBounds = false;
           self.layer.shadowOffset = CGSize.init(width: 0, height: 0);
           self.layer.shadowRadius = 1;
           self.layer.shadowColor = UIColor.black.cgColor
           self.layer.shadowOpacity = 0.1;
       }
    
    
    func addDropShadowForbutton() -> Void {
        
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowColor = UIColor .black.cgColor
        self.layer.shadowOpacity = 0.3;
    }
    func addBottomShadow() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: layer.bounds.height))
        shadowPath.addLine(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height))
        shadowPath.addLine(to: CGPoint(x: layer.bounds.width, y: layer.bounds.height + 5))
        shadowPath.addLine(to: CGPoint(x: 0, y: layer.bounds.height + 5))
        shadowPath.close()

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 3
    }
    
    //----------------------------------------------------------------
    func applyShadowWithColor(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)    {
        
        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace) //CGSizeMake(0, -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0) //CGSizeMake(-shadowSpace, 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace) //CGSizeMake(0, shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0) //CGSizeMake(shadowSpace, 0)
        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace) //CGSizeMake(-shadowSpace, -shadowSpace )
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace) //CGSizeMake(shadowSpace, -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace) //CGSizeMake(-shadowSpace, shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace) //CGSizeMake(shadowSpace, shadowSpace)
            
            
        case .All:
            sizeOffset = CGSize(width: 0, height: 0) //CGSizeMake(0, 0)
        case .None:
            sizeOffset = CGSize.zero
        }
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        // self.clipsToBounds = false
        self.layer.masksToBounds = false
        //
        //
        //
        //
    }
    
}
extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
             path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
    }
}
extension UIView{
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}


//MARK:- AIEdge -
enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}


extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}


extension UIView {
    
    private struct AssociatedKeys {
        static var descriptiveName = "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView: BlurView {
        get {
            if let blurView = objc_getAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName
                ) as? BlurView {
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView) {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.descriptiveName,
                blurView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    class BlurView {
        
        private var superview: UIView
        private var blur: UIVisualEffectView?
        private var editing: Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView: UIView?
        
        var animationDuration: TimeInterval = 0.1
        
        /**
         * Blur style. After it is changed all subviews on
         * blurContentView & vibrancyContentView will be deleted.
         */
        var style: UIBlurEffect.Style = .light {
            didSet {
                guard oldValue != style,
                    !editing else { return }
                applyBlurEffect()
            }
        }
        /**
         * Alpha component of view. It can be changed freely.
         */
        var alpha: CGFloat = 0 {
            didSet {
                guard !editing else { return }
                if blur == nil {
                    applyBlurEffect()
                }
                let alpha = self.alpha
                UIView.animate(withDuration: animationDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style, alpha: CGFloat) -> Self {
            self.editing = true
            
            self.style = style
            self.alpha = alpha
            
            self.editing = false
            
            return self
        }
        
        func enable(isHidden: Bool = false) {
            if blur == nil {
                applyBlurEffect()
            }
            
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect() {
            blur?.removeFromSuperview()
            
            applyBlurEffect(
                style: style,
                blurAlpha: alpha
            )
        }
        
        private func applyBlurEffect(style: UIBlurEffect.Style,
                                     blurAlpha: CGFloat) {
            superview.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
            blurEffectView.contentView.addSubview(vibrancyView)
            
            blurEffectView.alpha = blurAlpha
            
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        }
    }
    
    private func addAlignedConstrains() {
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.leading)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.trailing)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
    }
    
    private func addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute) {
        superview?.addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0
            )
        )
    }
}



extension Date {
    // Convert local time to UTC (or GMT)
       func toGlobalTime() -> Date {
           let timezone = TimeZone.current
           let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
           return Date(timeInterval: seconds, since: self)
       }

       // Convert UTC (or GMT) to local time
       func toLocalTime() -> Date {
           let timezone = TimeZone.current
           let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
           return Date(timeInterval: seconds, since: self)
       }
      func isEqualTo(_ date: Date) -> Bool {
        return self == date
      }

      func isGreaterThan(_ date: Date) -> Bool {
         return self > date
      }

      func isSmallerThan(_ date: Date) -> Bool {
         return self < date
      }
    func getyyyMMddStr() -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .none
           formatter.dateFormat = "yyyyMMddHHmmss"
           return formatter.string(from: self)
       }
    func getyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "yyyy-MM-dd h:mm:ss a"
        return formatter.string(from: self)
    }
    func getMonthFullname() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    func getMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    func getMonthasString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    func getYear() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    func timeAgoSinceDate() -> String {

           // From Time
           let fromDate = self

           // To Time
           let toDate = Date()

           // Estimation
           // Year
           if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

               return interval == 1 ? "\(interval)" + " " + "yr" : "\(interval)" + " " + "yrs"
           }

           // Month
           if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

               return interval == 1 ? "\(interval)" + " " + "mon" : "\(interval)" + " " + "mons"
           }

           // Day
           if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

               return interval == 1 ? "\(interval)" + " " + "day" : "\(interval)" + " " + "days"
           }

           // Hours
           if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

               return interval == 1 ? "\(interval)" + " " + "hr" : "\(interval)" + " " + "hrs"
           }

           // Minute
           if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

               return interval == 1 ? "\(interval)" + " " + "mnt" : "\(interval)" + " " + "mnts"
           }

           return "a moment ago"
       }
   func getElapsedInterval() -> String {

       var calendar = Calendar.current
       calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
   // IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN
   // WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE
   // (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME
   // IS GOING TO APPEAR IN SPANISH

       let formatter = DateComponentsFormatter()
       formatter.unitsStyle = .full
       formatter.maximumUnitCount = 1
       formatter.calendar = calendar

       var dateString: String?

    let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day , .hour , .minute , .second], from: self, to: Date())

       if let year = interval.year, year > 0 {
           formatter.allowedUnits = [.year] //2 years
       } else if let month = interval.month, month > 0 {
           formatter.allowedUnits = [.month] //1 month
       } else if let week = interval.weekOfYear, week > 0 {
           formatter.allowedUnits = [.weekOfMonth] //3 weeks
       } else if let day = interval.day, day > 0 {
           formatter.allowedUnits = [.day] // 6 days
       }
        else if let hour = interval.hour, hour > 0 {
            formatter.allowedUnits = [.hour] // 6 days
        }
        else if let minute = interval.minute, minute > 0 {
            formatter.allowedUnits = [.minute] // 6 days
        }
        else if let second = interval.second, second > 0 {
            formatter.allowedUnits = [.second] // 6 second
        }


       else {
           let dateFormatter = DateFormatter()
           dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
           dateFormatter.dateStyle = .medium
           dateFormatter.doesRelativeDateFormatting = true

           dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
       }

       if dateString == nil {
           dateString = formatter.string(from: self, to: Date())
       }

       return dateString!
   }
    var monthday: String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "d MMM"
           return dateFormatter.string(from: self as Date)
       }
    var yearmonthday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self as Date)
    }
    var monthdateYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self as Date)
    }
    func startOfMonth() -> Date {
           return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
       }

       func endOfMonth() -> Date {
           return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
       }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

 

extension String {
     

    func toDate(withFormat format: String )-> Date?{

           let dateFormatter = DateFormatter()
      //  dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       // dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
       // dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH

     //   dateFormatter.timeZone = TimeZone.current

         //  dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        //   dateFormatter.locale = Locale(identifier: "fa-IR")
      //  dateFormatter.calendar = Calendar(identifier: .gregorian)
           dateFormatter.dateFormat = format
        
           let date = dateFormatter.date(from: self)
           return date

       }
    func convertDateFormater(_ date: String,from:String,to:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = to
        return  dateFormatter.string(from: date!)

    }
    public func toInt() -> Int?
       {
          if let num = NumberFormatter().number(from: self) {
                   return num.intValue
               } else {
                   return nil
               }
        }
    public func toDouble() -> Double?
       {
          if let num = NumberFormatter().number(from: self) {
                   return num.doubleValue
               } else {
                   return nil
               }
        }
//    var localized: String {
//        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }
}
public extension String {

    /// Assuming the current string is base64 encoded, this property returns a String
    /// initialized by converting the current string into Unicode characters, encoded to
    /// utf8. If the current string is not base64 encoded, nil is returned instead.
    var base64Decoded: String? {
        guard let base64 = Data(base64Encoded: self) else { return nil }
        let utf8 = String(data: base64, encoding: .utf8)
        return utf8
    }

    /// Returns a base64 representation of the current string, or nil if the
    /// operation fails.
    var base64Encoded: String? {
        let utf8 = self.data(using: .utf8)
        let base64 = utf8?.base64EncodedString()
        return base64
    }

}
extension URL {
 func valueOf(_ queryParamaterName: String) -> String? {
 guard let url = URLComponents(string: self.absoluteString) else { return nil }
 return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value?.removingPercentEncoding?.removingPercentEncoding
 }
}

extension UIDevice {
    @available(iOS 11.0, *)
    var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }

        return false
    }
}

extension String {
    var StrTobool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
var boolValue: Bool {
//    var bool: Bool {
//           return self == "1" ? true : false
//       }
    
       return self == "1" ? true : false
}}
public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat,selected:UIColor) {
        let border = CALayer()
        border.backgroundColor = selected.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}
extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
extension UILabel {

    var isTruncated: Bool {

        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
}

extension UIImage
{
    var highestQualityJPEGNSData: NSData { return self.jpegData(compressionQuality: 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.0)! as NSData }
}
extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    var containsImage: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }
    var containsAudio: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
    var containsVideo: Bool {
        let mimeType = self.mimeType()
        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }

}
