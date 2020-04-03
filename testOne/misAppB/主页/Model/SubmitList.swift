//
//  SubmitList.swift
//  misAppA
//
//  Created by 苏奎 on 2019/11/21.
//

import Foundation
import HandyJSON

enum RunState: Int, HandyJSONEnum {
    case NotSubmit, NotStarted, Running, Finish, NotMet, Stop, Disagree
}

class SubmitList: HandyJSON {
    required init() {}
    
    var Id: String? //申请记录id
    var RecordId: String? //业务记录id
    var TableName: String? //业务表名称
    var `Type`: ApplicationType = .Leave //申请类型
    var TypeName: String? //申请类型名称
    var Auditor: String? //当前审批人
    var AuditTime: String? //审批时间
    var State: RunState = .NotSubmit //流程状态
    var StateName: String? //流程状态名称
}
