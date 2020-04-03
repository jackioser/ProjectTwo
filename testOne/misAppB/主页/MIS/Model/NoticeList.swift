//
//  NoticeList.swift
//  misAppB
//
//  Created by XLiu on 2020/4/2.
//

import UIKit
import HandyJSON

class NoticeList: HandyJSON {

    var Id : String? //记录ID
    var Title : String? //标题
    var Sender : String? //发送人
    var CreatedOn : String? //发布日期
    var IsTop : String? //是否置顶（1-是，0-否)
    
    required init() {}
}
