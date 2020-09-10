//
//  CameraRoll.swift
//  CameraRoll
//
//  Created by Amir Shayegh on 2018-11-09.
//

import Foundation
import UIKit
import Photos

public class CameraRoll {
    public init() {}
    // Bundle
    public static var bundle: Bundle {
        let podBundle = Bundle(for: CameraRoll.self)

        if let bundleURL = podBundle.url(forResource: "CameraRoll", withExtension: "bundle"), let b = Bundle(url: bundleURL) {
            return b
        } else {
            print("Fatal Error: Could not find bundle for FreshDate Frameworks")
            fatalError()
        }
    }

    public func present(in vc: UIViewController, mode: GalleryMode, then: @escaping ((_ selected: [PHAsset]?) -> Void )) {
        let gm = GalleryManager()
        vc.present(gm.getVC(mode: mode, callBack: then), animated: true)
    }

}
