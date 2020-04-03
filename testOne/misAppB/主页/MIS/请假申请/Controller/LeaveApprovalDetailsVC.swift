//
//  LeaveApprovalDetailsVC.swift
//  misAppB
//
//  Created by jack on 2020/3/4.
//

import UIKit

class LeaveApprovalDetailsVC: UIViewController {

    @IBOutlet weak var tab: UITableView!
   
    @IBOutlet weak var nextPerson: UILabel!
    
    var workFlow: WorkFlowRecordData?//详情页传来的数据
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        nextPerson.text = workFlow?.NextApprover
    }
    func configUI(){
        tab.dataSource = self
        tab.delegate = self
        tab.separatorStyle = .none
        tab.backgroundColor = VCBackGroundColor
        nextPerson.superview?.backgroundColor = VCBackGroundColor
        
        let header = UILabel(frame: CGRect(x: 20, y: 20, width: 0, height: 0))
        header.text = "步骤明细"
        header.font = GlobalFont
        header.textColor = DefaultgreyColor
        header.sizeToFit()
        tab.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 60))
        tab.tableHeaderView!.addSubview(header)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LeaveApprovalDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workFlow?.WorkFlowRecord?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveApprovalDetailsCell", for: indexPath) as! LeaveApprovalDetailsCell
        cell.workFlowRecord = workFlow?.WorkFlowRecord?[indexPath.row]
        if let num = workFlow?.WorkFlowRecord?.count {
            cell.line.isHidden = indexPath.row == num - 1 ? true : false
            if workFlow?.NextApprover == "流程已结束" {
                if indexPath.row == num - 2{
                    cell.line.backgroundColor = greenColor
                }else if indexPath.row == num - 1 {
                    cell.img.image = UIImage(named: "greengou")
                    cell.changeColor(color:greenColor)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
