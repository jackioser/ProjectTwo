//
//  OvertimeApplyVC.swift
//  misAppB
//
//  Created by XLiu on 2020/3/4.
//

import UIKit

class OvertimeApplyVC: NomalVC, searchBtnDelegate {
    
    var page = 1
    var param = [String : Any]()
    var datas = [OvertimeList?]()
    lazy var screenVC:LeaveRequestFilterVC = {
        let vc = LeaveRequestFilterVC()
        vc.isChangeScale = true
        vc.filterDelegate = self
        vc.isShowLeaveType = false
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        HUDShow()
        getData()
    }
    
    func initData() {
        param["pageSize"] = 10
        param["OwnXL"] = ""
        param["Dept"] = ""
        param["Employee"] = ""
    }
    
//    MARK:NetWorking
    
    func getData() {
        param["pageIndex"] = page
        AFNetWorkingTool.shared.post(urlString: GetOvertimeList, parampeters: param, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.endRefresh()
            if ResponseInfo.error == 0 {
                let ary = Array<OvertimeList>.deserialize(from: ResponseInfo.items as? [Any])
                if ary != nil {
                    strongSelf.datas += ary!
                }                
                strongSelf.reload(datas: strongSelf.datas as Array<Any>)
                strongSelf.tableView.mj_footer.isHidden = strongSelf.datas.count == ResponseInfo.total!
            } else {
                if strongSelf.page != 0 {
                    strongSelf.page -= 1
                }
                strongSelf.HUDShowWithText(text: ResponseInfo.msg, time: 1)
            }
        }) { [weak self] (Error) in
            guard let strongSelf = self else { return }
            strongSelf.endRefresh()
            if strongSelf.page != 0 {
                strongSelf.page -= 1
            }
        }
    }
    
//    MARK:Refresh
    
    override func refresh() {
        self.reloadData()
    }
    
    override func getMore() {
        page += 1
        self.getData()
    }
    
    func reloadData() {
        page = 1
        datas.removeAll()
        self.getData()
    }
    
//    MARK:searchBtnDelegate
    
    func searchBtnClick(searchName: String, ownXLId: String, deptId: String, leaveType: Int?) {
        param["OwnXL"] = ownXLId
        param["Dept"] = deptId
        param["Employee"] = searchName
        self.HUDShow()
        self.reloadData()
    }
    
//    MARK:Action
    
//    新建
    override func creatAction() {
        let vc = UIStoryboard.init(name: "OvertimeApply", bundle: nil).instantiateViewController(withIdentifier: "CreatOvertimeApplyVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    筛选
    override func screenAction() {
        self.presentBottom(screenVC, changeScale: true)
    }

//    点击cell
    override func selectData(index:Int) {
          let info:OvertimeList = datas[index]!
          let vc:CreatOvertimeApplyVC = UIStoryboard.init(name: "OvertimeApply", bundle: nil).instantiateViewController(withIdentifier: "CreatOvertimeApplyVC") as! CreatOvertimeApplyVC
          vc.otID = info.Id
          navigationController?.pushViewController(vc, animated: true)
      }

}
