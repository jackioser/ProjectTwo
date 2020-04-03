//
//  LeaveRequestCell.swift
//  CheckSwift
//
//  Created by Mac on 20/2/12.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var tb: UITableView = {
       let tab = UITableView(frame: CGRect(x: 0, y: topHeight(), width: ScreenWidth, height: ScreenHeight-80 - topHeight()), style: .plain)
       tab.tableFooterView = UIView()
       tab.separatorStyle = .none
       tab.backgroundColor = VCBackGroundColor
       return tab
    }()
    lazy var bottomBtn: UIView = {
        let bottomView = UIView(frame: CGRect(x: 0, y: ScreenHeight - 80, width: ScreenWidth, height: 80))
        let btn = UIButton(frame: CGRect(x: 20, y: 18, width: ScreenWidth - 40, height: 44))
        btn.setTitle("保存", for: .normal)
        btn.backgroundColor = blueButtonColor
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(bottomBtnClick), for: .touchUpInside)
        bottomView.addSubview(btn)
        return bottomView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tb.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = .white
        initUI()
    }
    
    func initUI()  {
        view.addSubview(tb)
        view.addSubview(bottomBtn)
    }
    @objc func bottomBtnClick() {
        
    }
    @available(iOS 11, *)
       override func viewSafeAreaInsetsDidChange() {
           super.viewSafeAreaInsetsDidChange()
           if view.safeAreaInsets.bottom > 0 {
               bottomBtn.frame = CGRect.init(origin: CGPoint.init(x: 0, y: ScreenHeight-99), size: CGSize.init(width: ScreenWidth, height: 99))
           }
       }
    
}




extension BaseViewController {
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return.lightContent
//    }
    
}
