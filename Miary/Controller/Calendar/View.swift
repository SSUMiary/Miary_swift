//
//  View.swift
//  Miary
//
//  Created by 조병관 on 2018. 9. 2..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
    }

}
