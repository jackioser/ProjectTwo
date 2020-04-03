//
//  NoticeList.swift
//  misAppB
//
//  Created by XLiu on 2020/3/11.
//

import UIKit
import HandyJSON

class NoticeList: HandyJSON {
    
    var Id: String? //记录id
    var Title: String? //标题
    var Sender: String? //发送人
    var CreatedOn: String? //发布日期
    
    required init() {}
}
