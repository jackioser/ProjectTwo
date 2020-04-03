//
//  MisMessageCell.swift
//  misAppB
//
//  Created by XLiu on 2020/4/2.
//

import UIKit

class MisMessageCell: UICollectionViewCell {

    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var redCircleView: UIView!
    
    @IBOutlet weak var toTopWidth: NSLayoutConstraint!
    @IBOutlet weak var senderWidth: NSLayoutConstraint!
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var labA: UILabel!
    @IBOutlet weak var labB: UILabel!
    
    func setMessage(info:MessageList) {
        titleLab.text = info.Caption
        labA.text = info.Sender
        labB.text = info.CreatedOn
    }
    
    func setNotice(info:NoticeList) {
        titleLab.text = info.Title
        labA.text = info.CreatedOn
        labB.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
