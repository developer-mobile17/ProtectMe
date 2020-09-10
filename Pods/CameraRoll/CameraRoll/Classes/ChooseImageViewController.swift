//
//  ChooseImageViewController.swift
//  imageMultiSelect
//
//  Created by Amir Shayegh on 2017-12-12.
//  Copyright © 2017 Amir Shayegh. All rights reserved.
//

import UIKit
import Photos

extension Notification.Name {
    static let selectedImages = Notification.Name("selectedImages")
}

class ChooseImageViewController: UIViewController {

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loadingContainer: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pageTitle: UILabel!
    
    var images = [PHAsset]()
    var selectedIndexs = [Int]()

    var callBack: ((_ close: Bool) -> Void )?

    let cellReuseIdentifier = "GalleryImageCell"
    let cellXibName = "GalleryImageCollectionViewCell"

    var mode: GalleryMode = GalleryMode.Image

    // colors:
    var bg: UIColor = UIColor(hex: "#ffffff")
    var utilBarBG: UIColor = UIColor(hex: "#ffffff")
    var buttonText: UIColor = UIColor(hex: "#007AFF")
    var loadingBG: UIColor = UIColor(hex: "#ffffff")
    var loadingIndicator: UIColor = UIColor(hex: "#007AFF")

    override func viewDidLoad() {
        super.viewDidLoad()
        lockdown()
        style()
        loadData()
        setUpCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(sent), name: .selectedImages, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        styleContainer(view: navBar.layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unlock()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.selectedIndexs.removeAll()
    }

    func sendBackImages(images: [PHAsset]) {
        NotificationCenter.default.post(name: .selectedImages, object: self, userInfo: ["name":images])
        unlock()
        closeVC()
    }

    @objc func sent() {}

    @objc func appWillEnterForeground() {
        if self.images.count != AssetManager.sharedInstance.getPHAssetImages().count {
            reloadData()
        }
    }

    @IBAction func addImages(_ sender: Any) {
        if selectedIndexs.count == 0 {
            closeVC()
        }
        lockdown()
        var selectedImages = [PHAsset]()
        for index in selectedIndexs {
            selectedImages.append(images[index])
        }
        sendBackImages(images: selectedImages)
    }

    @IBAction func cancel(_ sender: Any) {
        closeVC()
    }

    func closeVC() {
        self.selectedIndexs.removeAll()
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: {
            if self.callBack != nil {
                return self.callBack!(true)
            }
        })
    }

    func lockdown() {
        self.loading.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.loading.isHidden = false
        self.loadingContainer.isHidden = false
    }

    func unlock() {
        self.loading.stopAnimating()
        self.loading.isHidden = true
        self.loadingContainer.isHidden = true
        self.view.isUserInteractionEnabled = true
    }

    func reloadCellsOfInterest(indexPath: IndexPath) {
        let indexes = self.selectedIndexs.map { (value) -> IndexPath in
            return IndexPath(row: value, section: 0)
        }
        if indexes.contains(indexPath) {
            self.collectionView.reloadItems(at: indexes)
        } else {
            self.collectionView.reloadItems(at: indexes)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }

    func style() {
        loadingContainer.layer.cornerRadius = loadingContainer.frame.height / 2
        self.container.backgroundColor = bg
        self.loadingContainer.backgroundColor = loadingBG
        self.loading.color = loadingIndicator
        self.navBar.backgroundColor = UIColor.white
        self.cancelButton.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
        self.doneButton.setTitleColor(UIColor(hex: "#007AFF"), for: .normal)
        self.pageTitle.textColor = UIColor.black
        switch self.mode {
        case .Video:
            self.pageTitle.text = "Videos"
        case .Image:
            self.pageTitle.text = "Photos"
        }
    }

    func setColors(bg: UIColor, utilBarBG: UIColor, buttonText: UIColor, loadingBG: UIColor, loadingIndicator: UIColor) {
        self.bg = bg
        self.utilBarBG = utilBarBG
        self.buttonText = buttonText
        self.loadingBG = loadingBG
        self.loadingIndicator = loadingIndicator

    }

    func styleContainer(view: CALayer) {
        return
//        view.borderColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
//        view.shadowOffset = CGSize(width: 0, height: 2)
//        view.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
//        view.shadowOpacity = 0.3
//        view.shadowRadius = 3
    }
}

extension ChooseImageViewController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {

    func reloadData() {
        self.selectedIndexs.removeAll()
        loadData()
    }

    func loadData() {
        if self.mode == .Image {
            self.images = AssetManager.sharedInstance.getPHAssetImages()
            self.collectionView.reloadData()
        } else {
            self.images = AssetManager.sharedInstance.getPHAssetVideos()
            self.collectionView.reloadData()
        }
    }

    func setUpCollectionView() {
        self.collectionView.register(UINib(nibName: cellXibName, bundle: CameraRoll.bundle), forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setCollectionViewLayout()
    }

    func setCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = getCellSize()
        collectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GalleryImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! GalleryImageCollectionViewCell

        cell.setUp(selectedIndexes: selectedIndexs, indexPath: indexPath, phAsset: images[indexPath.row], primaryColor:UIColor(hex: "007AFF"), textColor: UIColor.white)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndexs.contains(indexPath.row) {
            selectedIndexs.remove(at: selectedIndexs.index(of: indexPath.row)!)

        } else {
            selectedIndexs.append(indexPath.row)
        }

        reloadCellsOfInterest(indexPath: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
    }

    func getCellSize() -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/4, height: self.collectionView.frame.size.width/4)
    }
}
