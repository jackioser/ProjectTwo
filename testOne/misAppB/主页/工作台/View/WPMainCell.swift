//
//  WPMainCell.swift
//  misAppB
//
//  Created by XLiu on 2020/2/28.
//

import UIKit

class WPMainCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    
    func setContent(imageName:String, title:String) {
        self.image.image = UIImage(named: imageName)
        self.titleLab.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
