//
//  imageviewerVC.swift
//  ProtectMe
//
//  Created by Mac on 15/07/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class imageviewerVC: UIViewController {
    var img:UIImage? = nil
    @IBOutlet weak var imgView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = img
        // Do any additional setup after loading the view.
    }
    @IBAction func btnCloseAction(_ sender: UIButton){
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
