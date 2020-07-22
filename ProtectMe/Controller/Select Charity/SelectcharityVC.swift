//
//  SelectcharityVC.swift
//  ProtectMe
//
//  Created by Mac on 12/06/20.
//  Copyright © 2020 ZestBrains PVT LTD. All rights reserved.
//

import UIKit

class SelectcharityVC: UIViewController {

    @IBOutlet weak var tblCharity:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCharity.delegate = self
        tblCharity.dataSource = self

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackClick(_ sender: Any) {
           self.popTo()
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
extension SelectcharityVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "charityCell", for: indexPath)
        return cell
    }
    
    
}
class charityCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
}

