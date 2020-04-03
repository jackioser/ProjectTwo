//
//  AuditList.swift
//  misAppA
//
//  Created by 苏奎 on 2019/11/19.
//

import Foundation
import HandyJSON

enum ApplicationType: Int {
    case Leave, Overtime, Out, Away, Regular, Separation, TaxDeduction, VisitingRelatives, AddClockOff, Affiche, UseChapter, UseCar, AwayAllowance
}

class AuditList: HandyJSON {
    required init() {}
    
    var WFStateId: String? //审批记录id
    var RecordId: String? //业务记录id
    var TableName: String? //业务表名称
    var WFObjectId: String? //工作对象id
    var WFRunningId: String? //对应WFRunning表ID
    var ActivityId: String? //当前审批步骤的ID
    var `Type`: ApplicationType = .Leave //申请类型
    var TypeName: String? //申请类型名称
    var Author: String? //创建人
    var CreatedOn: String? //创建时间
    var State : RunState = .NotSubmit //流程状态
}
