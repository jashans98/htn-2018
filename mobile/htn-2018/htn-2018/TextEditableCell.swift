//
//  TextEditableCell.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit

class TextEditableCell: BaseEditableCell, UITextViewDelegate {
    let textView = UITextView()
    
    override func commonInit() {
        super.commonInit()
        
        self.textView.delegate = self
    }
    
    override func getContentView() -> UIView {

        self.textView.isEditable = true
        self.textView.isSelectable = true
        self.textView.isScrollEnabled = false
        self.textView.isOpaque = true
        
        self.textView.textContainerInset = UIEdgeInsetsMake(
            Dimens.halfScreenPadding,
            Dimens.halfScreenPadding,
            Dimens.halfScreenPadding,
            Dimens.halfScreenPadding
        )
        
        self.addSubview(self.textView)
        
        self.textView.font = UIFont.systemFont(ofSize: Dimens.fontSizeBody)
        self.textView.backgroundColor = Colors.white
        
        return self.textView
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
    }
    
    override func getCellTypeString() -> String {
        return "Text"
    }
    
    override func preferredContentViewHeight() -> CGFloat? {
        return 173.0
    }
}
