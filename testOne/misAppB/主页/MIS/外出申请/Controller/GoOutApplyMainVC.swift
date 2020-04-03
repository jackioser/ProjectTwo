//
//  GoOutApplyMainVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/1.
//

import UIKit

class GoOutApplyMainVC: NomalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func creatAction() {
        let vc = UIStoryboard.init(name: "GoOutApply", bundle: nil).instantiateViewController(withIdentifier: "CreatGoOutApplyVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func screenAction() {
        
    }
}
