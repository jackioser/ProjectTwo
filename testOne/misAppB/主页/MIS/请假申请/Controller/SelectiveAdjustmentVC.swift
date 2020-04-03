//
//  SelectiveAdjustmentVC.swift
//  misAppB
//
//  Created by jack on 2020/3/3.
//

import UIKit

class SelectiveAdjustmentVC: BaseViewController {

    
    var employeeId: String?
    var beginTime: String?
    var leaveId: String?
    
    var overList = [OverTimeCancel?]()
    convenience init(employeeId: String!, beginTime: String!, leaveId: String?){
        self.init()
        self.employeeId = employeeId
        self.beginTime = beginTime
        self.leaveId = leaveId
    }
    override func initUI() {
        super.initUI()
        title = "选择调休的加班"
        tb.dataSource = self
        tb.delegate = self
        tb.register(UINib(nibName: "SelectiveAdjustmentCell", bundle: nil), forCellReuseIdentifier: "SelectiveAdjustmentCell")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getOverTimeCancel()
    }
    // 保存更新
    override func bottomBtnClick() {
        updateLeaveCancel()
    }
    func getOverTimeCancel() {
        HUDShow()//LeaveId 请假调休记录id（有值时显示该调休记录已经冲抵的加班记录）
        let dic = ["EmployeeId": employeeId ?? "","Date": beginTime ?? "","LeaveId": leaveId ?? ""] as [String: Any]
        AFNetWorkingTool.shared.post(urlString: GetOverTimeCancel, parampeters: dic , success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if ResponseInfo.error == 0 {
                guard let array = Array<OverTimeCancel>.deserialize(from: ResponseInfo.items as? [Any]) else { return }
                strongSelf.overList = array
                strongSelf.tb.reloadData()
            }else{
                strongSelf.HUDShowWithText(text: ResponseInfo.msg)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
    func updateLeaveCancel() {
        let leaveCancel = overList.compactMap { (model) -> LeaveCancelBase in
            var base = LeaveCancelBase()
            base.OverTimeId = model?.OverTimeId
            base.Hour = model?.ThisCancelHour
            return base
        }
        HUDShow()
        let dic = ["LeaveId" : leaveId ?? "","LeaveCancel" : leaveCancel.toJSON()] as [String : Any]
        AFNetWorkingTool.shared.post(urlString: UpdateLeaveCancel, parampeters: dic , success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if ResponseInfo.error == 0 {
                strongSelf.HUDShowWithText(text: "保存成功")
                
            }else{
                strongSelf.HUDShowWithText(text: ResponseInfo.msg)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
}
extension SelectiveAdjustmentVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectiveAdjustmentCell", for: indexPath) as! SelectiveAdjustmentCell
        cell.selectionStyle = .none
        cell.model = overList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = overList[indexPath.row]
        overList[indexPath.row]?.selected =  model!.selected ? false : true
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
   
}
