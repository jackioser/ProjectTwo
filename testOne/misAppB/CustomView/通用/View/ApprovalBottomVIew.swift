//
//  ApprovalBottomVIew.swift
//  misAppB
//
//  Created by jack on 2020/3/24.
//

import UIKit
enum AuditType: Int{
    case agree        //同意
    case disagree     //不同意
    case designate    //委托
    case rollBack    //回退
    case termination //终止
    case abstain     //弃权
}
class ApprovalBottomVIew: UIView, NibLoadable {

    @IBOutlet weak var approvalText: UITextField!
    
    var auditTypeBlock:((_ type: AuditType, _ description: String) -> ())?
    
    
    var auditType: AuditType = .agree
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(view: self, sColor: .gray, offset: CGSize(width: 0, height: -1), opacity: 0.1, radius: 1)
    }
    @IBAction func btnGes(_ sender: UITapGestureRecognizer) {
        // tag 10 11 12 13
        switch sender.view?.tag {
        case 10:
            auditType = .agree
        case 11:
            auditType = .disagree
        case 12:
            auditType = .termination
        case 13:
            auditType = .designate
        default: break
        }
        auditTypeBlock?(auditType, approvalText.text ?? "")
    }

}
