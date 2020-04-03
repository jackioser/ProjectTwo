//
//  LeaveRequestVC.swift
//  CheckSwift
//
//  Created by Mac on 20/2/24.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class LeaveRequestVC: UIViewController {
    var dataSource = [LeaveList?]()
    var pageIndex = 1
    var pageSize = 12
    lazy var table: UITableView = {
        let tab = UITableView(frame: CGRect.zero, style: .plain)
        tab.tableFooterView = UIView()
        tab.separatorStyle = .none
        tab.backgroundColor = .white
        tab.dataSource = self
        tab.delegate = self
        tab.register(UINib(nibName: "LeaveRequestCell", bundle: nil), forCellReuseIdentifier: "LeaveRequestCell")
        return tab
    }()
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 28)
        return lab
    }()
    lazy var filterVC: LeaveRequestFilterVC = {
        let vc = LeaveRequestFilterVC()
        vc.isChangeScale = true
        vc.filterDelegate = self
        vc.isShowLeaveType = true
        return vc
    }();
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let toTop = topHeight()
        titleLab.frame = CGRect(x: 20, y: toTop + 8, width: 200, height: 40)
        table.frame =  CGRect(x: 0, y: toTop + 64, width: ScreenWidth, height: ScreenHeight - toTop - 64)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        HUDShow()
        loadData(leaveType: nil)
    }
    
    func initUI() {
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        let rightOne = UIBarButtonItem(title: "筛选", style: .plain, target: self, action: #selector(filter))
        rightOne.tintColor = .black
        let rightTwo = UIBarButtonItem(title: "新建", style: .plain, target: self, action: #selector(creatNew))
        rightTwo.tintColor = .black
        self.navigationItem.rightBarButtonItems = [rightTwo , rightOne]
        view.backgroundColor = VCBackGroundColor
        table.backgroundColor = VCBackGroundColor
        view.addSubview(table)
        view.addSubview(titleLab)
        titleLab.text = "请假申请"
        
        
        table.setHeaderWithTarget(target: self, action: #selector(fefresh))
        table.setFooterWithTarget(target: self, action: #selector(loadMore))
    }
    //筛选
    @objc  func filter() {

        self.presentBottom(filterVC, changeScale: true)

    }
    @objc func presentBottomShouldHide() {
    
    }
    
    //新建
    @objc  func creatNew() {
        let vc = UIStoryboard.init(name: "LeaveRequestSB", bundle: nil).instantiateViewController(withIdentifier: "NewLeaveRequestTBVC") as! NewLeaveRequestTBVC
        vc.saveSuccessBlock = {[weak self] in
            self?.table.mj_header.beginRefreshing()
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func fefresh() {
        pageIndex = 1
        loadData(leaveType: nil)
    }
    @objc func loadMore() {
        pageIndex += 1
        loadData(leaveType: nil)
    }
}
// MARK: - 请求数据
extension LeaveRequestVC {
    func loadData(searchName: String = "", ownXLId: String = "", deptId: String = "", leaveType: Int?) {
        let dic = ["Employee": searchName,
                   "OwnXL": ownXLId,
                   "Dept": deptId,
                   "Type": leaveType as Any,
                   "pageIndex": pageIndex,
                   "pageSize": pageSize] as [String : Any]
        AFNetWorkingTool.shared.post(urlString:GetLeaveList , parampeters: dic, success: { [weak self] (responseInfo) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.HUDHide()
            strongSelf.table.mj_header.endRefreshing()
            strongSelf.table.mj_footer.endRefreshing()
            if responseInfo.error == 0 {
                guard let array = Array<LeaveList>.deserialize(from: responseInfo.items as? [Any]) else {
                    strongSelf.dataSource.removeAll()
                    strongSelf.table.mj_footer.isHidden = true
                    strongSelf.table.reloadData()
                    return
                }
                if strongSelf.pageIndex == 1 {
                    strongSelf.dataSource = array
                }else{
                   strongSelf.dataSource += array
                }
                strongSelf.table.mj_footer.isHidden = responseInfo.total == strongSelf.dataSource.count
                strongSelf.table.reloadData()
            }else {
                strongSelf.HUDShowWithText(text: responseInfo.msg)
            }
            }) { [weak self] (error) in
                guard let strongSelf = self else {return}
                strongSelf.HUDHide()
                strongSelf.pageIndex -= 1
                strongSelf.table.mj_header.endRefreshing()
                strongSelf.table.mj_footer.endRefreshing()
                strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }
}

  //MARK: - UITableViewDataSource
extension LeaveRequestVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveRequestCell", for: indexPath as IndexPath) as! LeaveRequestCell
        cell.selectionStyle = .none
        cell.leaveModel = dataSource[indexPath.row]
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "LeaveRequestSB", bundle: nil).instantiateViewController(withIdentifier: "NewLeaveRequestTBVC") as! NewLeaveRequestTBVC
        let model = dataSource[indexPath.row]!
        vc.idStr = model.Id
        vc.isEdit = model.IsEdit ?? false
        if model.IsAudit! {
            if model.State == .NotSubmit {
                vc.vctype = .editType
            }else {
                vc.vctype = .auditType
            }
        }else if model.IsEdit! {
            vc.vctype = .editType
        }else {
            vc.vctype = .checkType
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LeaveRequestVC: searchBtnDelegate {
    func searchBtnClick(searchName: String, ownXLId: String, deptId: String, leaveType: Int?) {
        HUDShow()
        pageIndex = 1
        loadData(searchName: searchName, ownXLId: ownXLId, deptId: deptId, leaveType: leaveType)
    }
}
