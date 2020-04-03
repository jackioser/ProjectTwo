//
//  CollectionHeaderReusableView.swift
//  CheckSwift
//
//  Created by Mac on 20/3/1.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class CollectionHeaderReusableView: UICollectionReusableView {
    
    lazy var categorylab: UILabel = {
        let lab = UILabel()
        lab.textColor = DefaultTextColor
        lab.font = UIFont(name: "PingFangSC-Medium", size: 18)
        return lab
    }()
    lazy var line = UIView().then {
        $0.backgroundColor = GrayLineColor
        self.addSubview($0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = VCBackGroundColor
        addSubview(categorylab)
        categorylab.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-10)
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
