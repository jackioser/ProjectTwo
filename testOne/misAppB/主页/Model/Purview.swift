//
//  Purview.swift
//  misAppA
//
//  Created by 苏奎 on 2019/11/19.
//

import Foundation
import HandyJSON

class Purview: HandyJSON {
    required init() {}
    
    var ModelId: String? //模块id
    var ModelCaption: String? //模块名称
    var DisplayOrder: Int? //显示顺序
    var MappingPurview: Array<MappingPurview?>? //业务集合
}
