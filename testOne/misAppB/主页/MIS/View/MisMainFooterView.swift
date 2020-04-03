//
//  MisMainFooterView.swift
//  misAppB
//
//  Created by XLiu on 2020/2/27.
//

import UIKit

class MisMainFooterView: UICollectionReusableView {
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var redCircelLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        footerView.roundCorners(cornerRadius: 6, type: .bottom)
    }
    
    @IBAction func getMoreAction(_ sender: UIButton) {
    }
}
