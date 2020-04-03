//
//  MessageList.swift
//  misAppB
//
//  Created by XLiu on 2020/4/2.
//

import UIKit
import HandyJSON

class MessageList: HandyJSON {
    var Id : String? //记录id
    var Caption : String? //标题
    var Body : String? //消息内容
    var Sender : String? //发送人
    var CreatedOn : String? //发送时间
    var ReadState : String? //是否已读（1-是，0否）
    required init() {}
}
