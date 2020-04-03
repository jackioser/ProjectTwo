//
//  ChooseDateView.swift
//  misAppB
//
//  Created by XLiu on 2020/3/18.
//

import UIKit

typealias dateBlock = (_ date:String) -> Void

class ChooseDateView: UIView, NibLoadable {

    let defualtHeight:CGFloat = 261
    var dateBack:dateBlock?
    @IBOutlet weak var datePickView: UIDatePicker!
    var dateType:UIDatePicker.Mode? {
        didSet {
            datePickView.datePickerMode = dateType ?? UIDatePicker.Mode.date
        }
    }
    
    var maxDate:Date? {
        didSet {
            datePickView.maximumDate = maxDate ?? Date()
        }
    }
    
    var minDate:Date? {
        didSet {
            datePickView.minimumDate = minDate
        }
    }
    
    var currentDate:Date? {
        didSet {
            datePickView.date = currentDate ?? Date()
        }
    }
    
    
    
    class func initView() ->ChooseDateView {
        return loadFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: defualtHeight)
        self.roundCorners(cornerRadius: 8, type: .top)
        footerView.addSubview(dismissBtn)
        footerView.addSubview(self)
    }
    
//    MARK:show && dismiss
    
    func show() {
        
        UIApplication.shared.keyWindow?.addSubview(footerView)
        UIView.animate(withDuration: 0.3) {
            self.footerView.alpha = 1
            self.frame = CGRect(x: 0, y: ScreenHeight-self.defualtHeight, width: ScreenWidth, height: self.defualtHeight)
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.footerView.alpha = 0
            self.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: self.defualtHeight)
        }) { (Bool) in
            self.footerView.removeFromSuperview()
        }
    }
    
//    MARK:Action
    
    @IBAction func sureAction(_ sender: UIButton) {
        let fmt = DateFormatter.init()
        switch dateType {
        case .date:
            fmt.dateFormat = "yyyy-MM-dd"
        case .time:
            fmt.dateFormat = "HH:mm"
        default:
            break
        }
        dateBack!(fmt.string(from: datePickView.date))
        dismiss()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss()
    }
    
//    MARK:Lazy
    lazy var footerView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.alpha = 0
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return view
    }()
       
    lazy var dismissBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - self.defualtHeight)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
}
