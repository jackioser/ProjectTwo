//
//  CreatBusinessTripApplyVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/12.
//

import UIKit

class CreatBusinessTripApplyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = VCBackGroundColor
        self.title = "新建用章申请"
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
//    MARK:Action
    @objc func saveAction() {
           
    }
    
    @IBAction func creatDetaileAction(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "BusinessTripApply", bundle: nil).instantiateViewController(withIdentifier: "CreatBusinessTripDetailVC")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
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
