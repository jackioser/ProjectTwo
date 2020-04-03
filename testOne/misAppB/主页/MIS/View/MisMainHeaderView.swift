//
//  MisMainHeaderView.swift
//  misAppB
//
//  Created by XLiu on 2020/2/27.
//

import UIKit

protocol MisMainHeaderViewDelegate {
    func pullDown(index:NSInteger)
}

class MisMainHeaderView: UICollectionReusableView {

    @IBOutlet weak var pullBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    
    var delegate:MisMainHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func pullDownAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1
//        animation.fromValue = sender.isSelected ? Double.pi : 0
//        animation.toValue = sender.isSelected ? 0 : Double.pi
//        animation.speed = 2
//        animation.fillMode = CAMediaTimingFillMode.forwards
//        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        sender.layer.add(animation, forKey: nil)
        delegate?.pullDown(index: sender.tag)
    }
    
}
