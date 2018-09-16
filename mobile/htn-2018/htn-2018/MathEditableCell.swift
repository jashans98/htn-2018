//
//  MathEditableCell.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit

class MathEditableCell: BaseEditableCell {
    
    private static let mathEditableAreaHeight: CGFloat = 120.0
    
    let drawingCanvasView = DrawingCanvasView()
    
    override func getContentView() -> UIView {
        let wrapperView = UIView()
        wrapperView.addSubview(self.drawingCanvasView)
        self.drawingCanvasView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(MathEditableCell.mathEditableAreaHeight)
        }
        
        return wrapperView
    }
    
    override func getCellTypeString() -> String {
        return "Math"
    }
    
    override func preferredContentViewHeight() -> CGFloat? {
        return MathEditableCell.mathEditableAreaHeight
    }
}
