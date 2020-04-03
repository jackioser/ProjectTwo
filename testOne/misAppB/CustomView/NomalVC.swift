//
//  NomalVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/29.
//

import UIKit

class NomalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum vcType : String, CaseIterable {
        case OvertimeApply      = "加班申请"
        case Announcement       = "公告发布"
        case CarApply           = "用车申请"
        case GoOutApply         = "外出申请"
        case MissionAllowance   = "出差补助"
        case SpecialCommission  = "专项附加扣除代办"
        case ResignApplication  = "离职申请"
        case UseSealApply       = "用章申请"
        case BusinessTripApply  = "出差申请"
    }
    
    var cells = [Any]()
    var type : vcType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        tableView.setHeaderWithTarget(target: self, action: #selector(refresh))
        tableView.setFooterWithTarget(target: self, action: #selector(getMore))
        view.backgroundColor = VCBackGroundColor
        navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: creatBtn), UIBarButtonItem.init(customView: screenBtn)]
        view.addSubview(titleLab)
        view.addSubview(tableView)
        
        titleLab.text = type?.rawValue
        switch type {
        case .OvertimeApply:
            registerCell(nibName: "GoOutApplyMainCell")
        case .Announcement:
            registerCell(nibName: "AnnouncementMainCell")
        case .CarApply:
            registerCell(nibName: "SpecialCommissionCell")
        case .GoOutApply:
            registerCell(nibName: "GoOutApplyMainCell")
        case .MissionAllowance:
            registerCell(nibName: "GoOutApplyMainCell")
        case .SpecialCommission:
            registerCell(nibName: "SpecialCommissionCell")
        case .ResignApplication:
            registerCell(nibName: "GoOutApplyMainCell")
        case .UseSealApply:
            registerCell(nibName: "GoOutApplyMainCell")
        case .BusinessTripApply:
            registerCell(nibName: "GoOutApplyMainCell")
        default:
            break
        }
    }
    
    func registerCell(nibName:String) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func reload(datas:Array<Any>) {
        cells.removeAll()
        cells.append(contentsOf: datas)
        self.tableView.reloadData()
    }
    
//    MARK:UITableViewDelegate && DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .OvertimeApply:
            let cell : GoOutApplyMainCell = tableView.dequeueReusableCell(withIdentifier: "GoOutApplyMainCell") as! GoOutApplyMainCell
            cell.cellType = .OvertimeApply
            cell.setOverTime(info: cells[indexPath.row] as! OvertimeList)
            return cell
        case .Announcement:
            let cell : AnnouncementMainCell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementMainCell") as! AnnouncementMainCell
//            cell.setNotice(notice: data[indexPath.row] as! NoticeList)
            return cell
        case .GoOutApply:
            let cell : GoOutApplyMainCell = tableView.dequeueReusableCell(withIdentifier: "GoOutApplyMainCell") as! GoOutApplyMainCell
            return cell
        case .CarApply:
            let cell : SpecialCommissionCell = tableView.dequeueReusableCell(withIdentifier: "SpecialCommissionCell") as! SpecialCommissionCell
            cell.cellType = .CarApply
            return cell
        case .MissionAllowance:
            let cell : GoOutApplyMainCell = tableView.dequeueReusableCell(withIdentifier: "GoOutApplyMainCell") as! GoOutApplyMainCell
            cell.cellType = .MissionAllowance
            return cell
        case .SpecialCommission:
            let cell : SpecialCommissionCell = tableView.dequeueReusableCell(withIdentifier: "SpecialCommissionCell") as! SpecialCommissionCell
            return cell
        case .ResignApplication:
            let cell : GoOutApplyMainCell = tableView.dequeueReusableCell(withIdentifier: "GoOutApplyMainCell") as! GoOutApplyMainCell
            cell.cellType = .ResignApplication
            return cell
        case .UseSealApply:
            let cell : GoOutApplyMainCell = tableView.dequeueReusableCell(withIdentifier: "GoOutApplyMainCell") as! GoOutApplyMainCell
            cell.cellType = .UseSealApply
            return cell
        case .BusinessTripApply:
            let cell : GoOutApplyMainCell = tableView.dequeueReusableCell(withIdentifier: "GoOutApplyMainCell") as! GoOutApplyMainCell
            cell.cellType = .BusinessTripApply
            return cell
        default:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectData(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch type {
        case .OvertimeApply:
            return 113
        case .Announcement:
            return 100
        case .GoOutApply:
            return 113
        case .CarApply:
            return 94
        case .MissionAllowance:
            return 113
        case .SpecialCommission:
            return 94
        case .ResignApplication:
            return 113
        case .UseSealApply:
            return 113
        case .BusinessTripApply:
            return 113
        default:
            return 0
        }
    }
    
//    MARK:Action
    
    @objc func screenAction() {}
    
    @objc func creatAction() {}
    
    @objc func refresh() {}
    
    @objc func getMore() {}
    
    func selectData(index:Int) {}
    
    func endRefresh() {
        HUDHide()
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
//    MARK:Lazy
    
    lazy var screenBtn:UIButton = {
        let btn = getBtn(title: "筛选")
        btn.addTarget(self, action: #selector(screenAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var creatBtn:UIButton = {
        let btn = getBtn(title: "新建")
        btn.addTarget(self, action: #selector(creatAction), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    lazy var titleLab:UILabel = {
        let lab = UILabel.init()
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 28)
        return lab
    }()

    lazy var tableView:UITableView = {
        let view = UITableView.init()
        view.backgroundColor = .clear
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    func getBtn( title:String) -> UIButton {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        btn.setTitle(title, for: UIControl.State.normal)
        return btn
    }
    
//    MARK: ViewAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let toTop = (self.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
        titleLab.frame = CGRect(x: 20, y: toTop + 8, width: 300, height: 40)
        tableView.frame =  CGRect(x: 0, y: toTop + 64, width: ScreenWidth, height: ScreenHeight - toTop - 64)
    }
}
