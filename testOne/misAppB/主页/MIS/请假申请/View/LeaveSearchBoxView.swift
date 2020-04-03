//
//  LeaveSearchBoxView.swift
//  CheckSwift
//
//  Created by Mac on 20/2/26.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

class LeaveSearchBoxView: UICollectionReusableView {

    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bg.superview!.backgroundColor = VCBackGroundColor
        
    }
    
    
    @IBAction func cancelClick(sender: UIButton) {
        
        
    }

}
