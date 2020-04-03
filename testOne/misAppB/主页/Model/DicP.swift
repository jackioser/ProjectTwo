//
//  DicP.swift
//  misAppB
//
//  Created by jack on 2020/3/11.
//

import UIKit
import HandyJSON
//部门
class DicP: HandyJSON {
    var Id: String?
    var Name: String? //名称
    var PId: String? //父级id
    
    var indentationLevel: Int = 0 //本地新增属性，便于在tableView中展示
    var hasChild: Bool = false //本地新增属性，便于在tableView中展示
    var unfold: Bool = false //展开true, 未展开false
    
    required init() {}
    convenience init(id: String, name: String) {
        self.init()
        Id = id
        Name = name
    }
}
