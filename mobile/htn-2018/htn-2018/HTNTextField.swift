//
//  HTNTextField.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import UIKit

class HTNTextField: UITextField {
    private static let insets = UIEdgeInsetsMake(
        Dimens.halfScreenPadding,
        Dimens.halfScreenPadding,
        Dimens.halfScreenPadding,
        Dimens.halfScreenPadding
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, HTNTextField.insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, HTNTextField.insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, HTNTextField.insets)
    }
}
