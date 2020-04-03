//
//  MissionDetailCell.swift
//  misAppB
//
//  Created by XLiu on 2020/3/1.
//

import UIKit

class MissionDetailCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var destionaLab: UILabel!
    @IBOutlet weak var startLab: UILabel!
    @IBOutlet weak var dayNumLa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
