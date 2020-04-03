//
//  MissionAllowanceVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/1.
//

import UIKit

class MissionAllowanceVC: NomalVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func creatAction() {
        let vc = UIStoryboard.init(name: "MissionAllowance", bundle: nil).instantiateViewController(withIdentifier: "CreatMissionAllowanceVC")
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
