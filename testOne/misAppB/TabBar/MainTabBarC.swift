//
//  MainTabBarC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/26.
//

import UIKit

class MainTabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: UIControl.State.selected)
        
        addChildVC(childVC: MisMainVC(), title: "MIS", image: "TBar_MIS")
        addChildVC(childVC: WorkPlatformVC(), title: "工作台", image: "TBar_Work")
        addChildVC(childVC: MyMainVC(), title: "我", image: "TBar_Mine")
    }
    
    func addChildVC(childVC:UIViewController, title:String, image:String) -> Void {
        let nav : CustomNavigationController = CustomNavigationController(rootViewController: childVC)
        
        
//        let nav : CustomNavigationController = UINavigationController(rootViewController: childVC)
//        nav.navigationBar.backgroundColor = VCBackGroundColor
//        nav.navigationBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
//        nav.navigationBar.shadowImage = UIImage.init()
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = UIImage(named: image)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        nav.tabBarItem.selectedImage = UIImage(named: image + "_Selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: UIControl.State.selected)
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray], for: UIControl.State.normal)
        
        addChild(nav)
    }

    func customNaviC() -> UINavigationController {
        let naviC : UINavigationController!
        naviC = UINavigationController.init()
        naviC.navigationBar.backgroundColor = VCBackGroundColor
        return naviC
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
