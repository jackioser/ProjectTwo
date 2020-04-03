//
//  UseSealApplyVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/11.
//

import UIKit

class UseSealApplyVC: NomalVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func creatAction() {
        let vc = UIStoryboard.init(name: "UseSealApply", bundle: nil).instantiateViewController(withIdentifier: "CreatUseSealApplyVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func screenAction() {
        
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
