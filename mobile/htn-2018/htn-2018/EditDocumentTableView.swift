//
//  EditDocumentTableView.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import UIKit

class EditDocumentTableView: UITableView {
    override func touchesShouldBegin(_ touches: Set<UITouch>,
                                     with event: UIEvent?,
                                     in view: UIView) -> Bool {
        if view is DrawingCanvasView,
            let touch = touches.first,
            touch.type == .stylus {
            view.becomeFirstResponder()
            return true
        }
        return super.touchesShouldBegin(touches, with: event, in: view)
    }
    
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if let drawingCanvasView = view as? DrawingCanvasView,
            drawingCanvasView.isDrawing {
            return false
        }
        return true
    }
}
