//
//  OnBordingVC.swift
//  ProtectMe
//
//  Created by Mac on 03/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit


class OnBordingVC: UIViewController {
    @IBOutlet weak var colle:UICollectionView!
   @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var btnBack:UIButton!

@IBOutlet weak var pageControl: UIPageControl!

    let str = ["Record and send videos to your cloud and designated recipients safely.","Videos automatically save and send even if they are interupted. \n Feel more protected and assured in any situation"]
    let img = [#imageLiteral(resourceName: "setp1"),#imageLiteral(resourceName: "step2")]
    
    
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.btnNext.isHidden = true
        self.btnBack.isHidden = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colle.delegate = self
        self.colle.dataSource = self
        if let layout = colle.collectionViewLayout as? UICollectionViewFlowLayout {
        layout.scrollDirection = .horizontal

    //    pageControl?.numberOfPages = 2

        // Do any additional setup after loading the view.
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
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.colle.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: true)

//        let collectionBounds = UIScreen.main.bounds
//        // let collectionBounds = self.collectionView.bounds
//        let contentOffset = CGFloat(floor(collectionBounds.origin.x - collectionBounds.size.width))
//               self.moveCollectionToFrame(contentOffset: contentOffset)


    }
    func moveCollectionToFrame(contentOffset : CGFloat) {

           let frame: CGRect = CGRect(x : contentOffset ,y : self.colle.contentOffset.y ,width : self.colle.frame.size.width,height : self.colle.frame.size.height)
           self.colle.scrollRectToVisible(frame, animated: true)
       }
    @IBAction func btnSkipClick(_ sender: UIButton) {
        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "signupVC") as! signupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension OnBordingVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return str.count
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
            if(Int(offSet + horizontalCenter) / Int(width) == 0){
                self.btnNext.isHidden = true
                self.btnBack.isHidden = true
            }
            else{
                self.btnNext.isHidden = false
                self.btnBack.isHidden = false
            }
        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:bordcell = collectionView.dequeueReusableCell(withReuseIdentifier: "bordcell", for: indexPath) as! bordcell
        cell.lblTitle.text = str[indexPath.row]
        cell.imgBoard.image = img[indexPath.row]
//        if(indexPath.row == 0){
//            self.btnNext.isHidden = true
//        }
//        else{
//            self.btnNext.isHidden = false
//        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.invalidateLayout()
        let cellWidth = UIScreen.main.bounds.size.width
              let cellHeight = UIScreen.main.bounds.size.height
              return CGSize(width: cellWidth, height: cellHeight)
       
       }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let cellWidth = UIScreen.main.bounds.size.width
        let cellHeight = UIScreen.main.bounds.size.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
class bordcell:UICollectionViewCell{
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgBoard:UIImageView!
}
