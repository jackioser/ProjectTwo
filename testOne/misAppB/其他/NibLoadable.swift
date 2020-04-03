//
//  NibLoadable.swift
//  misAppB
//
//  Created by XLiu on 2020/3/18.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
