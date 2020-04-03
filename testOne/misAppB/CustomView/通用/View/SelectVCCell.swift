//
//  SelectVCCell.swift
//  misAppA
//
//  Created by 苏奎 on 2020/3/12.
//

import Foundation
import UIKit

class SelectVCCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
//    var bottomLine: UIView = UIView()
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var arrowBtn: UIButton!
    var unfold: ((Bool, UITableViewCell)->())?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        unfold?(sender.isSelected, self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = VCBackGroundColor
    }
}

class SelectApprovalCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var bottomLine: UIView = UIView()
    @IBOutlet weak var leading: NSLayoutConstraint!
    var unfold: ((Bool, UITableViewCell)->())?
    var selectApproval: ((Bool)->())?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        unfold?(sender.isSelected, self)
    }
    
    @IBAction func selectApproval(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectApproval?(sender.isSelected)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = VCBackGroundColor
    }
}
