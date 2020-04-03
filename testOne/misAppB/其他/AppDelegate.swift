//
//  AppDelegate.swift
//  misAppB
//
//  Created by 苏奎 on 2019/12/27.
//

import UIKit
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        UIViewController.methodSwizzle()
        UINavigationController.methodSwizzle()
        
        window?.rootViewController = MainTabBarC()
        window?.makeKeyAndVisible()
        
        
        let vc = LoginMainVC()
        vc.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(vc, animated: true, completion: nil)
        
        return true
    }

    
    //MARK: - 加载动画
    class func showRemindText(text: String) {
        guard let view = UIApplication.shared.keyWindow else { return }
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
        HUD.hide(animated: true, afterDelay: 2)
        HUD.completionBlock = {
            view.isUserInteractionEnabled = true
        }
    }
    
    class func HUDShow() {
        guard let view = UIApplication.shared.keyWindow else { return }
        let HUD = MBProgressHUD.showAdded(to: view, animated: true)
        HUD.mode = .indeterminate
        HUD.removeFromSuperViewOnHide = true
        HUD.contentColor = UIColor.white
        HUD.bezelView.color = UIColor.black
        HUD.isUserInteractionEnabled = false
    }
    
    func HUDHide() {
        guard let view = UIApplication.shared.keyWindow else { return }
        MBProgressHUD.hide(for: view, animated: true)
        view.isUserInteractionEnabled = true
    }
}

