//
//  LeaveList.swift
//  CheckSwift
//
//  Created by Mac on 20/2/24.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit
import HandyJSON

enum LeaveType: Int, HandyJSONEnum {
    case CompassionateLeave = 0 //事假
    case SickLeave          = 1 //病假
    case MarriageLeave      = 2//婚假
    case Maternity          = 3//产假
    case Funeral            = 5//丧假
    case other              = 6//其他
    case Annual             = 7//年假
    case Break              = 8//调休
}
struct LeaveList: HandyJSON {
    var Id: String?//记录ID
    var OrgId: String?//所属公司
    var OrgName: String?//对应公司
    var DeptId: String?//所属部门ID
    var DeptName: String?//所属部门
    
    var State: RunState?
    var StateName: String?//流程状态名称
    var EmployeeId: String?
    var Employee:String?//请假人
    var `Type`: LeaveType = .CompassionateLeave
    var TypeName: String?//请假类型名称
    var BeginTime: String?
    var EndTime: String?
    var LeaveDates: String?//请假时长（小时）
    var Remark: String?//请假事由
    var IsAudit: Bool? //当前用户是否可审批
    var IsEdit: Bool?  //是否可编辑
    var IsDeleted: Bool? //是否可删除
    
    mutating func didFinishMapping() {
//        let index = BeginTime!.count - 3
//        let sub = BeginTime?.prefix(index)
//        BeginTime = String(sub ?? "")
        BeginTime = formatTime(time: BeginTime, formater: "yyyy-MM-dd HH:mm")
        EndTime = formatTime(time: EndTime, formater: "yyyy-MM-dd HH:mm")
    }
    
    func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            BeginTime <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd  HH:mm")
//        mapper <<<
//            EndTime <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd  HH:mm")
        
    }
}

class OverTimeCancel: HandyJSON {
    required init() {}
    var DeptName : String?//所属部门
    var Employee : String?//员工姓名
    var EnableHour : String? //可调休小时数
    var ItemName : String?//项目名称
    var LeaveEntryId : String?//请假调休子表记录id（有值时表示此次已经调休了）
    var OrgName : String?  //对应公司
    var OverTimeHour : String?//加班小时数
    var OverTimeId : String?//加班记录Id
    var ThisCancelHour : String? //此次抵消
    var Date : String?//加班日期
    var `Type` : String?//加班
    var WorkPlace : String? //工作地点
    
    
    var selected: Bool = false
}

struct LeaveCancelBase: HandyJSON {
    var OverTimeId: String? //加班记录id
    var Hour: String?       //冲抵小时数
}
