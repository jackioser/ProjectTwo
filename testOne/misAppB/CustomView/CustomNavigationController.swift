//
//  CustomNavigationController.swift
//  misAppB
//
//  Created by XLiu on 2020/2/28.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroudView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 100))
        backgroudView.backgroundColor = VCBackGroundColor
        
        self.navigationBar.shadowImage = UIImage.init()
        self.navigationBar.setBackgroundImage(getViewScreenshot(view: backgroudView), for: UIBarMetrics.default)
    }
    
    func getViewScreenshot(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
