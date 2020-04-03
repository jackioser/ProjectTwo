//
//  OvertimeDetail.swift
//  misAppB
//
//  Created by XLiu on 2020/3/17.
//

import UIKit
import HandyJSON
class OvertimeDetail: HandyJSON {
    var Id:String? //记录ID
    var OrgId:String? //所属公司
    var OrgName:String? //对应公司
    var DeptId:String? //所属部门ID
    var DeptName:String? //所属部门
    var ItemsId:String? //项目ID
    var ItemName:String? //项目名称
    var EmployeeId:String? //加班人ID
    var Employee:String? //加班人名称
    var EmployeeNo:String? //员工编号
    var `Type`:String = "0" //加班性质
    var TypeName:String? //加班性质名称
    var Date:String? //加班日期
    var BeginTime:String? //开始时间
    var EndTime:String? //结束时间
    var OvertimeHour:Double? //加班时长（小时）
    var IsAdjustRest:String? //是否调休（T-是，F-否）
    var CreatedBy:String? //负责人
    var WorkPlace:String? //工作地点
    var OvertimeContent:String? //加班内容
    required init() {}
}

