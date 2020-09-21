
import Foundation
import UIKit
let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
class AIReachabilityManager: NSObject {
    
    private let reachability = Reachability()
    private var isFirstTimeSetupDone:Bool = false
    private var callCounter:Int = 0
    
    // MARK: - SHARED MANAGER
    static let shared: AIReachabilityManager = AIReachabilityManager()
    
    
    //MARK:- ALL NETWORK CHECK
    func isInternetAvailableForAllNetworks() -> Bool {
        
        if(!self.isFirstTimeSetupDone){
            self.isFirstTimeSetupDone = true
            doSetupReachability()
        }
     
        return reachability!.connection != .none ||  reachability!.connection == .wifi || reachability!.connection == .cellular
        
        
    }
    
    
    //MARK:- SETUP
    func doSetupReachability() {
        
       
        reachability?.whenReachable = {  reachability in
            DispatchQueue.main.async {
                self.postIntenetReachabilityDidChangeNotification(isInternetAvailable: true)
            }
        }
        
        reachability?.whenUnreachable = {   reachability in
            DispatchQueue.main.async {
                self.postIntenetReachabilityDidChangeNotification(isInternetAvailable: false)
            }
        }
        
        do{
            try reachability?.startNotifier()
        }catch{
            
        }
        
    }
    
    deinit {
        reachability?.stopNotifier()
        //        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
    }
    
    
    
    //MARK:- NOTIFICATION
    private func postIntenetReachabilityDidChangeNotification(isInternetAvailable isAvailable:Bool){
        //        print("\n\n")
        //        print("NET REACHABILITY CHANGED : \(isAvailable)")
        
        DispatchQueue.main.async {
            
            if(isAvailable){
                
                // TO AVOID INITIAL ALERT
                if(self.callCounter != 0){
                    print("You are now ONLINE")
                    if let viewExits = appDelegate.window?.viewWithTag(-797){
                        viewExits.removeFromSuperview()
                    }
                }
            } else {
               
                print("You are now OFFLINE")
                let baseView = UIView(frame: CGRect(x: 10, y: 25, width: UIScreen.main.bounds.size.width-20, height: 50))
                baseView.backgroundColor = UIColor.red
                
                
                baseView.tag = -797
                
                let lblInternetMessage = UILabel(frame:CGRect(x: 0, y: 0, width: baseView.frame.size.width, height: baseView.frame.size.height))
                
                lblInternetMessage.text = "NO INTERNET CONNECTION"
                lblInternetMessage.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin)
                if #available(iOS 12.0, *) {
                    //lblInternetMessage.font = UIFont.monospacedSystemFont(ofSize: CGFloat(18).proportionalFontSize(), weight: .regular)
                } else {
                    // Fallback on earlier versions
                }
                lblInternetMessage.textAlignment = .center
                lblInternetMessage.numberOfLines = 0
                
                lblInternetMessage.textColor = UIColor.white
                lblInternetMessage.backgroundColor = UIColor.clear
                baseView.addSubview(lblInternetMessage)
 
//                appDelegate.window?.addSubview(baseView)
            }
            self.callCounter += 1
            
            
        }
        
    }
}

