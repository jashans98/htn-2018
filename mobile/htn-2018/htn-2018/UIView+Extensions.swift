//
//  UIView+Extensions.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    func pinToSuperview() {
        guard self.superview != nil else {
            return
        }
        
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func roundCorners(withRadius radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func wrapStandardShadow() {
        guard let superview = self.superview else {
            return
        }
        
        let shadowView = UIView()
        
        superview.insertSubview(shadowView, belowSubview: self)
        
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = Colors.gray5.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = Dimens.shadowRadius
        shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.layer.cornerRadius
        ).cgPath
    }
}
