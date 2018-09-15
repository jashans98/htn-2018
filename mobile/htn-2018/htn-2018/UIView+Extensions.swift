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
        guard let superview = self.superview else {
            return
        }
        
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
