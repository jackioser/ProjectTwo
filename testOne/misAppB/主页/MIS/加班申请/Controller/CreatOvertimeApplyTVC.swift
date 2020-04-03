//
//  CreatOvertimeApplyTVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/4.
//

import UIKit

class CreatOvertimeApplyTVC: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var orgTF: UITextField!
    @IBOutlet weak var departTF: UITextField!
    @IBOutlet weak var employeeTF: UITextField!
    @IBOutlet weak var employeeNoLab: UILabel!
    @IBOutlet weak var itemTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var beginTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var overTimeHourTF: UITextField!
    @IBOutlet weak var creatByLab: UILabel!
    @IBOutlet weak var workPlaceTF: UITextField!
    @IBOutlet weak var overTimeContentTV: UITextView!
    @IBOutlet var overtimeBtn: [UIButton]!
    @IBOutlet var adjustRestBtn: [UIButton]!
    
    var detail : OvertimeDetail? {
        didSet {
            orgTF.text = detail?.OrgName
            itemTF.text = detail?.ItemName
            departTF.text = detail?.DeptName
            employeeTF.text = detail?.Employee
            employeeNoLab.text = detail?.EmployeeNo
            dateTF.text = detail?.Date
            beginTimeTF.text = String(detail?.BeginTime?.suffix(8) ?? "")
            endTimeTF.text = String(detail?.EndTime?.suffix(8) ?? "")
            overTimeHourTF.text = String.init(format: "%.1f", detail!.OvertimeHour ?? 0.0)
            creatByLab.text = detail?.CreatedBy
            workPlaceTF.text = detail?.WorkPlace
            overTimeContentTV.text = detail?.OvertimeContent
            selectOvertimeType(tag: Int(detail!.Type)!)
        }
    }
    
    lazy var dateView:ChooseDateView = {
        let view = ChooseDateView.loadFromNib()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil
        detail = OvertimeDetail()
        detail?.CreatedBy = GlobalInstance.shared.user?.FullName
        creatByLab.text = detail?.CreatedBy
        detail?.IsAdjustRest = "F"
    }

//    MARK:UITextViewDelegate, UITextFieldDelegate
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        detail?.OvertimeContent = textView.text
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == overTimeHourTF {
            detail?.OvertimeHour = Double(textField.text!) ?? 0.0
        }
        if textField == workPlaceTF {
            detail?.WorkPlace = textField.text
        }
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 : //选择公司
            let vc = ChooseCompanyVC()
            vc.vcType = .companyType
            vc.selectedBlock = {[weak self] (company) in
                guard let strongSelf = self else { return }
                let com = company as! Dic
                strongSelf.orgTF.text = com.Name
                strongSelf.detail?.OrgName = com.Name
                strongSelf.detail?.OrgId = com.Id
            }
            self.presentBottom(vc, changeScale: false)
        case 1: //选择部门
            let vc = SelectVC.init(nibName: nil, bundle: nil, vcType: .departmentList)
            vc.showText = "请选择部门"
            vc.didSelectDepartment = {[weak self] (depart) in
                guard let strongSelf = self else { return }
                strongSelf.departTF.text = depart.Name
                strongSelf.detail?.DeptId = depart.Id
                strongSelf.detail?.DeptName = depart.Name
                //清空之前选择的员工
                strongSelf.employeeTF.text = nil
                strongSelf.employeeNoLab.text = nil
            }
            presentBottom(vc, changeScale: false)
        case 2: //选择员工
            guard ((detail?.DeptId) != nil) else {
                HUDShowWithText(text: "请先选择部门")
                return
            }
            let vc = ChooseCompanyVC()
            vc.vcType = .deptUserType
            vc.deptId = detail?.DeptId
            vc.selectedBlock = {[weak self] (employee) in
                guard let strongSelf = self else { return }
                let emp = employee as? Employee
                strongSelf.employeeTF.text = emp?.Name
                strongSelf.employeeNoLab.text = emp?.EmployeeNo
                strongSelf.detail?.Employee = emp?.Name
                strongSelf.detail?.EmployeeNo = emp?.EmployeeNo
                strongSelf.detail?.EmployeeId = emp?.Id
            }
            self.presentBottom(vc, changeScale: false)
        case 4: //选择项目
            let vc = ChooseCompanyVC()
            vc.vcType = .projectType
            vc.selectedBlock = {[weak self] (item) in
                guard let strongSelf = self else { return }
                let info = item as? Dic
                strongSelf.itemTF.text = info?.Name
                strongSelf.detail?.ItemsId = info?.Id
                strongSelf.detail?.ItemName = info?.Name
            }
            self.presentBottom(vc, changeScale: false)
        case 6: //加班日期
            dateView.dateType = .date
            dateView.show()
            dateView.dateBack = {[weak self] (date) in
                guard let strongSelf = self else { return }
                strongSelf.dateTF.text = date.replacingOccurrences(of: ":", with: "//")
                strongSelf.detail?.Date = date.replacingOccurrences(of: ":", with: "//")
            }
        case 7: //开始时间
            guard detail?.Date != nil else {
                HUDShowWithText(text: "请先选择日期")
                return
            }
            dateView.dateType = .time
            dateView.show()
            dateView.dateBack = {[weak self] (date) in
                guard let strongSelf = self else { return }
                let dateString = (strongSelf.detail?.Date ?? "") + " " + date
                strongSelf.beginTimeTF.text = dateString
                strongSelf.detail?.BeginTime = dateString
            }
        case 8: //结束时间
            guard detail?.Date != nil else {
                HUDShowWithText(text: "请先选择日期")
                return
            }
            dateView.dateType = .time
            dateView.show()
            dateView.dateBack = {[weak self] (date) in
                guard let strongSelf = self else { return }
                let dateString = (strongSelf.detail?.Date ?? "") + " " + date
                strongSelf.endTimeTF.text = dateString
                strongSelf.detail?.EndTime = dateString
            }
        default:
            break
        }
    }
    
//    MARK:Action
    
    @IBAction func overtimeTypeAction(_ sender: UIButton) {
//        tag : 0 双休加班 1 正常加班 2 节假日加班
        switch sender.tag {
        case 0:
            detail?.Type = "0"
            detail?.TypeName = "双休加班"
        case 1:
            detail?.Type = "1"
            detail?.TypeName = "正常加班"
        case 2:
            detail?.Type = "2"
            detail?.TypeName = "节假日加班"
        default:
            break
        }
        selectOvertimeType(tag: sender.tag)
    }
    
    func selectOvertimeType(tag:Int) {
        for btn in overtimeBtn {
            btn.isSelected = btn.tag == tag
        }
    }
    
    @IBAction func isAdjustRestAction(_ sender: UIButton) {
//        tag : 0 否  1 是
        detail?.IsAdjustRest = sender.tag == 0 ? "F" : "T"
        isAdjustRest(tag: sender.tag)
    }
    
    func isAdjustRest(tag:Int) {
        for btn in adjustRestBtn {
            btn.isSelected = btn.tag == tag
        }
    }

}
