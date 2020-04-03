//
//  LeaveFilterCollectionCell.swift
//  CheckSwift
//
//  Created by Mac on 20/3/1.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit
import SnapKit
import Then

class LeaveFilterCollectionCell: UICollectionViewCell {
    
    lazy var nameLab = UILabel().then { (lab) in
        lab.textColor = DefaultTextColor
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textAlignment = .center
        addSubview(lab)
        lab.snp.makeConstraints { (make) in
           make.left.right.top.bottom.equalToSuperview()
        }
    }
    var deptModel: Dic? {
        didSet{
            guard let model = deptModel else {return}
            nameLab.text = model.Name
            isSelected(select: model.selected)
        }
    }
    func isSelected(select: Bool){
        if select {
            backgroundColor = .white
            layer.borderColor = blueButtonColor.cgColor
            layer.borderWidth = 1
        }else{
            backgroundColor = GrayLineColor
            layer.borderWidth = 0
        }
 
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = GrayLineColor
        layer.cornerRadius = 5
        nameLab.text = "平台事业部"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
