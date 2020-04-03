//
//  WPProjectManageVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/28.
//

import UIKit

class WPProjectManageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView : UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableView.Style.plain)
        view.backgroundColor = .clear
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.delegate = self
        view.dataSource = self
        view.register(UINib(nibName: "ProjectManageCell", bundle: nil), forCellReuseIdentifier: "ProjectManageCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.view.backgroundColor = VCBackGroundColor;
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ProjectManageCell = tableView.dequeueReusableCell(withIdentifier: "ProjectManageCell") as! ProjectManageCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.titleLab.text = "项目周报管理"
            } else {
                cell.titleLab.text = "项目月报管理"
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.titleLab.text = "项目开发"
            case 1:
                cell.titleLab.text = "人力资源查询"
            case 2:
                cell.titleLab.text = "项目文档管理"
            case 3:
                cell.titleLab.text = "项目情况查询"
            case 4:
                cell.titleLab.text = "项目模块测试"
            default:
                cell.titleLab.text = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
            } else {
                
            }
        } else {
            switch indexPath.row {
            case 0:
                ""
            case 1:
                ""
            case 2:
                ""
            case 3:
                ""
            case 4:
                ""
            default:
                ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 60))
        view.backgroundColor = VCBackGroundColor
        let lab = UILabel(frame: CGRect(x: 20, y: 20, width: 100, height: 40))
        lab.textColor = .black
        lab.font.withSize(16)
        lab.text = section == 0 ? "进度管理" : "项目开发"
        view.addSubview(lab)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
