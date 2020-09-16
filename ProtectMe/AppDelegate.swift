//
//  AppDelegate.swift
//  ProtectMe
//
//  Created by Mac on 09/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import AVKit
import CoreLocation
import IntentsUI





let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

var loggedInUserData = USER()

@UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
    var FCMdeviceToken:String = ""
    
    let locationManager = LocationManager.sharedInstance
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentlatitude =  Double()
    var currentlogitude =  Double()
    var currentLC = CLLocationCoordinate2D()
    var latitude = String()
    var logitude = String()

    var ArrLocalVideoUploading:[localVideoModel] = [localVideoModel]()
    var objLocalVid:localVideoModel = localVideoModel()

    var badgeCount = 0
    var window: UIWindow?
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        INPreferences.requestSiriAuthorization({ status in
            if status == .authorized {
                print("Ok - authorized")
            }
        })
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })

            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

      
        self.SetNavigationBar()
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = "189381868477-65o7f6e55v9shdb27qv1rlbhve172u9f.apps.googleusercontent.com"
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
      ApplicationDelegate.shared.application(
                        application,
                        didFinishLaunchingWithOptions: launchOptions
        )
        if(USER.shared.id == ""){
            
            if let userActivity =   launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL { //Deeplink
                handleDeepLinkUrl(userActivity.absoluteURL)
            }
            else{
                self.setOnBoradingVC()
            }
        }
        else
        {
            
            self.setHome()
            
        }
       
        // Override point for customization after application launch.
        return true
    }
//facebook
//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
//
//    }
    func handleDeepLinkUrl(_ url: URL?){
     guard let url = url else {return}
//        print(url)
//        print(url.host)
//        print(url.fragment)
//        print(url.lastPathComponent)
        if let f = url.fragment{
            let a = f.description
            let b = a.replacingOccurrences(of: "Intent;scheme=fitrank;package=com.dev.ProtectMe;end://protectme/home/share/", with: "")
            print(b)
            USER.shared.videoUrl = b
            USER.shared.save()
            self.playVideo()
        }
        // more deeplink parser here
     }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivity]?) -> Void) -> Bool
    {
        if #available(iOS 12.0, *) {
            if let _ = userActivity.interaction?.intent as? DoSomethingIntent {
                USER.shared.voice_actionbyCommand = "1"
                USER.shared.save()
                self.setHome()
//                if let windowScene = scene as? UIWindowScene {
//                    self.window = UIWindow(windowScene: windowScene)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                    self.window!.rootViewController = initialViewController
//                    self.window!.makeKeyAndVisible()
//                    initialViewController.showMessage()
//                }
            }
        } else {
            // Fallback on earlier versions
        }
    
//        if #available(iOS 12.0, *) {
//                if userActivity.activityType ==  "Active_ProtectMe" {
//                    USER.shared.voice_actionbyCommand = "1"
//                    USER.shared.save()
//                    self.setHome()
//                 return true
//
//                }
//
//        }
            return true
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if #available(iOS 12.0, *) {
//                if userActivity.activityType ==  "Active_ProtectMe" {
//                    USER.shared.voice_actionbyCommand = "1"
//                    USER.shared.save()
//                    self.setHome()
//                 return true
//
//                }
            if userActivity.activityType != ""{
                USER.shared.voice_actionbyCommand = "1"
                USER.shared.save()
                self.setHome()
             return true

            }
        }
        return false
    }
    //func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler1: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       if #available(iOS 12.0, *) {
        if let activity = userActivity.interaction?.intent as? DoSomethingIntent{
            USER.shared.voice_actionbyCommand = "1"
                        USER.shared.save()
                        self.setHome()
                        return true
        }
        }
        handleDeepLinkUrl(userActivity.webpageURL)
       // }
           return true
       }

       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
           if url.host == "google" || url.host == "facebook" || url.host
                      == "authorize"
                  {
                      
                      let handledfb: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
                      
                      let handledgl =  GIDSignIn.sharedInstance().handle(url)
                      self.window?.makeKeyAndVisible()
                   
                      return handledfb || handledgl
                      
                  }
           else
           {
               handleDeepLinkUrl(url)
           }
           
         
                
           print("appdelegate deeplinking :",url)
           return true
       }
       func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

           let googleDidHandle = GIDSignIn.sharedInstance()?.handle(url as URL)

           let facebookDidHandle = ApplicationDelegate.shared.application(
               application,
               open: url as URL,
                   sourceApplication: sourceApplication,
                   annotation: annotation)

           return googleDidHandle! || facebookDidHandle
       }
       func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{

           //first launch after install for older iOS version
       handleDeepLinkUrl(url)
           print("appdelegate deeplinking :",url)

           return true
       }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      
        //var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        backgroundTask = application.beginBackgroundTask(withName:"MyBackgroundTask", expirationHandler: {() -> Void in
            // Time is up.
            if self.backgroundTask != UIBackgroundTaskIdentifier.invalid {
                
            }
        })
        // Perform your background task here
        print("The task has started")
        
    }
    private var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
            UIApplication.shared.endBackgroundTask(backgroundTask)
         backgroundTask = UIBackgroundTaskIdentifier.invalid
        
    }
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler1: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if #available(iOS 12.0, *) {
//                if userActivity.activityType ==  "open protecme" {
//                    USER.shared.voice_actionbyCommand = "1"
//                    USER.shared.save()
//                    self.setHome()
//                }
//
//        }
//    }
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if userActivity.activityType == "Open Scanner" {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            self.setHome()
//        }
//        return true
//    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func SetNavigationBar(){
           UINavigationBar.appearance().barTintColor = .init(red: 34.0/255, green: 42.0/255, blue: 52.0/255, alpha: 1.0)
        //   UITabBar.appearance().unselectedItemTintColor = .init(red: 70.0/255, green: 165.0/255, blue: 239.0/255, alpha: 1.0)
           UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Regular", size: 18)!,NSAttributedString.Key.foregroundColor : UIColor.white]

       // UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.foregroundColor : UIColor.white]

         UINavigationBar.appearance().tintColor = UIColor.white

           // To change colour of tappable items.
         //  UINavigationBar.appearance().tintColor = .white
           // To apply textAttributes to title i.e. colour, font etc.
         //  UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white,
         //                                                      .font : UIFont.init(name: "Poppins-SemiBold", size: 16.0)!]
           // To control navigation bar's translucency.
           UINavigationBar.appearance().isTranslucent = false
       }
    func setLoginVC() {
       self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "navSignup")
       self.window?.makeKeyAndVisible()
     }
    func setOnBoradingVC() {
      self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "onboardNav")
      self.window?.makeKeyAndVisible()
    }
    func setLinkAccountVC(selectd : String){
            //homnav
        if(selectd == "receiver"){
            USER.shared.LinkedAccSenederSelected = false
            USER.shared.save()
            
        }
        else{
            
                USER.shared.LinkedAccSenederSelected = true
                USER.shared.save()
                
            
        }
            self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "linkedaccNav")
            self.window?.makeKeyAndVisible()
           }

    func setArchiveVC(){
            //homnav
            self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "archiveNav")
            self.window?.makeKeyAndVisible()
           }
    func playVideo(){
        self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "homnav")
               self.window?.makeKeyAndVisible()

    }
    func setHome(){
        //homnav
        self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "homnav")
        self.window?.makeKeyAndVisible()
       }

}

extension AppDelegate {
    //MARK: - Get Location
        func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            let lon: Double = Double("\(pdblLongitude)")!
            
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                { (placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    print(placemarks)
                    
                    if placemarks != nil
                    {
                        if placemarks!.count > 0
                        {
                            
                            let pm = placemarks! as [CLPlacemark]
                            
                            if pm.count > 0 {
                                let pm = placemarks![0]
                                var addressString: String = ""
                                
    //                            if pm.subLocality != nil {
    //                                addressString = addressString + pm.subLocality! + ", "
    //                            }
    //                            if pm.thoroughfare != nil {
    //                                addressString = addressString + pm.thoroughfare! + ", "
    //                            }
                                
                                if pm.locality != nil {
                                    addressString = addressString + pm.locality! + ", "
                                }
                                if pm.country != nil {
                                    addressString = addressString + pm.country!
                                }
//                                self.lblStateCountry.text = addressString
//                                self.countrya = "\(pm.country ?? "")"
//                                self.citya = "\(pm.locality ?? "")"
                                USER.shared.country = "\(pm.country ?? "")"
                                USER.shared.city = "\(pm.locality ?? "")"
                                USER.shared.save()
                            }
                        }
                    }
                    else
                        
                    {
                        
                      //  let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(pdblLatitude),\(pdblLongitude)&sensor=true_or_false&key=AIzaSyB_esPyf3orZGf4e6DbUczwVFApgue6w1o"
                        
                        
                        
    //                    Alamofire.request(urlString, method: .post, parameters: nil, encoding: URLEncoding.default,headers:nil).responseJSON { response in
    //                        //            debugPrint(response)
    //                        if let json = response.result.value {
    //                            let dict:NSDictionary = (json as? NSDictionary)!
    //                            print(dict)
    //                            print(response)
    //
    //
    //                            let GetResults = dict.value(forKey: "results") as! NSArray
    //                            print(GetResults)
    //
    //                            if GetResults.count == 0
    //                            {
    //
    //                            }
    //                            else
    //                            {
    //                                let NewCheck = GetResults.value(forKey: "address_components") as! NSArray
    //                                print(NewCheck)
    //                                //let New = GetResults.value(forKey: "formatted_address") as! NSArray
    //
    //                                if NewCheck.count > 0
    //                                {
    //                                    let New = NewCheck.object(at: 0) as! NSArray
    //
    //
    //                                    for Object1 in New
    //                                    {
    //                                        print(Object1)
    //
    //                                        let p_z = Object1 as! NSDictionary
    //                                        let types = p_z.value(forKey: "types") as! NSArray
    //
    //                                        if types.count > 0
    //                                        {
    //                                            var value = String()
    //                                            value = types.object(at: 0) as! String
    //
    //                                            if value == "postal_code"
    //                                            {
    //                                                self.txtZipCode.text = "\(p_z.value(forKey: "long_name") as! String)"
    //                                            }
    //
    //                                            if value == "administrative_area_level_2" || value == "political"
    //                                            {
    //                                                self.txtCity.text = "\(p_z.value(forKey: "long_name") as! String)"
    //                                            }
    //
    //                                            if value == "country" || value == "political"
    //                                            {
    //                                                self.isCountrySelected = "\(p_z.value(forKey: "long_name") as! String)"
    //                                            }
    //
    //                                        }
    //                                    }
    //
    //                                }
    //
    //                            }
    //
    //                        }
    //
    //                    }
                        
                    }
                    
                    
                    
                    
            })
            
        }
    //MARK: - Show/Hide Loading Indicator
    func SHOW_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.startLoader()
    }
    func HIDE_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.stopLoader()
    }
    
}
//extension AppDelegate : UNUserNotificationCenterDelegate,MessagingDelegate {
    /*
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let userInfo = response.notification.request.content.userInfo as? NSDictionary {
            print("\(String(describing: userInfo))")
            
            let apsvalue = userInfo.getString(key: "push_type")
            
            print("value  : \(apsvalue)")
            switch apsvalue {
             case "1" :
                appDelegate.setLinkAccountVC()
                break
            case "2" :
                appDelegate.setArchiveVC()
                break
            case "3" :
                appDelegate.setArchiveVC()
                break
            case "4" :
                appDelegate.setHome()
                break
          
            default:
                print("opration")
                break
            }
        }
        
        completionHandler()
    }
    
    //MARK: - Register Remote Notification Methods // <= iOS 9.x
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    //MARK: - Remote Notification Methods // <= iOS 9.x
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.FCMdeviceToken = deviceTokenString
        
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let data_item = userInfo as NSDictionary
        let push_type = data_item.value(forKey: "push_type") as! String
        print(push_type)
       
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    // MARK: - UNUserNotificationCenter Delegate // >= iOS 10
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     //   self.setNotification()

        print("User Info = ",notification.request.content.userInfo)
        if let userInfo = notification.request.content.userInfo as? NSDictionary {
            print("\(String(describing: userInfo))")
        }
    
        completionHandler([.alert, .badge, .sound])
    }
    
   
    
    
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage)
    {
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //print("InstanceID token: \(refreshedToken)")
        //self.deviceToken = fcmToken
        self.FCMdeviceToken = fcmToken
    } */
//}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate{


func pushNotificationSettings(application: UIApplication) {
    if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
    } else {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
}
}
extension AppDelegate {
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Called to let your app know which action was selected by the user for a given notification.
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        let lNotification = UILocalNotification()
        lNotification.userInfo = response.notification.request.content.userInfo
        print(userInfo)
                
        if let userInfo = response.notification.request.content.userInfo as? NSDictionary {
                  print("\(String(describing: userInfo))")
            if let payload = userInfo.value(forKey: "payload") as? NSDictionary{
                let push_type = payload.value(forKey: "push_type") as? Int
//                let apsvalue = userInfo.getString(key: "push_type")

            let body = payload.value(forKey: "body") as? String
                
                  
                  print("value  : \(push_type)")
                  switch push_type {
                   case 1 :
                    if body?.lowercased().range(of:"receiver") != nil {
                        appDelegate.setLinkAccountVC(selectd: "sender")
                    }
                    else{
                        appDelegate.setLinkAccountVC(selectd: "receiver")

                    }
                      break
                  case 2 :
                      appDelegate.setArchiveVC()
                      break
                  case 3 :
                      appDelegate.setArchiveVC()
                      break
                  case 4 :
                      appDelegate.setHome()
                      break
                
                  default:
                      print("opration")
                      break
                  }
              }
              }
              completionHandler()
        
        
    }
    
    //MARK: - Register Remote Notification Methods // <= iOS 9.x
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    //MARK: - Remote Notification Methods // <= iOS 9.x
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        _ = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //self.deviceToken = deviceTokenString
        
        print(deviceToken.hexString)
        print(deviceToken)
        self.FCMdeviceToken = deviceToken.hexString
    }
    
    
    // MARK: - UNUserNotificationCenter Delegate // >= iOS 10
    //Called when a notification is delivered to a foreground app.
    
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage)
    {
        
    }
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        

        print("get push :  " , userInfo ,  UIApplication.shared.applicationState )

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

             completionHandler([.alert, .badge, .sound])

    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            print("Firebase registration token: \(fcmToken)")
        //self.DeviceToken = fcmToken
    }
}
extension AppDelegate:CLLocationManagerDelegate
{
    
    //MARK:- LOCATION METHODS
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        latitude = String(location.coordinate.latitude)
        logitude = String(location.coordinate.longitude)
        currentlatitude = Double(latitude)!
        currentlogitude = Double(logitude)!
        self.getAddressFromLatLon(pdblLatitude: latitude, withLongitude: logitude)
        self.currentLC = CLLocationCoordinate2DMake(self.currentlatitude,self.currentlogitude)
        
    }
    
}
//class IntentHandler: INExtension {
//override func handler(for intent: INIntent) -> Any {
//    print("IntentHandler.handle")
//    if #available(iOS 11.0, *) {
//        switch intent {
//        case is INAddTasksIntent: return AddIntentHandler()
//        default: break
//        }
//    } else {
//        // Fallback on earlier versions
//    }
//    return self
//}
//}
//@available(iOS 11.0, *)
//class AddIntentHandler: NSObject, INAddTasksIntentHandling {
//    @available(iOS 11.0, *)
//    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
//    print("AddIntentHandler.handle")
//        if #available(iOS 11.0, *) {
//            return completion(INAddTasksIntentResponse(code: .success, userActivity: nil))
//        } else {
//            // Fallback on earlier versions
//        }
//}
//}
