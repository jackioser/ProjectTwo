//
//  CustomViewController.swift
//  misAppB
//
//  Created by XLiu on 2020/2/28.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = VCBackGroundColor
    }
    
    func LeftTitle(title:String) {
        let lab = UILabel.init(frame: CGRect(x: 20, y: 64, width: ScreenWidth - 40, height: 34))
        lab.backgroundColor = VCBackGroundColor
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 28)
        lab.text = title
        self.view.addSubview(lab)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: title, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    
}
