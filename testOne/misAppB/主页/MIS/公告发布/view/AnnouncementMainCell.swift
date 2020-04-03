//
//  AnnouncementMainCell.swift
//  misAppB
//
//  Created by XLiu on 2020/2/29.
//

import UIKit

class AnnouncementMainCell: UITableViewCell {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var companyLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var statuLab: UILabel!
    @IBOutlet weak var isTop: UILabel!
    @IBOutlet weak var isShow: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setNotice(notice:NoticeList) {
        titleLab.text = notice.Title
        timeLab.text = notice.CreatedOn
        nameLab.text = notice.Sender
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
