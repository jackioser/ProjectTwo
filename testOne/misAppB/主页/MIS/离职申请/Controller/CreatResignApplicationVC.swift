//
//  CreatResignApplicationVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/4.
//

import UIKit

class CreatResignApplicationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
            
    func initView() {
        self.title = "新建离职申请"
        self.view.backgroundColor = VCBackGroundColor
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func saveAction() {
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
