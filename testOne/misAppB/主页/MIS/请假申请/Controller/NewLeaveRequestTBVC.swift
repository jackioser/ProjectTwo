//
//  NewLeaveRequestTBVC.swift
//  CheckSwift
//
//  Created by Mac on 20/2/25.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class NewLeaveRequestTBVC: BaseTableViewController {

    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var leaveType: UITextField!
    @IBOutlet weak var leaveExplain: UILabel!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var beginTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var leaveReason: UITextView!
    @IBOutlet weak var Applicant: UILabel!
    @IBOutlet weak var ApplicationTime: UILabel!
    
    @IBOutlet weak var leaveExplainRightCon: NSLayoutConstraint!
    
    var saveSuccessBlock: (() -> ())? //处理成功回调
    var idStr: String?

    var leaveChooseType: String = "0"  { //当前选择的请假类型
        didSet{
            if detail?.LeaveCancel?.count ?? 0 > 0 {
                sectionTitle2.isHidden = true
                addBtn.frame = CGRect(x: 30, y: 60, width: 100, height: 40)
                arrow.isHidden = false
                hasArrow = true
            }else {
                sectionTitle2.isHidden = false
                addBtn.frame = CGRect(x: 30, y: 100, width: 100, height: 40)
                arrow.isHidden = true
                hasArrow = false
            }
            tab.reloadData()
        }
    }
    var selectDept: DicP?//当前选择的部门
    var dynaUser: String?//审批人
    var auditType: AuditType? //审批同意、委派等
    var auditText: String? //审批意见
    lazy var sectionTitle1 = UILabel().then {
         $0.text = "冲抵加班记录"
         $0.textColor = DefaultTextColor
         $0.frame = CGRect(x: 30, y: 20, width: 0, height: 0)
         $0.sizeToFit()
       
    }
    lazy var arrow = UIButton().then {(arrow1) in
        arrow1.frame = CGRect(x: ScreenWidth - 45, y: 20, width: 25, height: 25)
        arrow1.setImage(UIImage(named: "bottomArrow"), for: .normal)
        arrow1.setImage(UIImage(named: "topArrow-1"), for: .selected)
        arrow1.isUserInteractionEnabled = false
    }
    lazy var sectionTitle2 = UILabel().then {
         $0.text = "暂无冲抵加班记录"
         $0.textColor = DefaultgreyColor
         $0.frame = CGRect(x: 30, y: 60, width: 0, height: 0)
         $0.sizeToFit()
       
    }
    lazy var addBtn = UIButton().then {
        $0.setTitleColor(blueButtonColor, for: .normal)
        $0.setTitle("添加", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
        $0.frame = CGRect(x: 30, y: 100, width: 100, height: 40)
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = blueButtonColor.cgColor
        $0.addTarget(self, action: #selector(addOvertimeRecord), for: .touchUpInside)
    }
    
    lazy var sectionView = UIView().then {
        $0.backgroundColor = VCBackGroundColor
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowChange)))
        $0.addSubview(arrow)
        $0.addSubview(self.sectionTitle1)
        $0.addSubview(self.sectionTitle2)
        $0.addSubview(self.addBtn)
    }
    lazy var plistDic: [String: String] = {
        //读取plist数据
        let diaryList:String = Bundle.main.path(forResource: "LeaveReason", ofType:"plist")!
        let dic: [String : String] = NSDictionary.init(contentsOfFile: diaryList) as! [String : String]
        return dic
    }()
    var addNewModel = LeaveDetail() //新建时选择的数据
    private var hasArrow = false    //secton2 有箭头
    var detail: LeaveDetail? {
        didSet{
            guard let model = detail else {return}
            company.text = model.OrgName
            leaveType.text = model.TypeName
            department.text = model.DeptName
            userName.text = model.Employee
            number.text = model.EmployeeNo
            beginTime.text = model.BeginTime
            endTime.text = model.EndTime
            duration.text = model.LeaveDates
            leaveReason.text = model.Remark
            Applicant.text = model.CreatedBy
            ApplicationTime.text = model.CreatedOn
            
            leaveChooseType = "\(model.type?.rawValue ?? 0)"
            leaveExplain.text = getLeaveReason(key: leaveChooseType)
           
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tab.register(UINib(nibName: "OvertimeRecordsCell", bundle: nil), forCellReuseIdentifier: "OvertimeRecordsCell")
        tab.backgroundColor = VCBackGroundColor
        tab.estimatedRowHeight = 30
        
        Applicant.text = GlobalInstance.shared.user?.FullName
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        ApplicationTime.text = formater.string(from: Date())
        if (idStr != nil) {
            getLeaveDetail()
        }
        switch vctype {
        case .auditType:
            title = "请假申请审批"
            let bottom = ApprovalBottomVIew.loadFromNib()
            view.addSubview(bottom)
            bottom.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(160)
            }
            tab.snp.makeConstraints { (make) in
                make.top.equalTo(topHeight())
                make.left.right.equalToSuperview()
                make.bottom.equalTo(bottom.snp_topMargin).offset(-10)
            }
            bottom.auditTypeBlock = {[weak self] type, text in
                guard let strongSelf = self else { return }
                strongSelf.auditType = type
                strongSelf.auditText = text
                switch type {
                case .agree:
                    strongSelf.audit()
                case .disagree:
                    strongSelf.audit()
                case .termination:
                    strongSelf.audit()
                case .designate:
                    let vc = UIStoryboard.init(name: "LeaveRequestSB", bundle: nil).instantiateViewController(withIdentifier: "DesignateVC") as! DesignateVC
                    vc.idStr = strongSelf.idStr
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                default: break
                }
            }
        case .checkType:
            leaveReason.isUserInteractionEnabled = false
        default:
            break
        }
    }
    @IBAction func detailBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        leaveExplain.numberOfLines = sender.isSelected ? 0 : 1
        leaveExplainRightCon.constant = sender.isSelected ? 0 : 80
        tab.beginUpdates()
        tab.endUpdates()
    }
    //旋转箭头
    @objc func arrowChange() {
        if hasArrow {
            arrow.isSelected = !arrow.isSelected
            tab.reloadSections(IndexSet(integer: 1), with: .fade)
            if arrow.isSelected {
                guard let row = detail?.LeaveCancel?.count else {return}
                if row > 0  {
                    tab.scrollToRow(at: IndexPath(row: row - 1, section: 1), at: .bottom, animated: true)
                }
            }
        }
    }
    //添加加班记录
    @objc func addOvertimeRecord() {
        if let eeId = addNewModel.EmployeeId,let time = addNewModel.BeginTime {
            let vc = SelectiveAdjustmentVC(employeeId: eeId, beginTime: time, leaveId: idStr)
                   navigationController?.pushViewController(vc, animated: true)
        }else{
            HUDShowWithText(text: "员工编号和开始时间不能为空")
        }
       
    }
    //nav保存
    override func save() {
        saveEditLeave(isSubmit: false)
    }
    //bottom保存并提交
    override func bottomButtonTapped(_ sender: Any) {
        switch vctype {
        case .editType:
            newSubmit()
        case .checkType:
            getCheckDetail()
        default:
            saveEditLeave(isSubmit: true)
        }
    }
    //check
    override func checkDetail() {
        getCheckDetail()
    }
    //删除
    override func deleteData() {
        guard let id = idStr else {return}
//        guard let pId = pId else {return}
        HUDShow()
        let dic = ["ApplyTable": 0, "Table": "", "Ids": [id], "PId": ""] as [String : Any]
        AFNetWorkingTool.shared.post(urlString: Delete, parampeters: dic, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: ResponseInfo.msg)
            
        }) {[weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
//MARK:- 详情
    func getLeaveDetail() {
        HUDShow()
        let dic = ["Id" : idStr] as? [String : String]
        AFNetWorkingTool.shared.post(urlString: GetLeaveDetail, parampeters: dic , success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if ResponseInfo.error == 0 {
                guard let model = LeaveDetail.deserialize(from: ResponseInfo.items as? [String:Any]) else {return}
                strongSelf.detail = model
                strongSelf.addNewModel = model
            }else{
                strongSelf.HUDShowWithText(text: ResponseInfo.msg)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
//MARK:- 保存
    func saveEditLeave(isSubmit: Bool) {
        HUDShow()
        let cancelArr = addNewModel.LeaveCancel?.compactMap { (model: LeaveCancel) -> Dictionary<String, Any> in
            let dic = ["OverTimeId": model.OverTimeId as Any, "Hour": model.OverTimeHour as Any]
            return dic
        }
        let dic: [String:Any] = ["Id": idStr ?? "",
                                "OrgId": addNewModel.OrgId ?? "",
                                "DeptId": addNewModel.DeptId ?? "",
                                "EmployeeId": addNewModel.EmployeeId ?? "",
                                "EmployeeNo": addNewModel.EmployeeNo ?? "",
                                "Type": addNewModel.type?.rawValue ?? 0,
                                "BeginTime": addNewModel.BeginTime ?? "",
                                "EndTime": addNewModel.EndTime ?? "",
                                "Remark": leaveReason.text ?? "",
                                "LeaveCancel": cancelArr as Any,
                                "version": ""]
        AFNetWorkingTool.shared.post(urlString: EditLeave, parampeters: dic , success: { [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if model.error == 0 {
                strongSelf.HUDShowWithText(text: "成功")
                if isSubmit {
                    strongSelf.idStr = model.items as? String
                    strongSelf.newSubmit()
                }
                if strongSelf.saveSuccessBlock != nil {
                    strongSelf.saveSuccessBlock!()
                }
            }else{
                strongSelf.HUDShowWithText(text: model.msg)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
//MARK:- 提交
    func newSubmit() {
        HUDShow()
        let dic: [String: Any] = ["Type": 0,
                                "RecordId": idStr ?? "",
                                "DynaUser": dynaUser as Any]
        AFNetWorkingTool.shared.post(urlString: NewSubmit, parampeters: dic , success: { [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if model.error == 0 {
                strongSelf.HUDShowWithText(text: "成功")
                if strongSelf.saveSuccessBlock != nil {
                    strongSelf.saveSuccessBlock!()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }else if model.error == 1{
                strongSelf.HUDShowWithText(text: model.msg)
            }else if model.error == 2{//error返回：0-成功，1-失败，2-要先选择动态执行人
                let alertController = UIAlertController(title: "",message: "请选择下一步审批人", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "好", style: .default, handler: {action in
                    strongSelf.chooseApproval(isDesignate: false)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                strongSelf.present(alertController, animated: true, completion: nil)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
//MARK:- 审批
    func audit() {
        HUDShow()
        let dic: [String: Any] = ["Type": 0,
                                "RecordId": idStr ?? "",
                                "DynaUser": "",
                                "Content": "",
                                "AuditType": auditType?.rawValue ?? 0,
                                "WFDescription": auditText ?? "",
                                "ToUser": "",
                                "WFMemo": ""
                                ]
        AFNetWorkingTool.shared.post(urlString: Audit, parampeters: dic , success: { [weak self] (model) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if model.error == 0 {
                strongSelf.HUDShowWithText(text: "成功")
                if strongSelf.saveSuccessBlock != nil {
                    strongSelf.saveSuccessBlock!()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }else if model.error == 2{
                strongSelf.HUDShowWithText(text: model.msg + "要先选择动态执行人")
            }else if model.error == 3{
                strongSelf.HUDShowWithText(text: model.msg + "Content必须有值")
            }else{
                strongSelf.HUDShowWithText(text: model.msg)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
}
//MARK: - UITableViewDataSource
extension NewLeaveRequestTBVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return leaveChooseType == "8" ? super.numberOfSections(in: tableView) : 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return arrow.isSelected ? (detail?.LeaveCancel?.count ?? 0) : 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OvertimeRecordsCell") as! OvertimeRecordsCell
            cell.overtime = detail?.LeaveCancel?[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = VCBackGroundColor
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if vctype == .checkType || !isEdit{
                return
            }
            let vc = ChooseCompanyVC()
                if indexPath.row == 0 {
                    vc.vcType = .companyType
                    vc.selectedBlock = { [weak self] (company) in
                        let com = company as! Dic
                        self?.company.text = com.Name
                        self?.addNewModel.OrgId = com.Id
                    }
                    self.presentBottom(vc, changeScale: false)
                }else if indexPath.row == 1{
                let vc = SelectVC.init(nibName: nil, bundle: nil, vcType: .departmentList)
                vc.showText = "请选择部门"
                vc.didSelectDepartment = {[weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.selectDept = $0
                    strongSelf.department.text = $0.Name
                    self?.addNewModel.DeptId = $0.Id
                    //清空之前选择的员工
                    strongSelf.userName.text = nil
                    strongSelf.number.text = nil
                    strongSelf.addNewModel.EmployeeId = ""
                    strongSelf.addNewModel.EmployeeNo = ""
                }
                presentBottom(vc, changeScale: false)
                   
                }else if (indexPath.row == 2){
                    vc.vcType = .deptUserType
                    vc.deptId = selectDept?.Id
                    vc.selectedBlock = { [weak self] (user) in
                        let user = user as! Employee
                        self?.userName.text = user.Name
                        self?.number.text = user.EmployeeNo
                        self?.addNewModel.EmployeeId = user.Id
                        self?.addNewModel.EmployeeNo = user.EmployeeNo
                    }
                    presentBottom(vc, changeScale: false)
                }else if indexPath.row == 4{
                    vc.vcType = .leaveType
                    vc.selectedBlock = { [weak self] (lea) in
                       let leave = lea as! Dic
                       self?.leaveType.text = leave.Name
                       self?.leaveExplain.text = self?.getLeaveReason(key: leave.Id!)
                       self?.leaveChooseType = leave.Id!
                       self?.addNewModel.type = LeaveType(rawValue: Int(leave.Id!)!)
                   }
                   self.presentBottom(vc, changeScale: false)
                    
                }else if (indexPath.row == 6 || indexPath.row == 7){
                    let vc = SelectTimeVC()
                    if indexPath.row == 6 {
                        vc.selectDate = {[weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.beginTime.text = $0
                        strongSelf.addNewModel.BeginTime = $0
                   }
                    }else{
                       if beginTime.text!.isEmpty {
                          return HUDShowWithText(text: "请先选择开始时间")
                      }
                      vc.startDate = dateFromString(time: beginTime.text)
                      vc.calculationTime = true
                      vc.selectEndDateWithdurationTime = {[weak self](endDate, durationTime) in
                            guard let strongSelf = self else { return }
                            strongSelf.endTime.text = endDate
                            strongSelf.addNewModel.EndTime = endDate
                            strongSelf.duration.text = durationTime
                      }
                    }
                    self.presentBottom(vc, changeScale: false)
            }
        }else{
            let vc = UIStoryboard.init(name: "LeaveRequestSB", bundle: nil).instantiateViewController(withIdentifier: "OvertimeDetailTBVC") as! OvertimeDetailTBVC
            vc.pId = detail?.Id
            vc.idStr = detail?.LeaveCancel?[indexPath.row].LeaveEntryId
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
           return 82
        }
        if indexPath.row == 5 {
            return getLeaveReason(key: leaveChooseType).isEmpty ? 0 : UITableView.automaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            
            return sectionView
        }
        return super.tableView(tableView, viewForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return detail?.LeaveCancel?.count ?? 0 > 0 ? 100 : 140
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
}
// MARK: - 方法
extension NewLeaveRequestTBVC {
    func getLeaveReason(key: String) -> String {
        return plistDic[key] ?? ""
    }
    func getCheckDetail() {
        let vc = UIStoryboard.init(name: "LeaveRequestSB", bundle: nil).instantiateViewController(withIdentifier: "LeaveApprovalDetailsVC") as! LeaveApprovalDetailsVC
        vc.workFlow = detail?.AuditHis
        present(vc, animated: true, completion: nil)
    }
    func chooseApproval(isDesignate: Bool) {//
        let vc = SelectVC.init(nibName: nil, bundle: nil, vcType: .approvalMan)
        vc.showText = isDesignate ?  "选择委派人" : "选择审批人"
        vc.didSelectEmployee = {[weak self] model in
            guard let strongSelf = self else { return }
            strongSelf.dynaUser = model.Id
            if isDesignate {
                strongSelf.audit()
            }
        }
        presentBottom(vc, changeScale: false)
    }
}
