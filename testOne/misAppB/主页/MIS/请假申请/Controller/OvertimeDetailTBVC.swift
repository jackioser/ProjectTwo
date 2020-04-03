//
//  OvertimeDetailTBVC.swift
//  misAppB
//
//  Created by jack on 2020/3/23.
//

import UIKit

class OvertimeDetailTBVC: UITableViewController {

    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var depart: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var protectName: UILabel!
    @IBOutlet weak var overType: UILabel!
    @IBOutlet weak var overDate: UILabel!
    @IBOutlet weak var overCount: UILabel!
    @IBOutlet weak var adjustCount: UILabel!
    @IBOutlet weak var nowAdjustCount: UILabel!
    
    var pId: String?  //主表记录id
    var idStr: String? //子表id(加班记录详情id)
    
    var detail:OverTimeCancel? {
        didSet{
           guard let model = detail else {return}
            userName.text = model.Employee
            company.text = model.OrgName
            depart.text = model.DeptName
            overDate.text = model.Date
            overType.text = model.Type
            place.text = model.WorkPlace
            protectName.text = model.ItemName
            overCount.text = model.OverTimeHour
            adjustCount.text = model.EnableHour
            nowAdjustCount.text = model.ThisCancelHour
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加班记录明细"
        let cancle = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(cancleClick))
        cancle.tintColor = .orange
        navigationItem.rightBarButtonItem = cancle
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = VCBackGroundColor
        getOverTimeCancelInfo()
    }
    func getOverTimeCancelInfo() {
        guard let id = idStr else {return}
        HUDShow()
        AFNetWorkingTool.shared.post(urlString: GetOverTimeCancelInfo, parampeters: ["Id": id], success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            guard let model = OverTimeCancel.deserialize(from: ResponseInfo.items as? [String: Any])  else {return}
            strongSelf.detail = model

        }) {[weak self] (error) in
            guard let strongSelf = self else {return}
            strongSelf.HUDHide()
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
    //删除
    @objc func cancleClick() {
//        guard let id = idStr else {return}
        guard let pId = pId else {return}
        HUDShow()
        let dic = ["ApplyTable": 0, "Table": 1, "Ids": [pId], "PId": ""] as [String : Any]
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = VCBackGroundColor
        return cell
    }
}

