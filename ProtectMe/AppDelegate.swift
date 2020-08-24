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


let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

var loggedInUserData = USER()

@UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
    var FCMdeviceToken:String = ""
    var ArrLocalVideoUploading:[localVideoModel] = [localVideoModel]()
    var objLocalVid:localVideoModel = localVideoModel()

    var badgeCount = 0
    var window: UIWindow?
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.SetNavigationBar()
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = "189381868477-65o7f6e55v9shdb27qv1rlbhve172u9f.apps.googleusercontent.com"
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        ApplicationDelegate.shared.application(
                         application,
                         didFinishLaunchingWithOptions: launchOptions
                     )
        self.registerForRemoteNotification()
        if(USER.shared.id != ""){
            self.setHome()
        }
        else
        {
            self.setOnBoradingVC()
        }
        ApplicationDelegate.shared.application(
                   application,
                   didFinishLaunchingWithOptions: launchOptions
               )
        // Override point for customization after application launch.
        return true
    }
//facebook
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

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
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if #available(iOS 12.0, *) {
//            if userActivity.interaction?.intent is {intens} {
//                // App launched via that particular shortcut.
//            }
     //   }
    //}
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
    func setHome(){
        //homnav
        self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "homnav")
        self.window?.makeKeyAndVisible()
//        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "signinVC") as! signinVC
//
//           //let vc = storyBoards.Tabbar.instantiateViewController(withIdentifier: "recordVC") as! recordVC
//                      self.window?.rootViewController = vc
//                      self.window?.makeKeyAndVisible()
       }

}

extension AppDelegate {
    
    //MARK: - Show/Hide Loading Indicator
    func SHOW_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.startLoader()
    }
    func HIDE_CUSTOM_LOADER() {
        LoadingDailog.sharedInstance.stopLoader()
    }
    
}
extension AppDelegate : UNUserNotificationCenterDelegate,MessagingDelegate {
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Called to let your app know which action was selected by the user for a given notification.
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
//        let data_item = userInfo as NSDictionary
        let pust_type = userInfo.value(forKey:"push_type")!  as? String
        if(pust_type == "4"){
            let type = userInfo.value(forKey:"type")! as? String
                appDelegate.setHome()
        }
        
        else{
            
        }
        
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
    }
}
