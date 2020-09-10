//
//  GalleryManager.swift
//  AllMyPics
//
//  Created by Amir Shayegh on 2017-12-18.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit
import Photos

class GalleryManager {
    lazy var galleryVC: ChooseImageViewController = {
        let storyboard = UIStoryboard(name: "ChooseImage", bundle: CameraRoll.bundle)
        return storyboard.instantiateViewController(withIdentifier: "ChooseImage") as! ChooseImageViewController
    }()

    var multiSelectResult = [PHAsset]()
    var callBack: ((_ selected: [PHAsset]?) -> Void)?

    init() {
        NotificationCenter.default.addObserver(forName: .selectedImages, object: nil, queue: nil, using:catchSelectedImages)
    }

    func getVC(mode: GalleryMode, callBack: @escaping ((_ selected: [PHAsset]?) -> Void )) -> UIViewController {
        self.callBack = callBack
        if mode == .Image{
            galleryVC.mode = .Image
            return galleryVC
        } else {
            galleryVC.mode = .Video
            return galleryVC
        }
    }

    // TODO: RENAME TO catchSelectedAssets
    func catchSelectedImages(notification:Notification) -> Void {
        self.multiSelectResult = (notification.userInfo!["name"] as! [PHAsset])
        if self.callBack != nil {
            callBack!(multiSelectResult)
        }
    }
    
    func setColors(bg_hex: String, utilBarBG_hex: String, buttonText_hex: String, loadingBG_hex: String, loadingIndicator_hex: String) {
        
        galleryVC.setColors(bg: UIColor(hex: bg_hex), utilBarBG: UIColor(hex: utilBarBG_hex), buttonText: UIColor(hex: buttonText_hex), loadingBG: UIColor(hex: loadingBG_hex), loadingIndicator: UIColor(hex: loadingIndicator_hex))
    }

}
