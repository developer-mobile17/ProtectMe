//
//  LinkedAccountTableViewCell.swift
//  ProtectMe
//
//  Created by Mac on 10/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class LinkedAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblpending:UILabel!
    @IBOutlet weak var imgLink:UIImageView!
    @IBOutlet weak var lodr:UIActivityIndicatorView!
    @IBOutlet weak var imgThreeDot:UIImageView!
    @IBOutlet weak var btnOption:UIButton!
    @IBOutlet weak var btnAccepOption:UIButton!
    @IBOutlet weak var btnRejectOption:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
