//
//  CreatMissionAllowanceVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/1.
//

import UIKit

class CreatMissionAllowanceVC: UIViewController {

    var details = [Int](repeating: 1, count: 0)
    var tableVC:CreatMissionAllowanceTVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
            initView()
    }
        
    func initView() {
        self.title = "新建出差补助"
        self.view.backgroundColor = VCBackGroundColor
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func saveAction() {
    }
    
    @IBAction func creatDetailAction(_ sender: UIButton) {
//        details.append(1)
//        tableVC?.cells = details

        let vc = UIStoryboard.init(name: "MissionAllowance", bundle: nil).instantiateViewController(withIdentifier: "CreatMissionDetailVC")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func saveAndCommitAction(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreatMissionAllowanceTVC {
            tableVC = vc
        }
    }

}
