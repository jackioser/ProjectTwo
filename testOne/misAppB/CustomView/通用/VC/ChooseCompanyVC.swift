//
//  ChooseCompanyVC.swift
//  misAppB
//
//  Created by jack on 2020/3/13.
//

import UIKit
enum ChooseVCType: String {
    case companyType = "对应公司"//公司
    case deptUserType = "请选择员工"//部门员工（包含子部门的）
    case leaveType = "请假类型"//请假类型
    case projectType = "请选择项目"//项目
}
class ChooseCompanyVC: PresentBottomVC {

    
    //返回
    var selectedBlock: ((_ selectCompany: Any) -> ())?
    var vcType: ChooseVCType?
    var deptId: String! // 选择员工时传入(非空)
    
    //privite
    var table: UITableView!
    var originalData: Array<Any>? //原始数据
    var searchReultSource: Array<Any>? //模糊查询的数据
    //设置弹出控制器的高度
    override var controllerHeight: CGFloat {
        return ScreenHeight-120
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLab.text = vcType?.rawValue
        configUI()
        switch vcType {
        case .companyType:
            getOrg()
        case .deptUserType:
            getSingleDeptUser()
        case .leaveType:
            getLeaveType()
        case .projectType:
            getItems()
        default:
            break
        }
        
    }
    
    func configUI() {
        view.backgroundColor = VCBackGroundColor
        searchBar.placeholder = "请输入关键字"
        rightBtn.isHidden = true
        table = UITableView(frame: CGRect.zero, style: .plain)
        table.tableFooterView = UIView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = VCBackGroundColor
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp_bottomMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func getOrg() {
        loadDic()
    }
    func getSingleDeptUser() {
        guard let depId = deptId else {
            HUDShowWithText(text: "先选择所属部门")
            return
        }
        HUDShow()
        let dic: [String: String] = ["DeptId": depId]
        AFNetWorkingTool.shared.post(urlString: GetSingleDeptUser, parampeters: dic, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            guard let model = Array<Employee>.deserialize(from: ResponseInfo.items as? [Any])  else {return}
            strongSelf.originalData = model as? Array<Employee>
            strongSelf.searchReultSource = strongSelf.originalData
            strongSelf.table.reloadData()
            
        }) {[weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
    func getLeaveType() {
        let type = ["事假","病假","婚假","产假","丧假","其他","年假","调休"]
        let leaveType = type.enumerated().map { (arg) -> Dic in
            let (index, element) = arg
            let dic = Dic()
            dic.Id = index > 3 ? "\(index + 1)" : "\(index)" //请假type缺4
            dic.Name = element
            return dic
       }
        originalData = leaveType
        searchReultSource = leaveType
        
    }
    func getItems() {
        loadDic()
    }
    func loadDic(key: String = "") {
        var url = ""
        var dic = [String: Any]()
        
        switch vcType {
        case .companyType:
            url = GetOrg
        default:
            url = GetItems
            dic = ["Name": key]
        }
        HUDShow()
        AFNetWorkingTool.shared.post(urlString: url, parampeters: dic, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            guard let model = Array<Dic>.deserialize(from: ResponseInfo.items as? [Any])  else {return}
            strongSelf.originalData = model as? Array<Dic>
            strongSelf.searchReultSource = strongSelf.originalData
            strongSelf.table.reloadData()
            
        }) {[weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
    override  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchReultSource = originalData
        }else{
            //模糊查询
            searchReultSource = self.originalData?.filter({ (item) -> Bool in
                switch vcType {
                case .companyType, .leaveType:
                    return (item as! Dic).Name?.range(of: searchText, options: .caseInsensitive) != nil
                case .deptUserType:
                    return (item as! Employee).Name?.range(of: searchText, options: .caseInsensitive) != nil
                default:
                    return false
                }
            })
            if vcType == .projectType {
                loadDic(key: searchText)
            }
        }
        table.reloadData()
    }
}

extension ChooseCompanyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchReultSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell!.backgroundColor = VCBackGroundColor
            cell!.textLabel?.font = GlobalFont
        }
        cell!.textLabel?.textColor = DefaultTextColor
        switch vcType {
        case .companyType, .leaveType, .projectType:
            cell!.textLabel?.text = (searchReultSource?[indexPath.row] as! Dic).Name
        case .deptUserType:
            cell!.textLabel?.text = (searchReultSource?[indexPath.row] as! Employee).Name
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.textLabel?.textColor = blueButtonColor
        
        if selectedBlock != nil {
            selectedBlock!(searchReultSource![indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.textLabel?.textColor = DefaultTextColor
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
