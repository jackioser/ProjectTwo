//
//  CreatAnnouncementVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/29.
//

import UIKit

class CreatAnnouncementVC: UIViewController {
    
    var files = [Int](repeating: 1, count: 0)
    var tableVC : CreatAnnouncementTVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.title = "新建公告"
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
    
    @IBAction func uploadFeildAction(_ sender: UIButton) {
        files.append(1)
        tableVC?.cells = files
    }
    
    @IBAction func saveAndCommitAction(_ sender: UIButton) {
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreatAnnouncementTVC {
            tableVC = vc
        }
    }

}
