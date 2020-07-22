//
//  extention.swift
//  MarketApp
//
//  Created by Mac on 08/04/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import Foundation
import UIKit

//MARK: - StoryBoards Constant
//struct storyBoards {
    
//    static let LoginRegister = UIStoryboard(name: "LoginRegister", bundle: Bundle.main)
//    static let Tabbar = UIStoryboard(name: "Tabbar", bundle: Bundle.main)
//    static let Home = UIStoryboard(name: "Home", bundle: Bundle.main)
//    static let Profile = UIStoryboard(name: "Profile", bundle: Bundle.main)
//    static let Onboarding = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
//    static let Journal = UIStoryboard(name: "Journal", bundle: Bundle.main)
//    static let Discover = UIStoryboard(name: "Discover", bundle: Bundle.main)
//    static let Notification = UIStoryboard(name: "Notification", bundle: Bundle.main)

//}

extension UITabBarController {

    private struct AssociatedKeys {
        // Declare a global var to produce a unique address as the assoc object handle
        static var orgFrameView:     UInt8 = 0
        static var movedFrameView:   UInt8 = 1
    }

    var orgFrameView:CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.orgFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.orgFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    var movedFrameView:CGRect? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.movedFrameView) as? CGRect }
        set { objc_setAssociatedObject(self, &AssociatedKeys.movedFrameView, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let movedFrameView = movedFrameView {
            view.frame = movedFrameView
        }
    }

    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        //since iOS11 we have to set the background colour to the bar color it seams the navbar seams to get smaller during animation; this visually hides the top empty space...
        view.backgroundColor =  self.tabBar.barTintColor
        // bail if the current state matches the desired state
        if (TabBarIsVisible() == visible) { return }

        //we should show it
        if visible {
            tabBar.isHidden = false
            UIView.animate(withDuration: animated ? 0.3 : 0.0) {
                //restore form or frames
                self.view.frame = self.orgFrameView!
                //errase the stored locations so that...
                self.orgFrameView = nil
                self.movedFrameView = nil
                //...the layoutIfNeeded() does not move them again!
                self.view.layoutIfNeeded()
            }
        }
            //we should hide it
        else {
            //safe org positions
            orgFrameView   = view.frame
            // get a frame calculation ready
            let offsetY = self.tabBar.frame.size.height
            movedFrameView = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            //animate
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.view.frame = self.movedFrameView!
                self.view.layoutIfNeeded()
            }) {
                (_) in
                self.tabBar.isHidden = true
            }
        }
    }

    func TabBarIsVisible() ->Bool {
        return orgFrameView == nil
    }
}
