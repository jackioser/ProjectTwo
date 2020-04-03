//
//  LeaveRequestCell.swift
//  CheckSwift
//
//  Created by Mac on 20/2/12.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class LeaveRequestCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var leaveType: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    
    var leaveModel: LeaveList? {
        didSet {
            guard let model = leaveModel else {return}
            leaveType.text = model.TypeName
            userName.text = model.Employee
            company.text = model.OrgName
            dept.text = model.DeptName
            state.text = model.StateName
            startTime.text = model.BeginTime
            endTime.text = model.EndTime
            duration.text = model.LeaveDates
            
            switch model.State {
            case .Finish:
                state.textColor = greenColor
            case .Stop:
                state.textColor = .red
            default:
                state.textColor = DefaultgreyColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = VCBackGroundColor
        bgView.layer.cornerRadius = 14
        bgView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
