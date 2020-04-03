//
//  OvertimeRecordsCell.swift
//  CheckSwift
//
//  Created by Mac on 20/2/27.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class OvertimeRecordsCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var offsetTime: UILabel!
    @IBOutlet weak var overTime: UILabel!
    @IBOutlet weak var overDate: UILabel!
    
    
    var overtime: LeaveCancel? {
        didSet{
            guard let model = overtime else {return}
            projectName.text = model.ItemName
            offsetTime.text = "\(model.Hour ?? 0)"
            overTime.text = "\(model.OverTimeHour ?? 0)"
            overDate.text = model.Date
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = VCBackGroundColor
    }

    
}
