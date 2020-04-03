//
//  MJRefresh+ScrollView.swift
//  misAppB
//
//  Created by jack on 2020/3/11.
//

import UIKit
import MJRefresh

extension UIScrollView {
    
     func setHeaderWithTarget(target: AnyObject, action: Selector) {
           let header = MJRefreshNormalHeader.init(refreshingTarget: target, refreshingAction: action)
           header?.isAutomaticallyChangeAlpha = true
           header?.lastUpdatedTimeLabel.isHidden = true
           mj_header = header
       }
       
       func setFooterWithTarget(target: AnyObject, action: Selector) {
           let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: target, refreshingAction: action)
           mj_footer = footer
           mj_footer.isHidden = true
           guard let table = self as? UITableView else {
               return
           }
           table.estimatedRowHeight = 0
           table.estimatedSectionFooterHeight = 0
           table.estimatedSectionHeaderHeight = 0
       }
    
}
