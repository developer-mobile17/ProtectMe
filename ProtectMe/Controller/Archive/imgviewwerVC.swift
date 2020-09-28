//
//  imgviewwerVCViewController.swift
//  ProtectMe
//
//  Created by Mac on 18/08/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit
import SDWebImage

class imgviewwerVC: UIViewController {
    @IBOutlet weak var img:UIImageView!
    var imgforview:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            let imgUrl = imgforview.replacingOccurrences(of: "Intent;scheme=protectme;package=com.dev.ProtectMe;end://protectme/home/share/", with: "")
                        
        self.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.img.sd_setImage(with: URL(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"),completed: nil)
                
    }
    @IBAction func closeView(sender:UIButton){
        //self.dismissTo()
         self.dismiss(animated: true, completion:nil)
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
