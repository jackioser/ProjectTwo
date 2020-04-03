//
//  DesignateVC.swift
//  misAppB
//
//  Created by jack on 2020/3/26.
//

import UIKit
class DesignateVC: UIViewController {

    @IBOutlet weak var dynauserFeild: UITextField!
    @IBOutlet weak var remark: UITextView!
    
    var idStr: String?//记录Id
    
    var dynaUser: String? //委派人
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func desingnateMan(_ sender: Any) {
        let vc = SelectVC.init(nibName: nil, bundle: nil, vcType: .approvalMan)
        vc.showText = "选择委派人"
        vc.didSelectEmployee = {[weak self] model in
            guard let strongSelf = self else { return }
            strongSelf.dynaUser = model.Id
            strongSelf.dynauserFeild.text = model.Name
        }
        presentBottom(vc, changeScale: false)
        
    }
    @IBAction func bottomDesignate(_ sender: Any) {
        HUDShow()
               let dic: [String: Any] = ["Type": 0,
                                       "RecordId": idStr ?? "",
                                       "DynaUser": "",
                                       "Content": "",
                                       "AuditType": 2,
                                       "WFDescription": remark.text as Any,
                                       "ToUser": dynaUser as Any,
                                       "WFMemo": ""
                                       ]
               AFNetWorkingTool.shared.post(urlString: Audit, parampeters: dic , success: { [weak self] (model) in
                   guard let strongSelf = self else { return }
                   strongSelf.HUDHide()
                   if model.error == 0 {
                       strongSelf.HUDShowWithText(text: "成功")
//                       if strongSelf.saveSuccessBlock != nil {
//                           strongSelf.saveSuccessBlock!()
//                       }
                   }else if model.error == 2{
                       strongSelf.HUDShowWithText(text: model.msg + "要先选择动态执行人")
                   }else if model.error == 3{
                       strongSelf.HUDShowWithText(text: model.msg + "Content必须有值")
                   }else{
                       strongSelf.HUDShowWithText(text: model.msg)
                   }
                   
               }) { [weak self] (error) in
                   guard let strongSelf = self else { return }
                   strongSelf.HUDHide()
                   strongSelf.HUDShowWithText(text: error.localizedDescription)
               }

    }
}
