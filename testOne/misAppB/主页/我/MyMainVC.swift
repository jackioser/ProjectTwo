//
//  MyMainVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/26.
//

import UIKit

class MyMainVC: CustomViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "加班申请"
        case 1:
            cell.textLabel?.text = "公告发布"
        case 2:
            cell.textLabel?.text = "用车申请"
        case 3:
            cell.textLabel?.text = "外出申请"
        case 4:
            cell.textLabel?.text = "出差补助"
        case 5:
            cell.textLabel?.text = "专项附加扣除代办"
        case 6:
            cell.textLabel?.text = "离职申请"
        case 7:
            cell.textLabel?.text = "用章申请"
        case 8:
            cell.textLabel?.text = "出差申请"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc:NomalVC? = nil
        
        switch indexPath.row {
        case 0:
            vc = OvertimeApplyVC()
            vc!.type = .OvertimeApply
        case 1:
            vc = AnnouncementMainVC()
            vc!.type = .Announcement
        case 2:
            vc = CarApplyVC()
            vc!.type = .CarApply
        case 3:
            vc = GoOutApplyMainVC()
            vc!.type = .GoOutApply
        case 4:
            vc = MissionAllowanceVC()
            vc!.type = .MissionAllowance
        case 5:
            vc = SpecialCommissionVC()
            vc!.type = .SpecialCommission
        case 6:
            vc = ResignApplicationVC()
            vc!.type = .ResignApplication
        case 7:
            vc = UseSealApplyVC()
            vc?.type = .UseSealApply
        case 8:
            vc = BusinessTripApplyVC()
            vc?.type = .BusinessTripApply
        default:
            return
        }
        vc!.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    lazy var tableView:UITableView = {
        let view = UITableView.init()
        view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        view.tableFooterView = .init()
        view.tableHeaderView = .init()
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 64
        return view
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = VCBackGroundColor
        self.view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "注销", style: .plain, target: self, action: #selector(logOutAction))
    }

//    MARK:Action
    
    @objc func logOutAction() {
        logout()
    }
    
//    MARK:NetWorking
    
    func logout() {
        self.HUDShow()
        AFNetWorkingTool.shared.post(urlString: apiLogout, parampeters:[String:Any](), success: { [weak self] (responseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if responseInfo.error == 0 {
                let vc = LoginMainVC()
                vc.modalPresentationStyle = .fullScreen
                strongSelf.present(vc, animated: true, completion: nil)
            } else {
                strongSelf.HUDShowWithText(text: responseInfo.msg)
            }
        }) { [weak self] (Error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
        }
    }

}
