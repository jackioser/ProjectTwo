//
//  GlobalInatance.swift
//  LogisticsQuery
//
//  Created by 苏奎 on 2019/7/1.
//  Copyright © 2019 苏奎. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON
import CommonCrypto

//MARK: - 全局对象
class GlobalInstance {
    static let shared: GlobalInstance = GlobalInstance()
    private init() {}

    var user: User?
    var userId: String {
        if user?.UserId?.count ?? 0 > 0 {
            return (user?.UserId)!
        }
        return ""
    }
}

//MARK: - 正则表达式
func validatePhone(phoneNumber: String?) -> Bool {
    if phoneNumber?.count ?? 0 > 0 {
        let str = "^1\\d{10}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", argumentArray: [str])
        return predicate.evaluate(with: phoneNumber)
    }
    return false
}

//MARK: - MD5
func md5(strAddress: inout String) -> String {
    let count: Int = Int(CC_MD5_DIGEST_LENGTH)
    let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
    bytes.initialize(repeating: 0, count: count)
    defer {
        bytes.deinitialize(count: count)
        bytes.deallocate()
    }
    CC_MD5(strAddress, CC_LONG(strAddress.count), bytes)
    var resultStr = String.init()
    for i in 0..<count {
        resultStr += String.init(format: "%02x", bytes[i])
    }
    return resultStr
}


//MARK: - 网络请求工具
class ResponseInfo: HandyJSON {
    var error: Int?//0=成功 1=失败,401=未登录，404=未找到，500=系统内部错误，其它=错误码
    var items: Any?
    var msg: String = "请求失败" //失败原因说明
    var total: Int? //数据总条数
    
    required init(){}
}

func api_host() -> String {
#if DEBUG
    return "http://114.55.30.124:11090/"
#else
    return "http://114.55.30.124:11090/"
#endif
}

class AFNetWorkingTool {
    static let shared: AFNetWorkingTool = AFNetWorkingTool()
    
    private init() {}
    
    lazy var MISSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager.init(configuration: configuration)
    }()
    
    func get(urlString: String, success: @escaping (ResponseInfo) -> Void, fail: @escaping (Error) -> Void) {
        Alamofire.request(urlString).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let reponseDic = value as? [String: Any], let responseInfo = ResponseInfo.deserialize(from: reponseDic) else {
                    let info = ResponseInfo()
                    info.error = 1
                    info.msg = "请求失败"
                    success(info)
                    return
                }
                success(responseInfo)
            case .failure(let error):
                fail(error)
            }
        }
    }
    
    //获取权限专用，其它接口不要使用该接口
    func purviewPost(urlString: String, parampeters: [String: Any]?, success: @escaping (ResponseInfo) -> Void, fail: @escaping (Error) -> Void) {
        precondition(!urlString.hasPrefix("http"), "urlString前面不要拼接地址")
        let url = api_host().appending(urlString)
        MISSessionManager.request(url, method: .post, parameters: parampeters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let reponseDic = value as? [String: Any], let responseInfo = ResponseInfo.deserialize(from: reponseDic) else {
                    let info = ResponseInfo()
                    info.error = 1
                    success(info)
                    return
                }
                success(responseInfo)
            case .failure(let error):
                if let urlError = error as? AFError, let code = urlError.responseCode, code == 401 {
                    AppDelegate.showRemindText(text: "请登录")
                    HTTPCookieStorage.shared.removeCookies(since: Date.init(timeIntervalSinceReferenceDate: 0))
                    NotificationCenter.default.post(name: Notification.Name.init("401errorOrLogOut"), object: nil)
                }else {
                    fail(error)
                }
            }
        }
    }

    func post(urlString: String, parampeters: [String: Any]?, success: @escaping (ResponseInfo) -> Void, fail: @escaping (Error) -> Void) {
        precondition(!urlString.hasPrefix("http"), "urlString前面不要拼接地址")
        let url = api_host().appending(urlString)
        Alamofire.request(url, method: .post, parameters: parampeters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    guard let reponseDic = value as? [String: Any], let responseInfo = ResponseInfo.deserialize(from: reponseDic) else {
                        let info = ResponseInfo()
                        info.error = 1
                        success(info)
                        return
                    }
                    success(responseInfo)
                case .failure(let error):
                    if let urlError = error as? AFError, let code = urlError.responseCode, code == 401 {
                        AppDelegate.showRemindText(text: "请登录")
                        HTTPCookieStorage.shared.removeCookies(since: Date.init(timeIntervalSinceReferenceDate: 0))
                        NotificationCenter.default.post(name: Notification.Name.init("401errorOrLogOut"), object: nil)
                    }else {
                        fail(error)
                    }
                }
        }
    }
}
