//
//  LoginMainVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/26.
//

import UIKit

class LoginMainVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pswTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountTF.delegate = self
        self.pswTF.delegate = self
        self.accountTF.text = "admin"
        self.pswTF.text = "1"
        
//        self.accountTF.text = "limo"
//        self.pswTF.text = "123456"



    }

//    清除账号
    @IBAction func deleteAccountAction(_ sender: UIButton) {
        self.accountTF.text = nil
    }
    
//    隐藏密码
    @IBAction func hidePswAction(_ sender: UIButton) {
        self.pswTF.isSecureTextEntry = !self.pswTF.isSecureTextEntry;
    }
    
//    登录
    @IBAction func loginAction(_ sender: UIButton) {
        
        if self.accountTF.text?.count == 0 {
            HUDShowWithText(text: "请输入账号")
            return
        }
        if self.pswTF.text?.count == 0 {
            HUDShowWithText(text: "请输入密码")
            return
        }
        login()
    }
    
//    MARK:Network
    
    func login() {
        self.HUDShow()
        var psw = self.pswTF.text ?? ""
        let param : [String : String] = ["UserName":self.accountTF.text ?? "",
                                         "Password":md5(strAddress: &psw),
                                         "version":"iOS"]
        AFNetWorkingTool.shared.post(urlString: apiLogin, parampeters: param, success: { [weak self] (responseInfo) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
            if responseInfo.error == 0 {
                GlobalInstance.shared.user = User.deserialize(from: responseInfo.items as? [String:Any])
                strongSelf.dismiss(animated: true, completion: nil)
            } else {
                strongSelf.HUDShowWithText(text: responseInfo.msg)
            }
            
        }) { [weak self] (Error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDHide()
        }
    }
    
//    func getPurview() {
//        AFNetWorkingTool.shared.purviewPost(urlString: GetUserPurview, parampeters: <#T##[String : Any]?#>, success: <#T##(ResponseInfo) -> Void#>, fail: <#T##(Error) -> Void#>)
//    }
//
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
