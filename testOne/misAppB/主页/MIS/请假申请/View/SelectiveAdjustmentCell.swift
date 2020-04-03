//
//  SelectiveAdjustmentCell.swift
//  misAppB
//
//  Created by jack on 2020/3/3.
//

import UIKit

class SelectiveAdjustmentCell: UITableViewCell ,UITextFieldDelegate {
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var project: UILabel!
    @IBOutlet weak var depate: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var overCount: UILabel!
    @IBOutlet weak var adjustCount: UILabel!
    @IBOutlet weak var nowAdjust: UITextField!
    @IBOutlet weak var circleBtn: UIButton!
    var model: OverTimeCancel? {
        didSet{
            guard let model = model else {return}
            user.text = model.Employee
            company.text = model.OrgName
            project.text = model.ItemName
            depate.text = model.DeptName
            time.text = model.Date
            type.text = model.Type
            overCount.text = model.OverTimeHour
            adjustCount.text = model.EnableHour
            nowAdjust.text = model.ThisCancelHour
            circleBtn.isSelected = model.selected
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = VCBackGroundColor
        nowAdjust.delegate = self
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
         if nowAdjust == textField {
            model?.ThisCancelHour = textField.text
        }
    }
}
