//
//  localVideoModel.swift
//  ProtectMe
//
//  Created by Mac on 18/08/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class localVideoModel: NSObject {
    var type            :String?
    var updated         :String?
    var progress        :Double = 0.0
    var name            :String?
    var thumbImage      :UIImage?
    var url             :URL?
    var numberofchunks  :Int?
    var isUploaded      :Bool = false
}
