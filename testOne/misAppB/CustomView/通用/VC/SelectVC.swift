//
//  SelectVC.swift
//  misAppA
//
//  Created by 苏奎 on 2020/2/21.
//

import Foundation
import UIKit

class SelectVC: PresentBottomVC, UITableViewDataSource, UITableViewDelegate {
    
    enum SelectVCType {
        case departmentList //有权限的部门
        case approvalMan //选择审批人
    }
    var didSelectDepartment: ((DicP)->())? //返回部门
    var didSelectEmployee: ((Dic)->())? // 返回部门下的员工
    
    var dicpArray: [DicP?]? //部门
    var dataDicpArray: [DicP?]? //用于展示的数据源，在用户展开关闭某个部门的时候，会相应增加或减少
    
//    var employeeArray: [Employee?]? //根据部门选择员工
//    var departmentId: String? //根据部门获取员工的时候传入部门id
    
    var approvalArray: [DeptUser?]? //审批人
    var dataApprovalArray: [DeptUser?]? //用于展示审批人的数据源，在用户展开关闭某个部门的时候，会相应增加或减少
    
    var showText: String?
    var type: SelectVCType = .departmentList
    var urlString: String = GetDictionary

    
    convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, vcType: SelectVCType) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.type = vcType

        switch vcType {
            case .departmentList:
                urlString = GetDept
            case .approvalMan:
                urlString = GetDeptUser
        }
    }
    //设置弹出控制器的高度
       override var controllerHeight: CGFloat {
           return backgroundViewTopSpace
       }
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 64), size: CGSize.init(width: ScreenWidth, height: backgroundViewTopSpace-64)), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView.init()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        table.register(UINib.init(nibName: "SelectVCCell", bundle: nil), forCellReuseIdentifier: "SelectVCCell")
        table.register(UINib.init(nibName: "SelectApprovalCell", bundle: nil), forCellReuseIdentifier: "SelectApprovalCell")
        return table
    }()
    
    //backgroundView和屏幕高度的差别
    lazy var backgroundViewTopSpace: CGFloat = ScreenHeight-120
//    lazy var backgroundView: UIView = {
//        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: ScreenWidth, height: backgroundViewTopSpace)))
//        view.backgroundColor = .clear
//
//        let layer = CAShapeLayer.init()
//        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 64), byRoundingCorners: [.topLeft, . topRight], cornerRadii: CGSize.init(width: 5, height: 5))
//        layer.path = path.cgPath
//        layer.fillColor = UIColor.white.cgColor
//        view.layer.addSublayer(layer)
//
//        let button = UIButton.init(type: .custom)
//        button.setImage(UIImage.init(named: "navLeftXX"), for: .normal)
//        button.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 7), size: CGSize.init(width: 50, height: 50))
//        view.addSubview(button)
//        button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
//
//        let label = UILabel.init()
//        label.center = CGPoint.init(x: ScreenWidth/2, y: 32)
//        label.bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 150, height: 20))
//        label.textAlignment = .center
//        label.textColor = .darkText
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.text = showText ?? "请选择"
//        view.addSubview(label)
//
//        let line = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 63), size: CGSize.init(width: ScreenWidth, height: 1)))
//        line.backgroundColor = VCBackGroundColor
//        view.addSubview(line)
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = VCBackGroundColor
        tableView.backgroundColor = VCBackGroundColor
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp_bottomMargin).offset(10)
        }
        
        titleLab.text = showText
        searchBar.placeholder = "请输入关键字"
        rightBtn.isHidden = true
        
        HUDShow()
        loadData()
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return type == .approvalMan ? (dataApprovalArray?.count ?? 0) : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
            case .departmentList:
                return dataDicpArray?.count ?? 0

            case .approvalMan:
                if let dept = dataApprovalArray?[section] {
                    return dept.unfold ? (dept.Employee?.count ?? 0)+1 : 1
                }
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
            case .departmentList:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVCCell", for: indexPath) as! SelectVCCell
                if let dicp = dataDicpArray?[indexPath.row] {
                    cell.titleLabel?.text = dicp.Name
                    cell.leading.constant = CGFloat(15 + dicp.indentationLevel*37)
                    cell.unfold = {
                        [weak self] in
                        guard let strongSelf = self, let id = dicp.Id else { return }
                        let array = strongSelf.getPArray(id: id)
                        //调用tableView的indexPathForCell方法，获取当前点击cell的row，如果直接使用indexPath的row，则是在闭包被持有前的row
                        if let newIndexPath = strongSelf.tableView.indexPath(for: $1), array.count > 0 {
                            let row = newIndexPath.row
                            var indexsArray = [IndexPath]()
                            for i in row+1...row+array.count {
                                indexsArray.append(IndexPath.init(row: i, section: 0))
                            }
                            if $0 {
                                strongSelf.dataDicpArray?.removeSubrange(row+1...row+array.count)
                                dicp.unfold = false
                                if #available(iOS 11, *) {
                                    strongSelf.tableView.performBatchUpdates({
                                        strongSelf.tableView.reloadRows(at: [newIndexPath], with: .fade)
                                        strongSelf.tableView.deleteRows(at: indexsArray, with: .fade)
                                    }, completion: nil)
                                }else {
                                    strongSelf.tableView.beginUpdates()
                                    strongSelf.tableView.reloadRows(at: [newIndexPath], with: .fade)
                                    strongSelf.tableView.deleteRows(at: indexsArray, with: .fade)
                                    strongSelf.tableView.endUpdates()
                                }
                            }else {
                                dicp.unfold = true
                                strongSelf.dataDicpArray?.insert(contentsOf: array, at: row+1)
                                if #available(iOS 11, *) {
                                    strongSelf.tableView.performBatchUpdates({
                                        strongSelf.tableView.reloadRows(at: [newIndexPath], with: .fade)
                                        strongSelf.tableView.insertRows(at: indexsArray, with: .fade)
                                    }, completion: nil)
                                }else {
                                    strongSelf.tableView.beginUpdates()
                                    strongSelf.tableView.reloadRows(at: [newIndexPath], with: .fade)
                                    strongSelf.tableView.insertRows(at: indexsArray, with: .fade)
                                    strongSelf.tableView.endUpdates()
                                }
                            }
                        }
                    }
                    cell.button.isHidden = !dicp.hasChild
                    cell.button.isSelected = !dicp.unfold
//                    cell.bottomLine.isHidden = true
//                    if indexPath.row+1 < dataDicpArray!.count, let nextDicp = dataDicpArray![indexPath.row+1] {
//                        cell.bottomLine.isHidden = nextDicp.PId != dicp.PId
//                    }else {
//                        cell.bottomLine.isHidden = true
//                    }
                }
                return cell
            case .approvalMan:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectApprovalCell", for: indexPath) as! SelectApprovalCell
                if let dept = dataApprovalArray?[indexPath.section] {
                    if indexPath.row == 0 {
                        cell.titleLabel?.text = dept.Dept
                        cell.leading.constant = CGFloat(15 + dept.indentationLevel*35)
                        cell.unfold = {
                            [weak self] in
                            guard let strongSelf = self, let id = dept.DeptId else { return }
                            let array = strongSelf.getApprovalArray(id: id)
                            if let newIndexPath = strongSelf.tableView.indexPath(for: $1) {
                                let section = newIndexPath.section
                                var indexsArray = [IndexPath]()
                                var indexSet: IndexSet?
                                if !array.isEmpty {
                                    indexSet = IndexSet.init(integersIn: section+1...section+array.count)
                                }
                                if let emp = dept.Employee {
                                    for i in 1...emp.count {
                                        indexsArray.append(IndexPath.init(row: i, section: section))
                                    }
                                }
                                if $0 {
                                    //关闭
                                    dept.unfold = false
                                    if !array.isEmpty {
                                        strongSelf.dataApprovalArray?.removeSubrange(section+1...section+array.count)
                                    }
                                    if #available(iOS 11, *) {
                                        strongSelf.tableView.performBatchUpdates({
                                            strongSelf.tableView.deleteRows(at: indexsArray, with: .fade)
                                            if !array.isEmpty {
                                                strongSelf.tableView.deleteSections(indexSet!, with: .fade)
                                            }
                                        }, completion: nil)
                                    }else {
                                        strongSelf.tableView.beginUpdates()
                                        strongSelf.tableView.deleteRows(at: indexsArray, with: .fade)
                                        if !array.isEmpty {
                                            strongSelf.tableView.deleteSections(indexSet!, with: .fade)
                                        }
                                        strongSelf.tableView.endUpdates()
                                    }
                                }else {
                                    //展开
                                    dept.unfold = true
                                    strongSelf.dataApprovalArray?.insert(contentsOf: array, at: section+1)
                                    if #available(iOS 11, *) {
                                        strongSelf.tableView.performBatchUpdates({
                                            strongSelf.tableView.insertRows(at: indexsArray, with: .fade)
                                            if let set = indexSet {
                                                strongSelf.tableView.insertSections(set, with: .fade)
                                            }
                                        }, completion: nil)
                                    }else {
                                        strongSelf.tableView.beginUpdates()
                                        strongSelf.tableView.insertRows(at: indexsArray, with: .fade)
                                        if let set = indexSet {
                                            strongSelf.tableView.insertSections(set, with: .fade)
                                        }
                                        strongSelf.tableView.endUpdates()
                                    }
                                }
                            }
                        }
                        cell.button.isHidden = !dept.hasChild
                        cell.button.isSelected = !dept.unfold
                        if indexPath.section+1 < dataApprovalArray!.count, let nextDept = dataApprovalArray![indexPath.section+1] {
                            cell.bottomLine.isHidden = nextDept.PId != dept.PId
                        }else {
                            cell.bottomLine.isHidden = true
                        }
                    }else {
                        let staff = dept.Employee?[indexPath.row-1]
                        cell.titleLabel.text = staff?.Name
                        cell.button.isHidden = true
                        cell.leading.constant = CGFloat(15 + (dept.indentationLevel+1)*35)
                        if indexPath.section+1 < dataApprovalArray!.count, let nextDept = dataApprovalArray![indexPath.section+1] {
                            cell.bottomLine.isHidden = nextDept.PId != dept.DeptId
                        }else {
                            cell.bottomLine.isHidden = true
                        }
                    }
            }
            return cell
        }
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch type {
            case .departmentList:
                if let dicp = dataDicpArray?[indexPath.row], didSelectDepartment != nil {
                    didSelectDepartment!(dicp)
                }
            case .approvalMan:
                let deptUser = dataApprovalArray?[indexPath.section]?.Employee
                let emloy = deptUser?[indexPath.row]
                if let employee = emloy, didSelectEmployee != nil {
                    didSelectEmployee!(employee)
                }
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - action
    
    @objc func back(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - private
    
    func loadData() {
        let param: [String: Any]? = nil
        AFNetWorkingTool.shared.post(urlString: urlString, parampeters: param, success: { [weak self] (responseInfo) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.HUDHide()
            if responseInfo.error == 0 {
                switch strongSelf.type {
                    case .departmentList:
                        if let array = Array<DicP>.deserialize(from: responseInfo.items as? [Any]), array.count > 0 {
                            strongSelf.dicpArray = strongSelf.sortPArray(id: "", array: array)
                            var final = [DicP?]()
                            if let dicp = strongSelf.dicpArray?.first, let id = dicp?.Id {
                                //默认情况下，显示根部门和第一层级的部门，即只展开第一级部门
                                dicp?.unfold = true
                                final.append(dicp)
                                final.append(contentsOf: strongSelf.getPArray(id: id))
                            }
                            strongSelf.dataDicpArray = final
                            strongSelf.tableView.reloadData()
                        }
                    case .approvalMan:
                        if let array = Array<DeptUser>.deserialize(from: responseInfo.items as? [Any]) {
                            strongSelf.approvalArray = strongSelf.sortApprovalArray(id: "", array: array)
                            var final = [DeptUser?]()
                            if let dicp = strongSelf.approvalArray?.first, let id = dicp?.DeptId {
                                //默认情况下，显示根部门和第一层级的部门，即只展开第一级部门
                                dicp?.unfold = true
                                final.append(dicp)
                                final.append(contentsOf: strongSelf.getApprovalArray(id: id))
                            }
                            strongSelf.dataApprovalArray = final
                            strongSelf.tableView.reloadData()
                        }
                }
            }else {
                strongSelf.HUDShowWithText(text: responseInfo.msg)
            }
        }) { [weak self] (error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
    
    //通过递归的方式调整部门集合
    func sortPArray(id: String?, indentationLevel: Int = 0, array: [DicP?]) -> [DicP?] {
        var result = [DicP?]()
        for p in array {
            if let dic = p, let pid = dic.PId, pid == id {
                dic.indentationLevel = indentationLevel
                result.append(dic)
                if let child = dic.Id {
                    let returnArray = sortPArray(id: child, indentationLevel: indentationLevel+1, array: array)
                    dic.hasChild = returnArray.count > 0
                    result.append(contentsOf: array)
                }
            }
        }
        return result
    }
    
    func getPArray(id: String) -> [DicP?] {
        var result = [DicP?]()
        for p in dicpArray! {
            if let dic = p, let pid = dic.PId, pid == id {
                if dic.unfold, let dicId = dic.Id {
                    //如果该部门已展开，也要加上该部门的子部门，在数据源中删除
                    result.append(contentsOf: getPArray(id: dicId))
                    dic.unfold = false
                }
                result.append(dic)
            }
        }
        return result
    }
    
    func sortApprovalArray(id: String?, indentationLevel: Int = 0, array: [DeptUser?]) -> [DeptUser?] {
        var result = [DeptUser?]()
        for p in array {
            if let dic = p, let pid = dic.PId, pid == id {
                dic.indentationLevel = indentationLevel
                result.append(dic)
                if let child = dic.DeptId {
                    let returnArray = sortApprovalArray(id: child, indentationLevel: indentationLevel+1, array: array)
                    dic.hasChild = (returnArray.count > 0 || (dic.Employee?.count ?? 0 > 0) )
                    result.append(contentsOf: returnArray)
                }
            }
        }
        return result
    }
    
    func getApprovalArray(id: String) -> [DeptUser?] {
        var result = [DeptUser?]()
        for p in approvalArray! {
            if let dic = p, let pid = dic.PId, pid == id {
                if dic.unfold, let dicId = dic.DeptId {
                    //如果该部门已展开，也要加上该部门的子部门，在数据源中删除
                    result.append(contentsOf: getApprovalArray(id: dicId))
                    dic.unfold = false
                }
                result.append(dic)
            }
        }
        return result
    }

}



