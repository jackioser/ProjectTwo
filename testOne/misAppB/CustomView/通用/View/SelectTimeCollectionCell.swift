//
//  SelectTimeCollectionCell.swift
//  misAppA
//
//  Created by 苏奎 on 2020/3/3.
//

import Foundation
import UIKit

class SelectTimeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    var isTimeCell: Bool = false //是否是选择小时和分钟时的cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLine.isHidden = true
        
        backView.layer.cornerRadius = (ScreenWidth/7 - 10)/2.0
        if ScreenWidth > 375 {
            contentLabel.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if !isTimeCell {
                backView.isHidden = !newValue
            }
        }
    }
}
