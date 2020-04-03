//
//  CreatMissionDetailVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/2.
//

import UIKit

class CreatMissionDetailVC: UIViewController {

    var table : CreatMissionAllowanceTVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func creatAction(_ sender: UIButton) {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreatMissionAllowanceTVC {
            table = vc
        }
    }

}
