//
//  AnnouncementMainVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/29.
//

import UIKit

class AnnouncementMainVC: NomalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func screenAction() {
        
    }
    
    override func creatAction() {
        let vc = UIStoryboard.init(name: "Announcemen", bundle: nil).instantiateViewController(withIdentifier: "CreatAnnouncementVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
