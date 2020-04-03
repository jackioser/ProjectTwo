//
//  GoOutApplyMainCell.swift
//  misAppB
//
//  Created by XLiu on 2020/3/1.
//

import UIKit

class GoOutApplyMainCell: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var companyLab: UILabel!
    @IBOutlet weak var departmentLab: UILabel!
    @IBOutlet weak var startLab: UILabel!
    @IBOutlet weak var endLab: UILabel!
    @IBOutlet weak var statuLab: UILabel!
    @IBOutlet weak var hourLab: UILabel!
    @IBOutlet weak var remarkLab: UILabel!
    
    @IBOutlet weak var multLabA: UILabel!
    @IBOutlet weak var multLabB: UILabel!
    @IBOutlet weak var multLabC: UILabel!
    @IBOutlet weak var multLabD: UILabel!
    
    var cellType:NomalVC.vcType?{
        didSet {
            switch cellType {
            case .OvertimeApply:
                multLabA.text = "项目名称："
                multLabB.text = "加班日期："
                multLabC.text = "加班时长"
                multLabD.text = "所属部门："
            case .MissionAllowance:
                multLabA.text = "申请时间："
                multLabB.text = "发放月份："
                multLabC.text = "总出差天数"
            case .ResignApplication:
                multLabA.text = "申请时间："
                multLabB.text = "入司时间："
                multLabC.isHidden = true
                hourLab.text = "项目专员"
                hourLab.font = UIFont.systemFont(ofSize: 13)
            case .UseSealApply:
                multLabA.text = "项目名称："
                multLabB.text = "申请日期："
                multLabC.text = "用章次数"
                remarkLab.text = "公章. 法人章. 财务章"
            case .BusinessTripApply:
                multLabD.text = "所属部门："
                multLabC.text = "出差天数"
                remarkLab.text = "借款：否"
            default:
                break
            }
        }
    }
    
    func setOverTime(info:OvertimeList) {
        nameLab.text = info.Employee
        companyLab.text = info.OrgName
        departmentLab.text = info.DeptName
        startLab.text = info.ItemName
        endLab.text = info.Date
        statuLab.text = info.StateName
        hourLab.text = info.OvertimeHour
        switch info.State {
        case .Finish:
            statuLab.textColor = .green
        case .Stop:
            statuLab.textColor = .red
        default:
            break
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
