//
//  LeaveApprovalDetailsCell.swift
//  misAppB
//
//  Created by jack on 2020/3/4.
//

import UIKit

class LeaveApprovalDetailsCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var opinion: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var workFlowRecord: WorkFlowRecord? {
        didSet{
            guard let model = workFlowRecord else {return}
            state.text = model.ActivityCaption
            name.text = model.OperUser
            department.text = model.DeptName
            opinion.text = model.Remark
            time.text = model.OperTime
            switch model.ActivityCaption {
            case "结束":
                img.image = UIImage(named: "greengou")
                changeColor(color:greenColor)
            case "中止":
                img.image = UIImage(named: "redX")
                changeColor(color: .red)
            default:
                img.image = UIImage(named: "blueSelected")
//                changeColor(color: blueButtonColor)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = VCBackGroundColor
    }

    func changeColor(color: UIColor) {
        for lab in contentView.subviews {
            if lab is UILabel {
                let lb = lab as! UILabel
                lb.textColor = color
            }
        }
    }

}
