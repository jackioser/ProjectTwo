//
//  OvertimeList.swift
//  misAppB
//
//  Created by XLiu on 2020/3/16.
//

import UIKit
import HandyJSON

class OvertimeList: HandyJSON {
    var Id : String? //记录ID
    var OrgId : String? //所属公司
    var OrgName : String? //对应公司
    var DeptId : String? //所属部门ID
    var DeptName : String? //所属部门
    var ItemsId : String? //项目ID
    var ItemName : String? //项目名称
    var State : RunState? //流程状态
    var StateName : String? //流程状态名称
    var EmployeeId : String? //加班人ID
    var Employee : String? //加班人名称
    var `Type` : String? //加班性质
    var TypeName : String? //加班性质名称
    var Date : String? //加班日期
    var OvertimeHour : String? //加班时长（小时）
    var IsAudit : Bool? //当前用户是否可审批
    var IsEdit : Bool? //是否可编辑
    var IsDeleted : Bool? //是否可删除
    
    required init() {}
}
