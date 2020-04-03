//
//  User.swift
//  misAppA
//
//  Created by 苏奎 on 2019/11/6.
//

import Foundation
import HandyJSON

class User: HandyJSON {
    var Organization: Dic? //所属企业
    var Department: Dic? // 所属部门
    var Shortcut: [MappingPurview?]? //q权限
    var UserId: String? //用户id
    var LoginName: String? //登录名
    var FullName: String? //姓名
    var MobilePhone: String? //绑定手机号
    
    required init() {}
}

class MappingPurview: HandyJSON {
    var MappingId: String? //业务id
    var MappingCaption: String? //业务名称
    var DisplayOrder: Int? //显示顺序
    var Operate: String? //操作权限（字符形式的二进制数据，8位，0-无权限，1-有权限，从高到低对应：增加、删除、修改、预览、审核、反审核、备注、其他）
    
    required init() {}
}

class Dic: HandyJSON {
    var Id: String?
    var Name: String? //名称
    
    var selected = false //是否被选中
    
    required init() {}
    convenience init(id: String, name: String) {
        self.init()
        Id = id
        Name = name
    }
}

class DeptUser: HandyJSON {
    required init() {}
    
    var DeptId: String? //部门id
    var Dept: String? //部门
    var PId: String? //上级部门
    var Employee: Array<Dic?>? //员工
    
    var indentationLevel: Int = 0 //本地新增属性，便于在tableView中展示
    var unfold: Bool = false //展开true, 未展开false
    var hasChild: Bool = false //本地新增属性，便于在tableView中展示
}

class Employee: HandyJSON {
    required init() {}
    convenience init(id: String, name: String, EmployeeNo: String) {
        self.init()
        Id = id
        Name = name
    }
    
    var Id: String?
    var Name: String? //员工名字
    var EmployeeNo: String? //员工编号
}
