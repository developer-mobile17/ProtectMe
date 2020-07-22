//
//  uploadProgress.swift
//  ProtectMe
//
//  Created by Mac on 07/07/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class uploadProgress: UIViewController {
    @IBOutlet weak var progressbarview: UIProgressView!{
        didSet{
          //  progressbarview.progress = Float(FileUploafProgress)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(FileUploafProgress.binade > 0.0){
            let group = DispatchGroup()
            group.enter()

            DispatchQueue.main.async {
                self.progressbarview.setProgress(Float(FileUploafProgress), animated: true)
                group.leave()

        }
            group.wait()

        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnclose(_ sender: UIButton) {
        self.dismissTo()
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
