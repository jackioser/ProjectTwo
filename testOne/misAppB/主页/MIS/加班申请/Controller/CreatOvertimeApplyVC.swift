//
//  CreatOvertimeApplyVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/4.
//

import UIKit

class CreatOvertimeApplyVC: UIViewController {

    var tableVC : CreatOvertimeApplyTVC? = nil
    var otID:String?
    var isCommit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = VCBackGroundColor
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        if (otID != nil) {
            getOvertimeDetail()
        }
    }
    
//    MARK:NetWorking
    
    func getOvertimeDetail() {
        HUDShow()
        AFNetWorkingTool.shared.post(urlString: GetOvertimeDetail, parampeters: ["Id":otID ?? ""], success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if ResponseInfo.error == 0 {
                guard let info = OvertimeDetail.deserialize(from: ResponseInfo.items as? [String:Any]) else {return}
                strongSelf.tableVC?.detail = info
            } else {
                strongSelf.HUDShowWithText(text: ResponseInfo.msg, time: 1)
            }
        }) { [weak self] (Error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
        }
    }
    
    func savaApply() {
        HUDShow()
        let detail = tableVC?.detail
        var param = [String:Any]()
        param["Id"] = detail?.Id
        param["OrgId"] = detail?.OrgId
        param["DeptId"] = detail?.DeptId
        param["ItemsId"] = detail?.ItemsId
        param["EmployeeId"] = detail?.EmployeeId
        param["EmployeeNo"] = detail?.EmployeeNo
        param["Type"] = detail?.Type
        param["Date"] = detail?.Date
        param["BeginTime"] = detail?.BeginTime
        param["EndTime"] = detail?.EndTime
        param["OvertimeHour"] = detail?.OvertimeHour
        param["IsAdjustRest"] = detail?.IsAdjustRest
        param["WorkPlace"] = detail?.WorkPlace
        param["OvertimeContent"] = detail?.OvertimeContent
        param["version"] = ""
        AFNetWorkingTool.shared.post(urlString: EditOvertime, parampeters: param, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if ResponseInfo.error == 0 {
                strongSelf.HUDShowWithText(text: "保存成功")
                if strongSelf.isCommit {
                    let alrt = UIAlertController.init(title: nil, message: "请选择下一步审批人", preferredStyle: .alert)
                    let actionA = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                    let actionB = UIAlertAction.init(title: "好", style: .default) { (UIAlertAction) in
                        strongSelf.commitApply()
                    }
                    alrt.addAction(actionA)
                    alrt.addAction(actionB)
                    strongSelf.present(alrt, animated: true, completion: nil)
                }
            } else {
                strongSelf.HUDShowWithText(text: ResponseInfo.msg, time: 1)
            }
        }) { [weak self] (Error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
        }
    }
    
    func commitApply() {
        
    }
    
//    MARK:Action
    
    @objc func saveAction() {
        isCommit = false
        savaApply()
    }
    
    @IBAction func saveCommitAction(_ sender: UIButton) {
        isCommit = true
        savaApply()
    }
    
//    MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreatOvertimeApplyTVC {
            tableVC = vc
        }
    }

}
