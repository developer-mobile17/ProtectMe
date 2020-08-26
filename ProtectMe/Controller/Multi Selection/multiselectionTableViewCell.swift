//
//  multiselectionTableViewCell.swift
//  ProtectMe
//
//  Created by Mac on 25/08/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class multiselectionTableViewCell: UITableViewCell {
    @IBOutlet weak var btncheckbox:UIButton!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var videoThumb:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
