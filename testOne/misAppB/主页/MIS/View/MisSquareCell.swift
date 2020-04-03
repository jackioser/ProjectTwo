//
//  MisSquareCell.swift
//  misAppB
//
//  Created by XLiu on 2020/2/27.
//

import UIKit

class MisSquareCell: UICollectionViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var creatPersonLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var typeLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 14
    }
    
    func setSubmit(info:SubmitList) {
        titleLab.text = info.TypeName
        creatPersonLab.text = info.Auditor
        dateLab.text = info.SubmitTime
        typeLab.text = info.TypeName
    }
    
    func setAudit(info:AuditList) {
        titleLab.text = info.TypeName
        creatPersonLab.text = info.Author
        dateLab.text = info.CreatedOn
        typeLab.text = info.TypeName
    }
}
