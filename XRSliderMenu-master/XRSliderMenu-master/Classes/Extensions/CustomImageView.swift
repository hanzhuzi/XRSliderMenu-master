//
//  CustomImageView.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/12/14.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit


@IBDesignable
class CustomImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        
        didSet {
            layer.masksToBounds = cornerRadius > 0.0
            layer.cornerRadius = cornerRadius
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
