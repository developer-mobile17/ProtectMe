//
//  VideoDetailsTableViewCell.swift
//  ProtectMe
//
//  Created by Mac on 09/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class VideoDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var btnMap:UIButton!
    @IBOutlet weak var btnPlayView:UIButton!

    @IBOutlet weak var videoThumb:UIImageView!
    @IBOutlet weak var imgType:UIImageView!
    @IBOutlet weak var progressBar:UIProgressView!{
       didSet{
           progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
       }
   }
@IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblName:UILabel!

    @IBOutlet weak var btnOption:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
