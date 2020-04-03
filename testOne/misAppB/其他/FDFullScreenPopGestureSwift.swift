 //
//  FDFullScreenPopGestureSwift.swift
//  FDFullScreenPopGestureSwift
//
//  Created by MinLison on 2017/4/10.
//  Copyright © 2017年 MinLiSon. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol MethodSizzle {
    static func methodSwizzle()
}

protocol HeaderRefresh {
    var isRefreshing: Bool { get set }
}

/// runtime key
fileprivate struct RuntimeKey {
//    static let fullscreenPopGestureKey = UnsafeRawPointer.init(bitPattern: "fullscreenPopGestureKey".hashValue)
//    static let viewControllerBasedNavigationBarAppearanceEnabledKey = UnsafeRawPointer.init(bitPattern: "viewControllerBasedNavigationBarAppearanceEnabledKey".hashValue)
//    static let interactivePopDisabledKey = UnsafeRawPointer.init(bitPattern: "interactivePopDisabledKey".hashValue)
//    static let prefersNavigationBarHiddenKey = UnsafeRawPointer.init(bitPattern: "prefersNavigationBarHiddenKey".hashValue)
//    static let interactivePopMaxAllowedInitialDistanceToLeftEdgeKey = UnsafeRawPointer.init(bitPattern: "interactivePopMaxAllowedInitialDistanceToLeftEdg".hashValue)
//    static let willAppearInjectBlockKey = UnsafeRawPointer.init(bitPattern: "willAppearInjectBlockKey".hashValue)
//    static let popGestureRecognizerDelegateKey = UnsafeRawPointer.init(bitPattern: "popGestureRecognizerDelegateKey".hashValue)
//    static let fullscreenPopGestureKey: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
    static let fullscreenPopGestureKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "fullscreenPopGestureKey")
        return ptr
    }()
    static let viewControllerBasedNavigationBarAppearanceEnabledKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "viewControllerBasedNavigationBarAppearanceEnabledKey")
        return ptr
    }()
    static let interactivePopDisabledKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "interactivePopDisabledKey")
        return ptr
    }()
    static let prefersNavigationBarHiddenKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "prefersNavigationBarHiddenKey")
        return ptr
    }()
    static let interactivePopMaxAllowedInitialDistanceToLeftEdgeKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "interactivePopMaxAllowedInitialDistanceToLeftEdgeKey")
        return ptr
    }()
    static let willAppearInjectBlockKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "willAppearInjectBlockKey")
        return ptr
    }()
    static let popGestureRecognizerDelegateKey: UnsafeMutablePointer<String> = {
        let ptr: UnsafeMutablePointer<String> = UnsafeMutablePointer.allocate(capacity: 1)
        ptr.initialize(to: "popGestureRecognizerDelegateKey")
        return ptr
    }()
    
}

//// 替换 FDFullScreenPopGesture 原有的 method_change 方法
//protocol FDFullScreenPopGestureNav {
//    func fd_pushViewController(_ viewController: UIViewController, animated: Bool)
//}
//// 替换 FDFullScreenPopGesture 原有的 method_change 方法
//protocol FDFullScreenPopGestureVC {
//    func fd_viewWillAppear(_ animation: Bool)
//}
//// 替换 FDFullScreenPopGesture 原有的 method_change 方法
//protocol FDFullScreenPopGestureSwift : FDFullScreenPopGestureNav, FDFullScreenPopGestureVC{}

extension UINavigationController : UIGestureRecognizerDelegate  {
	
	/// The gesture recognizer that actually handles interactive pop.
    
    override class func methodSwizzle() {
        guard let rawMethod = class_getInstanceMethod(self, #selector(pushViewController(_:animated:))) else {
            return
        }
        guard let swizzleMethod = class_getInstanceMethod(self, #selector(fd_pushViewController(_:animated:))) else {
            return
        }
        if class_addMethod(self, #selector(fd_pushViewController(_:animated:)), method_getImplementation(rawMethod), method_getTypeEncoding(rawMethod)) {
            class_replaceMethod(self, #selector(pushViewController(_:animated:)), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod))
        }else {
            method_exchangeImplementations(rawMethod, swizzleMethod)
        }
    }
    
	
	var fullscreenPopGestureRecognizer : UIPanGestureRecognizer {
		
		guard let obj = objc_getAssociatedObject(self, RuntimeKey.fullscreenPopGestureKey) as? UIPanGestureRecognizer else {
			
			let gesture = UIPanGestureRecognizer()
			gesture.maximumNumberOfTouches = 1
			objc_setAssociatedObject(self, RuntimeKey.fullscreenPopGestureKey, gesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			
			return gesture
		}
		
		return obj
	}
	
	/// A view controller is able to control navigation bar's appearance by itself,
	/// rather than a global way, checking "fd_prefersNavigationBarHidden" property.
	/// Default to YES, disable it if you don't want so.
	var viewControllerBasedNavigationBarAppearanceEnabled : Bool {
		get {
			guard let obj = objc_getAssociatedObject(self, RuntimeKey.viewControllerBasedNavigationBarAppearanceEnabledKey) as? Bool else {
				self.viewControllerBasedNavigationBarAppearanceEnabled = true
				return true
			}
			return obj
		}
		set {
			objc_setAssociatedObject(self, RuntimeKey.viewControllerBasedNavigationBarAppearanceEnabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
	
	
	private var popGestureRecognizerDelegate: FullscreenPopGestureRecognizerDelegate {
		get {
			guard let obj = objc_getAssociatedObject(self, RuntimeKey.popGestureRecognizerDelegateKey) as? FullscreenPopGestureRecognizerDelegate else {
				let newValue = FullscreenPopGestureRecognizerDelegate()
				newValue.navigationController = self
				objc_setAssociatedObject(self, RuntimeKey.popGestureRecognizerDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
				return newValue
			}
			return obj
		}
	}
	
	/// MARK: - Must call
	@objc func fd_pushViewController(_ viewController: UIViewController, animated: Bool) {
		if interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(fullscreenPopGestureRecognizer) == false {
			
			interactivePopGestureRecognizer?.view?.addGestureRecognizer(fullscreenPopGestureRecognizer)
			
			let internalTargets = interactivePopGestureRecognizer?.value(forKey: "targets") as? Array<NSObject>
			let internalTarget = internalTargets?.first?.value(forKey: "target")
			let internalAction = NSSelectorFromString("handleNavigationTransition:")
			if internalTarget != nil  {
				fullscreenPopGestureRecognizer.delegate = popGestureRecognizerDelegate
				fullscreenPopGestureRecognizer.addTarget(internalTarget!, action: internalAction)
				interactivePopGestureRecognizer?.isEnabled = false
			}
		}
		
		setupViewControllerBasedNavigationBarAppearanceIfNeeded(viewController)
        fd_pushViewController(viewController, animated: animated)
	}
	
	func setupViewControllerBasedNavigationBarAppearanceIfNeeded(_ appearingVC: UIViewController) {
		if !viewControllerBasedNavigationBarAppearanceEnabled {
			return
		}
		let block : FDViewControllerWillAppearInjectBlock = { [weak self] (vc:UIViewController,animation:Bool) in
			self?.setNavigationBarHidden(vc.prefersNavigationBarHidden, animated: animation)
		}
		appearingVC.willAppearInjectBlock = block
		let disappearVC = viewControllers.last
		if disappearVC != nil && disappearVC?.willAppearInjectBlock != nil {
			disappearVC?.willAppearInjectBlock = block
		}
	}

}

extension UIViewController : MethodSizzle {
    
    @objc class func methodSwizzle() {
        //viewWillAppear
        guard let rawMethod = class_getInstanceMethod(self, #selector(viewWillAppear(_:))) else {
            return
        }
        guard let swizzleMehod = class_getInstanceMethod(self, #selector(fd_viewWillAppear(_:))) else {
            return
        }
        if class_addMethod(self, #selector(fd_viewWillAppear(_:)), method_getImplementation(rawMethod), method_getTypeEncoding(rawMethod)) {
            class_replaceMethod(self, #selector(viewWillAppear(_:)), method_getImplementation(swizzleMehod), method_getTypeEncoding(swizzleMehod))
        }else {
            method_exchangeImplementations(rawMethod, swizzleMehod)
        }
        
        //viewDidLoad
        guard let rawLoad = class_getInstanceMethod(self, #selector(viewDidLoad)) else {
            return
        }
        guard let swizzleLoad = class_getInstanceMethod(self, #selector(fd_viewDidLoad)) else {
            return
        }
        if class_addMethod(self, #selector(fd_viewDidLoad), method_getImplementation(rawLoad), method_getTypeEncoding(rawLoad)) {
            class_replaceMethod(self, #selector(viewDidLoad), method_getImplementation(swizzleLoad), method_getTypeEncoding(swizzleLoad))
        }else {
            method_exchangeImplementations(rawLoad, swizzleLoad)
        }
    }
	
	// 替换 FDFullScreenPopGesture 原有的 method_change 方法
	@objc func fd_viewWillAppear(_ animation: Bool) {
        fd_viewWillAppear(animation)
		if willAppearInjectBlock != nil {
			willAppearInjectBlock!(self,animation)
		}
	}
    
    @objc func fd_viewDidLoad() {
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "navBackArrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(leftAction))
        fd_viewDidLoad()
    }
    
    @objc func leftAction(){
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        }else if presentingViewController != nil {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    func topHeight() -> CGFloat {
        return statusBarHeight() + (navigationController?.navigationBar.frame.size.height ?? 0)
    }
    
    func HUDShow() {
        view.isUserInteractionEnabled = false
        let HUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.mode = .indeterminate
        HUD.removeFromSuperViewOnHide = true
        HUD.contentColor = UIColor.white
        HUD.bezelView.color = UIColor.black
        HUD.isUserInteractionEnabled = false
    }
    
    func HUDShowWithTextLongTime(text: String) {
        view.isUserInteractionEnabled = false
        let HUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.mode = .indeterminate
        HUD.removeFromSuperViewOnHide = true
        HUD.label.text = text
        HUD.label.font = GlobalFont
        HUD.label.textColor = UIColor.lightGray
        HUD.contentColor = UIColor.white
        HUD.bezelView.color = UIColor.black
        HUD.isUserInteractionEnabled = false
    }
    
    func HUDShowWithText(text: String, time: CGFloat = DefaultHUDTime) {
        view.isUserInteractionEnabled = false
        let HUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.mode = .text
        HUD.removeFromSuperViewOnHide = true
        HUD.detailsLabel.text = text
        HUD.detailsLabel.font = GlobalFont
        HUD.detailsLabel.textColor = UIColor.lightGray
        HUD.contentColor = UIColor.white
        HUD.bezelView.color = UIColor.black
        HUD.isUserInteractionEnabled = false
        HUD.hide(animated: true, afterDelay: Double(time))
        HUD.completionBlock = {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.isUserInteractionEnabled = true
        }
    }
    
    func HUDHide() {
        MBProgressHUD.hide(for: view, animated: true)
        view.isUserInteractionEnabled = true
    }

	/// Whether the interactive pop gesture is disabled when contained in a navigation
	/// stack.
	var interactivePopDisabled : Bool {
		get {
			guard let obj = objc_getAssociatedObject(self, RuntimeKey.interactivePopDisabledKey) as? Bool else {
				return false
			}
			return obj
		}
		set {
			objc_setAssociatedObject(self, RuntimeKey.interactivePopDisabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
	
	/// Indicate this view controller prefers its navigation bar hidden or not,
	/// checked when view controller based navigation bar's appearance is enabled.
	/// Default to NO, bars are more likely to show.
	var prefersNavigationBarHidden : Bool {
		get {
			guard let obj = objc_getAssociatedObject(self, RuntimeKey.prefersNavigationBarHiddenKey) as? Bool else {
				return false
			}
			return obj
		}
		set {
			objc_setAssociatedObject(self, RuntimeKey.prefersNavigationBarHiddenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
	
	/// Max allowed initial distance to left edge when you begin the interactive pop
	/// gesture. 0 by default, which means it will ignore this limit.
	var interactivePopMaxAllowedInitialDistanceToLeftEdge : Float {
		get {
			guard let obj = objc_getAssociatedObject(self, RuntimeKey.interactivePopMaxAllowedInitialDistanceToLeftEdgeKey) as? Float else {
				return 0.0
			}
			return obj
		}
		set {
			objc_setAssociatedObject(self, RuntimeKey.interactivePopMaxAllowedInitialDistanceToLeftEdgeKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
	}
	
	fileprivate typealias FDViewControllerWillAppearInjectBlock = (_ vc: UIViewController, _ animated: Bool) -> Void
	
	fileprivate var willAppearInjectBlock : FDViewControllerWillAppearInjectBlock? {
		get {
			return objc_getAssociatedObject(self, RuntimeKey.willAppearInjectBlockKey) as? FDViewControllerWillAppearInjectBlock
		}
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(self, RuntimeKey.willAppearInjectBlockKey, newValue, .OBJC_ASSOCIATION_COPY)
			}
		}
	}
}

private class FullscreenPopGestureRecognizerDelegate : NSObject, UIGestureRecognizerDelegate {
	
	var navigationController : UINavigationController?
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		
		guard let navigationController = navigationController else {
			return false
		}
		
		guard navigationController.viewControllers.count > 1, let topViewController = navigationController.viewControllers.last else {
			return false
		}
		
		guard topViewController.interactivePopDisabled == false else {
			return false
		}
		
		let beginingLocation = gestureRecognizer.location(in: gestureRecognizer.view)
		let maxAllowedInitialDistance = topViewController.interactivePopMaxAllowedInitialDistanceToLeftEdge;
		
		if maxAllowedInitialDistance > 0 && Float(beginingLocation.x) > maxAllowedInitialDistance {
			return false
		}
		
		guard let trasition = navigationController.value(forKey: "_isTransitioning") as? Bool else {
			return false
		}
		
		guard trasition == false, let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
			return false
		}
		
		let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
		if translation.x <= 0 {
			return false
		}
		
		return true
	}
}
