//
//  ColorDefine.swift
//  LogisticsQuery
//
//  Created by 苏奎 on 2019/6/28.
//  Copyright © 2019 苏奎. All rights reserved.
//

import UIKit

let GlobalFont = UIFont.systemFont(ofSize: 15) //文字font，除特殊情况外都是用这个

//MARK: - color
let HomePageDeviderColor = UIColor.init(red: 0.922, green: 0.922, blue: 0.922, alpha: 1)
//let VCBackGroundColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
let VCBackGroundColor = UIColor.init(red: 246/255.0, green: 247/255.0, blue: 249/255.0, alpha: 1)
let NavigationBarTintColor = UIColor.init(red: 255/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1)
let blueButtonColor = UIColor.init(red: 11/255.0, green: 88/255.0, blue: 189/255.0, alpha: 1)
let greenColor = UIColor.init(red: 71/255.0, green: 196/255.0, blue: 99/255.0, alpha: 1)
//主字体
let DefaultTextColor = UIColor(red: 66/255.0, green: 77/255.0, blue: 92/255.0, alpha: 1)
//灰色字体
let DefaultgreyColor = UIColor(red: 131/255.0, green: 142/255.0, blue: 156/255.0, alpha: 1)
//分割线颜色
let GrayLineColor = UIColor(red: 229/255.0, green: 232/255.0, blue: 235/255.0, alpha: 1)
/*
 *
 */
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let DefaultHUDTime: CGFloat = 2 //网络请求等提示性文字的默认显示时长


//存放于UserDefaults中的数据的key
let CookieKey = "CookieKey"
let GlobalUserDicKey = "GlobalUserDicKey"

//MARK: - URL
//MARK: 权限
let GetUserPurview = "api/MISApp/Login/GetUserPurview" //获取用户业务操作权限

//MARK: 审批相关api
let NewSubmit = "api/MISApp/Audit/NewSubmit" //提交申请（error返回：0-成功，1-失败，2-要先选择动态执行人）
let Audit = "api/MISApp/Audit/Audit" //流程审批（error返回：0-成功，1-失败，2-要先选择动态执行人，3-Content必须有值）

//MARK: 通知公告


//MARK: 登录
let apiLogin = "api/MISApp/Login/Login" //登录
let apiLogout = "api/MISApp/Login/Logout" //退出登录

//MARK:首页
let GetAuditList = "api/MISApp/Audit/GetAuditList" //获取审批列表
let GetSubmitList = "api/MISApp/Audit/GetSubmitList" //获取提交申请列表
let GetNoticeList = "api/MISApp/Notice/GetNoticeList" //获取通知公告列表
let GetMessageList = "api/MISApp/Notice/GetMessageList" //获取消息列表（首页）

//MARK: 请假
let GetLeaveList = "api/MISApp/Leave/GetLeaveList"//获取请假列表
let GetLeaveDetail = "api/MISApp/Leave/GetLeaveDetail"//获取请假详情
let EditLeave = "api/MISApp/Leave/EditLeave"//新增/修改请假申请
let UpdateLeaveCancel = "api/MISApp/Leave/UpdateLeaveCancel"//更新调休冲抵加班记录请求
let GetOverTimeCancel = "api/MISApp/Leave/GetOverTimeCancel"//获取可冲抵的加班记录
let GetOverTimeCancelInfo = "api/MISApp/Leave/GetOverTimeCancelInfo"//获取调休冲抵加班记录详情
let GetYearHoliday = "api/MISApp/Leave/GetYearHoliday"//获取员工年假

//MARK: 一些通用的api
let GetDept = "api/MISApp/Common2/GetDept"//获取部门列表
let GetOwnXL = "api/MISApp/Common2/GetOwnXL"//获取所属系列
let GetOrg = "api/MISApp/Common2/GetOrg"//获取公司列表
let GetSingleDeptUser = "api/MISApp/Common2/GetSingleDeptUser" //根据部门获取员工，不包含子部门的员工
let GetWorkTimeSpan = "api/MISApp/Common2/GetWorkTimeSpan" //获取工作日时间（小时）
let GetDictionary = "api/MISApp/Common2/GetDictionary" //获取请假类型、加班类型
let GetDeptUser = "api/MISApp/Common2/GetDeptUser" //获取部门员工（包含子部门的）
let GetItems = "api/MISApp/Common2/GetItems" //获取项目
let Delete = "api/MISApp/Common2/Delete" //删除记录


//MARK:加班
let GetOvertimeList = "api/MISApp/Overtime/GetOvertimeList" //获取加班列表
let GetOvertimeDetail = "api/MISApp/Overtime/GetOvertimeDetail" //获取加班详情
let EditOvertime = "api/MISApp/Overtime/EditOvertime" //新增/修改加班申请







