//
//  PresentBottom.swift
//  PresentBottom
//
//  Created by Isaac Pan on 2018/2/28.
//  Copyright © 2018年 Isaac Pan. All rights reserved.
//

import Foundation
import UIKit

public protocol PresentBottomVCProtocol {
    var controllerHeight: CGFloat {get}
}

///// a base class of vc to write bottom view
public class PresentBottomVC: UIViewController, PresentBottomVCProtocol {
    public var controllerHeight: CGFloat {
        return 0
    }
    //是否变小后面的vc
    var isChangeScale: Bool = true
    lazy var leftBtn = UIButton().then {
        $0.setImage(UIImage(named: "navLeftXX"), for: .normal)
        self.view.addSubview($0)
        $0.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.width.height.equalTo(25)
        }
    }
    lazy var rightBtn = UIButton().then {
        $0.setTitle("重置", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        self.view.addSubview($0)
        $0.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(self.leftBtn)
        }
    }
    lazy var topLine = UIView().then {
        $0.layer.cornerRadius = 4
//        $0.backgroundColor = DefaultgreyColor
        self.view.addSubview($0)
        $0.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(4)
            make.top.equalTo(6)
        }
    }
    lazy var titleLab = UILabel().then {
        $0.font = UIFont(name: "PingFangSC-Medium", size: 18)
        self.view.addSubview($0)
        $0.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.leftBtn)
        }
    }
    lazy var line1 = UIView().then { (line) in
        self.view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.leftBtn.snp_bottomMargin).offset(16)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
    lazy var searchBar = UISearchBar().then { (bar) in
        bar.placeholder = "请输入姓名"
        bar.backgroundColor = VCBackGroundColor
        bar.searchBarStyle = .minimal
        bar.delegate = self
        self.view.addSubview(bar)
        bar.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(70)
            make.top.equalTo(self.line1.snp_bottomMargin).offset(12)
        }
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentBottomShouldHide), name: NSNotification.Name(PresentBottomHideKey), object: nil)
        leftBtn.addTarget(self, action: #selector(presentBottomShouldHide), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        topLine.backgroundColor = DefaultgreyColor
        line1.backgroundColor = GrayLineColor
        
        
 // 左上和右上为圆角
        view.roundCorners(cornerRadius: 14, type: .top)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
            return
        }
        if isChangeScale {
            //后面的vc 缩小
            changeScaleVC(scale: 0.9)
        }
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if #available(iOS 13, *) {
            return
        }
        if isChangeScale {
            //后面的vc 变大
            changeScaleVC(scale:1.0)
        }
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(PresentBottomHideKey), object: nil)
    }
    
    @objc func presentBottomShouldHide() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func rightBtnClick() {
        
        
    }
    func changeScaleVC(scale: CGFloat) {
        if (self.navigationController != nil) {
            UIView.animate(withDuration: 0.25) {
                self.navigationController?.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }else{
            UIView.animate(withDuration: 0.25) {
                self.presentingViewController?.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
        }
    }
}

public let PresentBottomHideKey = "ShouldHidePresentBottom"
/// use an instance to show the transition
public class PresentBottom:UIPresentationController {
    
    /// black layer
    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sendHideNotification))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    /// value to control height of bottom view
    public var controllerHeight:CGFloat
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        //get height from an objec of PresentBottomVC class
        if case let vc as PresentBottomVC = presentedViewController {
            controllerHeight = vc.controllerHeight
        } else {
            controllerHeight = UIScreen.main.bounds.width
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /// add blackView to the container and let alpha animate to 1 when show transition will begin
    public override func presentationTransitionWillBegin() {
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
        }
    }
    
    /// let blackView's alpha animate to 0 when hide transition will begin.
    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    
    /// remove the blackView when hide transition end
    ///
    /// - Parameter completed: completed or no
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    /// define the frame of bottom view
    public override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
    }
    
    @objc func sendHideNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PresentBottomHideKey), object: nil)
    }
    
}
extension PresentBottomVC: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
// MARK: - add function to UIViewController to call easily
extension UIViewController: UIViewControllerTransitioningDelegate {
    
    /// function to show the bottom view
    ///
    /// - Parameter vc: class name of bottom view
    ///changeScale: 是否改变后边VC的大小
    public func presentBottom(_ vc: PresentBottomVC,  changeScale: Bool) {
        if #available(iOS 13, *) {
            if changeScale {
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    // function refers to UIViewControllerTransitioningDelegate
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = PresentBottom(presentedViewController: presented, presenting: presenting)
        return present
    }
}
