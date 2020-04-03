//
//  NoticeList.swift
//  misAppA
//
//  Created by 苏奎 on 2019/11/21.
//

import Foundation
import HandyJSON

class NoticeList: HandyJSON {
    required init() {}
    
    var Id: String? //记录id
    var Title: String? //标题
    var Sender: String? //发送人
    var CreatedOn: String? //发布日期
}
