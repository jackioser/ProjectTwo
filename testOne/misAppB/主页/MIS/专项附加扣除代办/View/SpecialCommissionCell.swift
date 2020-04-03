//
//  SpecialCommissionCell.swift
//  misAppB
//
//  Created by XLiu on 2020/3/4.
//

import UIKit

class SpecialCommissionCell: UITableViewCell {
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var companyLab: UILabel!
    @IBOutlet weak var departmentLab: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var statuLab: UILabel!
    @IBOutlet weak var hourLab: UILabel!
    
    @IBOutlet weak var multLabA: UILabel!
    @IBOutlet weak var multLabB: UILabel!
    @IBOutlet weak var multLabC: UILabel!
    
    var cellType:NomalVC.vcType?{
        didSet {
            switch cellType {
            case .CarApply:
                multLabA.text = "用车部门："
                multLabB.text = "车牌号："
                multLabC.text = "用车小时数"
            default:
                break
            }
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
