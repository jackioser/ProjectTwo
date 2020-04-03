//
//  BaseTableViewController.swift
//  CheckSwift
//
//  Created by Mac on 20/2/28.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit
//申请的类型
enum VcType: Int {
    case defaultType //新建
    case auditType //审批
    case editType //编辑
    case deleteType //删除和编辑一样
    case checkType //查看
}
class BaseTableViewController: UITableViewController {
    
    lazy var bottomView: UIView = {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: ScreenHeight-84), size: CGSize.init(width: ScreenWidth, height: 84)))
        view.backgroundColor = VCBackGroundColor
        return view
    }()
    
    lazy var bottomButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("保存并提交", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = blueButtonColor
        button.layer.cornerRadius = 5
        button.frame = CGRect.init(origin: CGPoint.init(x: 12, y: 20), size: CGSize.init(width: ScreenWidth-24, height: 44))
        button.addTarget(self, action: #selector(bottomButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var bgView: UIView = {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        bg.backgroundColor = VCBackGroundColor
        return bg
    }()
    lazy var tab: UITableView = {
        let tb = UITableView(frame: self.bgView.bounds, style: .plain)
        return tb
    }()
     var vctype: VcType = .defaultType //详情页类型
     var isEdit: Bool = false // 是否可编辑
    override func viewDidLoad() {
        super.viewDidLoad()
        tab = tableView
        tab.tableFooterView = UIView()
        bottomView.addSubview(bottomButton)
        bgView.addSubview(tab)
        bgView.addSubview(bottomView)
        view = bgView
        tab.frame = CGRect(x: 0, y: topHeight(), width: ScreenWidth, height: ScreenHeight - topHeight() - 84)
        configUI()
    }
    @available(iOS 11, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if view.safeAreaInsets.bottom > 0 {
            bottomView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: ScreenHeight-99), size: CGSize.init(width: ScreenWidth, height: 99))
            tab.frame = CGRect(x: 0, y: topHeight(), width: ScreenWidth, height: ScreenHeight - topHeight() - 99)
        }
    }
    
    //MARK: - action
    @objc func bottomButtonTapped(_ sender: Any) {
        
    }
    
    @objc func save() {
        
    }
    
    @objc func saveAndSubmit() {
        
    }
    
    @objc func deleteData() {
        
    }
    @objc func checkDetail() {
        
    }
   private func configUI() {
    if #available(iOS 11.0, *) {
               tab.contentInsetAdjustmentBehavior = .never
           } else {
               automaticallyAdjustsScrollViewInsets = false
           }
        switch vctype {
        case .defaultType:
            let button = UIButton.init(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.darkText, for: .normal)
            button.setTitle("保存", for: .normal)
            button.addTarget(self, action: #selector(save), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
            bottomButton.setTitle("保存并提交", for: .normal)
        case .editType:
            let button = UIButton.init(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(UIColor.init(red: 240/255.0, green: 84/255.0, blue: 79/255.0, alpha: 1), for: .normal)
            button.setTitle("删除", for: .normal)
            button.addTarget(self, action: #selector(deleteData), for: .touchUpInside)
            let item = UIBarButtonItem.init(customView: button)
            
            let saveb = UIButton.init(type: .system)
            saveb.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            saveb.setTitleColor(DefaultgreyColor, for: .normal)
            saveb.setTitle("保存", for: .normal)
            saveb.addTarget(self, action: #selector(save), for: .touchUpInside)
            let saveItem = UIBarButtonItem.init(customView: saveb)
            navigationItem.rightBarButtonItems = [item, saveItem]
            bottomButton.setTitle("提交", for: .normal)
        case .auditType:
            let left = UIButton.init(type: .system)
            left.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            left.setTitleColor(blueButtonColor, for: .normal)
            left.setTitle("审批明细", for: .normal)
            left.addTarget(self, action: #selector(checkDetail), for: .touchUpInside)
            let leftItem = UIBarButtonItem.init(customView: left)
            if isEdit {
                let button = UIButton.init(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                button.setTitleColor(DefaultgreyColor, for: .normal)
                button.setTitle("保存", for: .normal)
                button.addTarget(self, action: #selector(save), for: .touchUpInside)
                let rightItem = UIBarButtonItem.init(customView: button)
                navigationItem.rightBarButtonItems = [rightItem, leftItem]
            }else{
                navigationItem.rightBarButtonItem = leftItem
            }
            bottomButton.isHidden = true
        case .checkType:
            navigationItem.rightBarButtonItem = nil
            bottomButton.setTitle("审批明细", for: .normal)
        case .deleteType: break
    }
    }

}
