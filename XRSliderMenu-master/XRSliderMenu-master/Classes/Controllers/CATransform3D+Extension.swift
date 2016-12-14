
//
//  CATransform3D+Extension.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/12/9.
//  Copyright © 2016年 X.R. All rights reserved.
//

import Foundation
import UIKit

extension CATransform3D {

    fileprivate static func makePerspectiveTransform3D(center: CGPoint, distence: CGFloat) -> CATransform3D {
        
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
        let transBack = CATransform3DMakeTranslation(center.x, center.y, 0)
        var scaleTrans = CATransform3DIdentity
        scaleTrans.m34 = -1.0 / distence
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scaleTrans), transBack)
    }
    
    static func makePerspectTransform3D(t: CATransform3D, center: CGPoint, distence: CGFloat) -> CATransform3D {
        return CATransform3DConcat(t, makePerspectiveTransform3D(center: center, distence: distence))
    }
    
}


