//
//  LeaveDetail.swift
//  misAppB
//
//  Created by jack on 2020/3/12.
//

import UIKit
import HandyJSON

struct LeaveDetail: HandyJSON {

    var AllHour : Float?
    var AuditHis : WorkFlowRecordData?
    var BeginTime : String?
    var CreatedBy : String?
    var CreatedOn : String?
    var DeptId : String?
    var DeptName : String?
    var Employee : String?
    var EmployeeId : String?
    var EmployeeNo : String?
    var EndTime : String?
    var Id : String?
    var LeaveCancel : [LeaveCancel]?
    var LeaveDates : String?
    var OrgId : String?
    var OrgName : String?
    var Remark : String?
    var type : LeaveType?
    var TypeName : String?
    var UsedHour : Float?

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.type <-- "Type"
    }
    mutating func didFinishMapping() {
        BeginTime = formatTime(time: BeginTime, formater: "yyyy/MM/dd HH:mm")
        EndTime = formatTime(time: EndTime, formater: "yyyy/MM/dd HH:mm")
        CreatedOn = formatTime(time: CreatedOn, formater: "yyyy/MM/dd")
    }
}


struct LeaveCancel: HandyJSON {
    var LeaveEntryId: String? //请假调休子表记录id
    var Date : String?  //日期
    var Hour : Float?  //冲抵小时数
    var ItemName : String?  //项目名称
    var OverTimeHour : Float? //加班小时数
    var OverTimeId : String? //加班记录id
}

struct WorkFlowRecordData: HandyJSON {
    var NextApprover : String?              //下个审批人,多人时逗号分隔
    var NextStep : String?                  //下个审批步骤
    var WorkFlowRecord : [WorkFlowRecord]?  //已审批记录
}

struct WorkFlowRecord: HandyJSON {
    var ActivityCaption : String? //步骤
    var DeptName : String?        //部门
    var OperTime : String?        //审批时间
    var OperUser : String?        //审批人
    var Remark : String?          //审批意见
    var WFStateEntryId : String?  //流程Id
    
    mutating func didFinishMapping() {
        OperTime = formatTime(time: OperTime, formater: "yyyy.MM.dd HH:mm")
    }
}
