//
//  commonWebViewVC.swift
//  ProtectMe
//
//  Created by Mac on 11/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import WebKit

class commonWebViewVC: UIViewController {
    var titleString:String = ""
   // @IBOutlet weak var txtView:UITextView!
    private let webView = WKWebView(frame: .zero)

     override func viewDidLoad() {
         super.viewDidLoad()
                             webView.translatesAutoresizingMaskIntoConstraints = false
                             self.view.addSubview(self.webView)
                                // You can set constant space for Left, Right, Top and Bottom Anchors
                             NSLayoutConstraint.activate([
                                 self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                 self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                 self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                 self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                             ])
                             self.view.setNeedsLayout()
                    

         // Do any additional setup after loading the view.
     }
     
        // Do any additional setup after loading the view.
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.titleString
        appDelegate.SHOW_CUSTOM_LOADER()

        if(titleString == "Privacy Policy"){
            let request = URLRequest(url: URL.init(string: "http://deluxcoder.com/beta/protectme/ws/v1/user/content/privacy_policy")!)
            self.webView.load(request)
            //self.WSPrivacyPolicy(Parameter: [:])

        }
        else if(titleString == "Terms and Condition"){
             let request = URLRequest(url: URL.init(string: "http://deluxcoder.com/beta/protectme/ws/v1/user/content/term")!)
            self.webView.load(request)
        }
        else{
            let request = URLRequest(url: URL.init(string: "http://deluxcoder.com/beta/protectme/ws/v1/user/content/privacy_policy")!)
            self.webView.load(request)
        }
        appDelegate.HIDE_CUSTOM_LOADER()

    }
    @IBAction func btnBackClick(_ sender: Any) {
           self.popTo()
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

extension NSAttributedString {

internal convenience init?(html: String) {
    guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
        return nil
    }

    guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
        return nil
    }

    self.init(attributedString: attributedString)
}
}
extension commonWebViewVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
        appDelegate.SHOW_CUSTOM_LOADER()

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        appDelegate.HIDE_CUSTOM_LOADER()

    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        appDelegate.HIDE_CUSTOM_LOADER()
    }
}
