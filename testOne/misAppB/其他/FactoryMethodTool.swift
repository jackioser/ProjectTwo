//
//  FactoryMethodTool.swift
//  misAppB
//
//  Created by jack on 2020/3/13.
//

import UIKit

/// 时间格式化
/// - Parameters:
///   - time: 请求下来的格式带T的
///   - formater: 需要转换成的格式字符串 类似:yyyy-MM-dd HH:mm:ss
func formatTime(time: String?, formater: String) -> String? {
    guard var str = time else {return ""}
    str = str.components(separatedBy: ".").first ?? str
    let timeStr = str.replacingOccurrences(of: "T", with: " ")
    let dateFormate = DateFormatter()
    dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
    guard let date = dateFormate.date(from: timeStr) else { return "" }
    dateFormate.dateFormat = formater
    return dateFormate.string(from: date)
}
func dateFromString(time: String?) -> Date? {
    guard let date = time else {return nil}
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm"
    return format.date(from: date)
}
extension UIView {
    enum cornerType {
        case all    //每个角
        case top    //上面两个角
        case bottom // 下面两个角
    }
    
    ///  设置view个个角的圆角
    /// - Parameters:
    ///   - cornerRadius: 圆角大小
    ///   - type: 圆角位置
    func roundCorners(cornerRadius: Double, type: cornerType) {
        if type == .all {
            self.layer.cornerRadius = CGFloat(cornerRadius)
            self.clipsToBounds = true
            return
        }
          if #available(iOS 11.0, *) {
            let corners: CACornerMask?
            switch type {
            case .top:
                corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            default:
                corners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
            self.layer.cornerRadius = CGFloat(cornerRadius)
            self.clipsToBounds = true
           self.layer.maskedCorners = corners!
          } else {
            let corners: UIRectCorner?
            switch type {
            case .top:
                corners = [.topLeft, .topRight]
            default:
                corners = [.bottomLeft, .bottomRight]
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = path.cgPath
           self.layer.mask = maskLayer
      }
     }
}
func setShadow(view:UIView,sColor:UIColor,offset:CGSize,
               opacity:Float,radius:CGFloat) {
    //设置阴影颜色
    view.layer.shadowColor = sColor.cgColor
    //设置透明度
    view.layer.shadowOpacity = opacity
    //设置阴影半径
    view.layer.shadowRadius = radius
    //设置阴影偏移量
    view.layer.shadowOffset = offset
}

