//
//  GeneralUtility.swift
//  SurveyPlatform
//
//  Created by Devubha Manek on 12/11/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import MobileCoreServices

class GeneralUtility: NSObject {

    //MARK: - Shared Instance
    static let sharedInstance : GeneralUtility = {
        let instance = GeneralUtility()
        return instance
    }()
    
    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
                print("path : \(dbPath)")
            } catch let error1 as NSError {
                error = error1
            }
        }
    }
}

func setView(view: UIView, hidden: Bool) {
    UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
        view.isHidden = hidden
    })
}

//MARK: - NSString Extension

extension String {

        func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
            guard let range = self.range(of: needle) else { return nil }

            if beforeNeedle {
                return self.substring(to: range.lowerBound)
            }

            return self.substring(from: range.upperBound)
        }

    
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    func isStringWithoutSpace() -> Bool{
        return !self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var isAlphabate: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    var isAlphaNumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
    
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

//MARK: - NSDate Extention for UTC date
extension NSDate {
    func getStrCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        //dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self as Date)
    }
}

func getDayOfWeek() -> String {
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: Date())
    
    switch weekDay {
    case 2:
            return "Monday"
    case 3:
            return "Tuesday"
    case 4:
            return "Wednesday"
    case 5:
            return "Thursday"
    case 6:
            return "Friday"
    case 7:
            return "Saturday"
    case 1:
        return "Sunday"
    default:
        return ""
    }
}

func getMonthName() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    let strMonth = dateFormatter.string(from: Date())
    return strMonth
}

func getCurrentGrittings() -> String {
    
    let hour = Calendar.current.component(.hour, from: Date())
    
    if hour >= 0 && hour < 12 {
       return "Good Morning"
    } else if hour >= 12 && hour < 17 {
        return "Good Afternoon"
    } else if hour >= 17 && hour < 21 {
        return "Good Evening"
    } else {
        return "Good Night"
    }
}

func getCurrentDate() -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd, MMMM"
    let strDate = dateFormatter.string(from: Date())
    
    return strDate
}

func getDateFromString(date:String) -> Date {
    
   // NSLog("Str date :%@ ",date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //dateFormatter.timeZone = TimeZone.current
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: date)
    print("date :\(dt)")
    return dt ?? Date()
}

func getDateFromStringDate(date:String) -> Date {
    
    // NSLog("Str date :%@ ",date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dt = dateFormatter.date(from: date)
    return dt ?? Date()
}

func getStrFormatedDate(date:Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    let dt = dateFormatter.string(from: date)
    return dt
}

func getStrDateFromDate(date:Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM hh:mm a"
    dateFormatter.locale = Locale.current
    let dt = dateFormatter.string(from: date)
    return dt
}

func getStrDateFromDateNewFormate(date:Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM, hh:mm a"
    //dateFormatter.locale = Locale.current
    let dt = dateFormatter.string(from: date)
    return dt
}

func getStrOnlyTimeFromDate(date:Date) -> (String ,String) { //
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
    //dateFormatter.locale = Locale.current
    let dt = dateFormatter.string(from: date)

    //return dt
    var strArr = dt.split{$0 == " "}.map(String.init)

    return (strArr[0],strArr[1])
}

func getStrDateFromStrDate(date:String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    
    let dt = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "dd MMM yyyy"
    let date = dateFormatter.string(from: dt!)
    
    return date
}

func getStrFullDateFromStrDate(date:String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
    dateFormatter.timeZone = TimeZone.current
    let date = dateFormatter.string(from: dt!)
    
    return date
}

func getStrDateFromDate(date:String) -> (String) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    //dateFormatter.locale = Locale.current
    let dt = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
    let date = dateFormatter.string(from: dt!)
    
    return date
}

func getStrDateFromStrDate(strdate:String) -> (String) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: strdate)
    
    dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
    dateFormatter.timeZone = TimeZone.current
    
    let date = dateFormatter.string(from: dt!)
    
    return date
}

struct WebURL {
    
    //static let baseURL:String = "http://project-demo-server.info/bleapp/api/v1/"
    //static let baseURL:String = "http://13.58.163.209/bleapp/api/v1/"
   
    static let baseURL:String = "http://zestbrains4u.site/bin/ws/v1/"
    static let appkey:String = "1137711c03ccd82e230a55fe9f6c2123"
    static let tokenKey:String = "Authorization"

    static let ImageBaseUrl = "http://project-demo-server.info/prozlist/public/upload/"
    static let login:String = WebURL.baseURL + "user/login"
    static let registerUser:String = WebURL.baseURL + "user/register_user"
    static let forgotPassword:String = WebURL.baseURL + "user/forgot_password"
    static let getUserProfile:String = WebURL.baseURL + "user/get_own_data"
    static let getOtherUser:String = WebURL.baseURL + "user/get_user_data"
    static let editUserProfile:String = WebURL.baseURL + "user/edit_profile"
    static let getMyProductList:String = WebURL.baseURL + "user/get_own_ads"
    static let userLogout:String = WebURL.baseURL + "user/logout"
    static let changePassword:String = WebURL.baseURL + "/user/change_password"
    static let notificationSetting:String = WebURL.baseURL + "/user/notification"
    static let getProductList:String = WebURL.baseURL + "ads/home"
    static let getCatagroyList:String = WebURL.baseURL + "user/get_category"
    static let createProduct:String = WebURL.baseURL + "ads/create_edit_ads"
    static let addAddress:String = WebURL.baseURL + "user/add_edit_address"
    static let getAddressList:String = WebURL.baseURL + "user/address_list"
    static let favUnfavItem:String = WebURL.baseURL + "ads/favourite_ad"
    static let getfavouriteList:String = WebURL.baseURL + "ads/favourite_list"
    static let getFriendsList:String = WebURL.baseURL + "user/master_follow"
    static let followUnfollow:String = WebURL.baseURL + "user/follow"
    static let notificationList:String = WebURL.baseURL + "user/notification_listing"
    static let placeOrder:String = WebURL.baseURL + "user/buy_product"
    static let getOrderList:String = WebURL.baseURL + "user/my_product_listing"
    static let getCourierList:String = WebURL.baseURL + "user/get_courier_service_list"
    static let changeOrderStatus:String = WebURL.baseURL + "user/change_order_status"
    static let writeReview:String = WebURL.baseURL + "user/add_user_review"
    static let deleteItem:String = WebURL.baseURL + "ads/delete_ad"
    static let clearNotification:String = WebURL.baseURL + "/user/clear_notification"
    static let searchProductList:String = WebURL.baseURL + "ads/search"
    static let getReviewList:String = WebURL.baseURL + "user/get_user_rating"
}

//MARK: - StoryBoards Constant
struct storyBoards {
    static let Main = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let Home = UIStoryboard(name: "Home", bundle: Bundle.main)
    static let History = UIStoryboard(name: "History", bundle: Bundle.main)
    static let Tabbar = UIStoryboard(name: "Tabbar", bundle: Bundle.main)
    static let Profile = UIStoryboard(name: "Profile", bundle: Bundle.main)
    static let Chat = UIStoryboard(name: "Chat", bundle: Bundle.main)
}

//MARK: - Device Type
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XS_MAX     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

//MARK: - Screen Size
struct ScreenSize {
    static let WIDTH         = UIScreen.main.bounds.size.width
    static let HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
}

//MARK: - Font Layout
struct FontName {
    //Font Name List
    static let HelveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    static let HelveticaNeueLight = "HelveticaNeue-Light"
    static let HelveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    static let HelveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    static let HelveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    static let HelveticaNeueThin = "HelveticaNeue-Thin"
    static let HelveticaNeueMedium = "HelveticaNeue-Medium"
    static let HelveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    static let HelveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    static let HelveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    static let HelveticaNeueBold = "HelveticaNeue-Bold"
    static let HelveticaNeue = "HelveticaNeue"
    static let HelveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    static let RobotoRegular = "Roboto-Regular"
    static let RobotoLight = "Roboto-Light"
}

func showAlert(title: NSString, message: String) {
    
    let obj = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle:"OK")
    obj.show()
}

// MARK: - Hex to UIcolor
func hexStringToUIColor (hex:String) -> UIColor {
    
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class LoadingDailog: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: - Shared Instance
    static let sharedInstance : LoadingDailog = {
        let instance = LoadingDailog()
        return instance
    }()
    
    func startLoader() {
        startAnimating(nil, message: nil, messageFont: nil, type: .ballScaleRipple, color: .darkGray, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    func stopLoader() {
        self.stopAnimating()
    }
}

//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(viewController: slide.mainViewController)
        //        }
        return viewController
    }
}

//MARK: - check string nil
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

//MARK: - check string nil
func createFloatToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%.2f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

func createDoubleToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%.1f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

//MARK: - check string nil
func createIntToString(value: AnyObject) -> String
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

func createStringToint(value: AnyObject) -> Int
{
    var returnString: Int = 0
    
    if  value as! String == ""
    {
        returnString = 0
    }else{
        returnString = Int(value as! String)!
    }
    
    return returnString
}
func creatArray(value: AnyObject) -> NSMutableArray
{
    var tempArray = NSMutableArray()
    
    if let arrData: NSArray = value as? NSArray
    {
        tempArray = NSMutableArray.init(array: arrData)
    }
    else if let _: NSNull = value as? NSNull
    {
        tempArray = NSMutableArray.init()
    }
    
    return tempArray
}
class CircleControl: UIControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
func creatDictnory(value: AnyObject) -> NSMutableDictionary
{
    var tempDict = NSMutableDictionary()
    
    if let DictData: NSDictionary = value as? NSDictionary
    {
        tempDict = NSMutableDictionary.init()
        tempDict.addEntries(from:DictData as! [AnyHashable : Any])
    }
    else if let _: NSNull = value as? NSNull
    {
        tempDict = NSMutableDictionary.init()
    }
    
    return tempDict
}

//func UTCToLocal(date:String) -> String {
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//    let dt = dateFormatter.date(from: date)
//    dateFormatter.timeZone = TimeZone.current
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    var str = ""
//    if dt != nil
//    {
//        str = dateFormatter.string(from: dt!)
//    }
//    return str
//}

//MARK: - Get Bool From Dictionary
func getBoolFromDictionary(dictionary:NSDictionary, key:String) -> Bool {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string.lowercased() == "null" || string == "nil") {
            return false
        }
        if (string.isNumber) {
            
            return Bool(NSNumber(integerLiteral: Int(string)!))
        } else if (string.lowercased() == "false" || string == "0" || string == "no") {
            return false
            
        } else if (string.lowercased() == "true" || string == "1" || string == "yes") {
            return true
            
        } else {
            return false
        }
    }
    return false
}

//MARK: - Get String From Dictionary
func getStringFromDictionary(dictionary:NSDictionary, key:String) -> String {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return ""
        }
        return string.removeWhiteSpace() as String
    }
    return ""
}

//MARK: - Get Dictionary From Dictionary
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

//MARK: - Set Color Method
func setColor(r: Float, g: Float, b: Float, aplha: Float)-> UIColor {
    return UIColor(red: CGFloat(Float(r / 255.0)), green: CGFloat(Float(g / 255.0)) , blue: CGFloat(Float(b / 255.0)), alpha: CGFloat(aplha))
}
//MARK: - Color
struct Color
{
    static let textColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
    static let keyboardHeaderColor = UIColor(red: 27.0 / 255.0, green: 170.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
}

extension UIColor{
    class func AppOrange() -> UIColor {
        return UIColor.init(red: 252.0/255.0, green: 167.0/255.0, blue: 6.0/255.0, alpha: 1.0)
    }
    class func AppYellow() -> UIColor {
        return UIColor.init(red: 245.0/255.0, green: 117.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    class func AppRed() -> UIColor {
        return UIColor.init(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    class func AppGreen() -> UIColor {
        return UIColor.init(red: 64.0/255.0, green: 198.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    class func AppSky() -> UIColor {
        return UIColor.init(red: 69.0/255.0, green: 193.0/255.0, blue: 253.0/255.0, alpha: 1.0)
    }
    
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class PaddingTextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}


extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

//MARK: - UIView Extension

extension UIView {
    
    
    //MARK: - IBInspectable
    //Set Corner Radious
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
   
    @IBInspectable var SmallShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadowSmall()
            }
        }
    }
    
    @IBInspectable var AppColorShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.colorShadow()
            }
        }
    }
    
    func add_shadow(demoView : UIView,height : CGFloat){
        
        let radius: CGFloat = demoView.frame.width //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: -1, y: -1, width: radius + 0.5 , height:height - 4.0))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        demoView.layer.cornerRadius = 0.0
        demoView.layer.shadowColor = UIColor.darkGray.cgColor
        demoView.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)  //Here you control x and y
        demoView.layer.shadowOpacity = 0.2
        demoView.layer.shadowRadius = 2.0 //Here your control your blur
        demoView.layer.masksToBounds =  false
        demoView.layer.shadowPath = shadowPath.cgPath
    }
    
    func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                   shadowOffset: CGSize = CGSize.zero,
                   shadowOpacity: Float = 0.2,
                   shadowRadius: CGFloat = 1.8) {
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func colorShadow(shadowOffset: CGSize = CGSize.zero,
                   shadowOpacity: Float = 0.6,
                   shadowRadius: CGFloat = 4.0) {
        
        layer.shadowColor = hexStringToUIColor(hex: "FFFFFF").cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func addShadowSmall(shadowColor: CGColor = UIColor.black.cgColor,
                        shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                        shadowOpacity: Float = 0.2,
                        shadowRadius: CGFloat = 2.0) {
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    //Set Border Color
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    //Set Shadow in View
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    struct NLInnerShadowDirection: OptionSet {
        let rawValue: Int
        
        static let None = NLInnerShadowDirection(rawValue: 0)
        static let Left = NLInnerShadowDirection(rawValue: 1 << 0)
        static let Right = NLInnerShadowDirection(rawValue: 1 << 1)
        static let Top = NLInnerShadowDirection(rawValue: 1 << 2)
        static let Bottom = NLInnerShadowDirection(rawValue: 1 << 3)
        static let All = NLInnerShadowDirection(rawValue: 15)
    }
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    func removeInnerShadow() {
        for view in self.subviews {
            if (view.tag == 2639) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    func addInnerShadow() {
        let c = UIColor()
        let color = c.withAlphaComponent(0.5)
        
        self.addInnerShadowWithRadius(radius: 3.0, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, andAlpha: CGFloat) {
        let c = UIColor()
        let color = c.withAlphaComponent(alpha)
        
        self.addInnerShadowWithRadius(radius: radius, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, andColor: UIColor) {
        self.addInnerShadowWithRadius(radius: radius, color: andColor, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, color: UIColor, inDirection: NLInnerShadowDirection) {
        self.removeInnerShadow()
        
        let shadowView = self.createShadowViewWithRadius(radius: radius, andColor: color, direction: inDirection)
        
        self.addSubview(shadowView)
    }
    
    func createShadowViewWithRadius(radius: CGFloat, andColor: UIColor, direction: NLInnerShadowDirection) -> UIView {
        let shadowView = UIView(frame: CGRect(x: -5,y: 0-5,width: self.bounds.size.width+10,height: self.bounds.size.height+10))
        shadowView.backgroundColor = UIColor.clear
        shadowView.tag = 2639
        
        let colorsArray: Array = [ andColor.cgColor, UIColor.clear.cgColor ]
        
        if direction.contains(.Top) {
            let xOffset: CGFloat = 0.0
            let topWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 0.0)
            shadow.endPoint = CGPoint(x:0.5,y: 1.0)
            shadow.frame = CGRect(x: xOffset,y: 0,width: topWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Bottom) {
            let xOffset: CGFloat = 0.0
            let bottomWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 1.0)
            shadow.endPoint = CGPoint(x:0.5,y: 0.0)
            shadow.frame = CGRect(x:xOffset,y: self.bounds.size.height - radius, width: bottomWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Left) {
            let yOffset: CGFloat = 0.0
            let leftHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:0,y: yOffset,width: radius,height: leftHeight)
            shadow.startPoint = CGPoint(x:0.0,y: 0.5)
            shadow.endPoint = CGPoint(x:1.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Right) {
            let yOffset: CGFloat = 0.0
            let rightHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:self.bounds.size.width - radius,y: yOffset,width: radius,height: rightHeight)
            shadow.startPoint = CGPoint(x:1.0,y: 0.5)
            shadow.endPoint = CGPoint(x:0.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        return shadowView
    }
    
    func fadeIn(duration: TimeInterval = 0.2, delay: TimeInterval = 0.2, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.2, delay: TimeInterval = 0.2, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

@IBDesignable class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = .clear
    @IBInspectable var secondColor: UIColor = .black
    
    @IBInspectable var vertical: Bool = true
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 1.5)
        return layer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        //updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
//    func updateGradientDirection() {
//        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
//    }
}

var isIphoneXOrLonger: Bool {
    // 812.0 / 375.0 on iPhone X, XS.
    // 896.0 / 414.0 on iPhone XS Max, XR.
    return UIScreen.main.bounds.height / UIScreen.main.bounds.width >= 896.0 / 414.0
}



//MARK: - Get/Set UserDefaults
func setMyUserDefaults(value:Any, key:String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getMyUserDefaults(key:String)->Any {
    return UserDefaults.standard.value(forKey: key) ?? ""
}



class Alerts {
    
    static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}

@IBDesignable class BigSwitch: UISwitch {
    
    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}

class Slider: UISlider {
    
    @IBInspectable var thumbImage: UIImage?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var SliderScale : CGFloat = 1 {
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: SliderScale, y: SliderScale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
    
    var comperyear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var dayname: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
    var monthname: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var dayAndMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self)
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
}

func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
    
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}
extension UIButton{

    func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControl.State){
        self.setImage(image, for: state)

        if let frame = frame{
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
    }

}
extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func cropVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: ((_ outputUrl: URL) -> Void)? = nil)
    {
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let asset = AVAsset(url: sourceURL)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
      //  print("video length: \(length) seconds")

        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(sourceURL.lastPathComponent)")
            
        }catch let error {
            print(error)
        }

        //Remove existing file
        try? fileManager.removeItem(at: outputURL)

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4

        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                    end: CMTime(seconds: endTime, preferredTimescale: 1000))

        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                completion?(outputURL)
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
            default: break
            }
        }
    }
    func removeChildVC() {
           self.children.forEach {
               $0.willMove(toParent: nil)
               $0.view.removeFromSuperview()
               $0.removeFromParent()
           }
       }
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}
extension UIApplication {


class var statusBarBackgroundColor: UIColor? {
    get {
        return statusBarUIView?.backgroundColor
    } set {
        statusBarUIView?.backgroundColor = newValue
    }
}

class var statusBarUIView: UIView? {
    if #available(iOS 13.0, *) {
        let tag = 987654321
        if let statusBar = UIApplication.shared.keyWindow?.viewWithTag(tag) {
            return statusBar
        }
        else {
            let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBarView.tag = tag

            UIApplication.shared.keyWindow?.addSubview(statusBarView)
            return statusBarView
        }
    } else {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
}}

class Colors {
  let colorTop = UIColor(red: 255.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1.0)
  let colorBottom = UIColor(red: 252.0/255.0, green: 191.0/255.0, blue: 122.0/255.0, alpha: 1.0)

  let gl: CAGradientLayer

  init() {
    gl = CAGradientLayer()
    gl.colors = [ colorTop, colorBottom]
    gl.locations = [ 0.0, 1.0]
  }
}
