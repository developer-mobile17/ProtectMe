//
//  upgradeAccountVCViewController.swift
//  ProtectMe
//
//  Created by Mac on 12/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class upgradeAccountVC: UIViewController {
    @IBOutlet weak var btnMontly:UIButton!
    @IBOutlet weak var btnYearly:UIButton!
    @IBOutlet weak var btnPlan1:UIButton!
    @IBOutlet weak var btnPlan2:UIButton!
    @IBOutlet weak var btnPayment1:UIButton!

    @IBOutlet weak var btnPayment2:UIButton!

    @IBOutlet weak var view50GB:UIView!
    @IBOutlet weak var view300GB:UIView!

    
    var arrOption = [UIButton]()
    var arrPaymentBtn = [UIButton]()

    var arrPlan = [UIButton]()
    var arrPlanView = [UIView]()


    override func viewDidLoad() {
        super.viewDidLoad()
        arrOption = [btnMontly,btnYearly]
        arrPlan = [btnPlan1,btnPlan2]
        arrPlanView = [view50GB,view300GB]
        arrPaymentBtn = [btnPayment1,btnPayment2]
        self.selectOptions(selected: btnMontly)

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackClick(_ sender: Any) {
        self.popTo()
    }
    @IBAction func btnSelectPlanAction(_ sender: UIButton) {
        self.selectPlanRadioAction(selected: sender)
    }
    @IBAction func btnSelectPaymentAction(_ sender: UIButton) {
        selectPaymentRadioAction(selected: sender)
    }
    func selectPaymentRadioAction(selected:UIButton)  {
    for btn in arrPaymentBtn{
        if(btn == selected){
            btn.setImage(#imageLiteral(resourceName: "ic_radiofill"), for: .normal)
        }
        else{
            btn.setImage(#imageLiteral(resourceName: "ic_radioblank"), for: .normal)
            //btn.backgroundColor = UIColor.white
        }
    }
    }
    func selectPlanRadioAction(selected:UIButton)  {
        for btn in arrPlan{
            if(btn == selected){
                btn.setImage(#imageLiteral(resourceName: "ic_radiofill"), for: .normal)
            }
            else{
                btn.setImage(#imageLiteral(resourceName: "ic_radioblank"), for: .normal)
                //btn.backgroundColor = UIColor.white
            }
        }
        for _ in arrPlanView{
            if(selected == btnPlan1){
                view50GB.borderColor = UIColor.clrSkyBlue
                view300GB.borderColor = UIColor.lightGray
            }
            else{
                view50GB.borderColor = UIColor.lightGray
                view300GB.borderColor = UIColor.clrSkyBlue
                //btn.backgroundColor = UIColor.white
            }
        }
    }

    @IBAction func btnSelectPlan(_ sender: UIButton) {
        self.selectOptions(selected: sender)
    }
    func selectOptions(selected:UIButton)  {
        for btn in arrOption{
            if(btn == selected){
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.backgroundColor = UIColor.clrSkyBlue
            }
            else{
                btn.setTitleColor(UIColor.lightGray, for: .normal)
                btn.backgroundColor = UIColor.white
            }
        }
    }
    @IBAction func btnSelectCurancy(_ sender: Any) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectCurancyVC") as!  selectCurancyVC
             self.navigationController?.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnSelectCharity(_ sender: Any) {
        let OBJchangepasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectcharityVC") as!  SelectcharityVC
        self.navigationController?.pushViewController(OBJchangepasswordVC, animated: true)
    }
    @IBAction func btnProseed(_ sender: Any) {
        
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
