//
//  DrawingCanvasView.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import UIKit

struct CanvasTouch {
    enum Event {
        case up, down, move
    }
    
    let point: CGPoint
    let type: Event
}

class DrawingCanvasView: UIView {
    var drawColor: UIColor = Colors.gray2
    var lineWidth: CGFloat = 2.0
    
    var allPoints: [CanvasTouch] = []
    
    private var lastPoint: CGPoint!
    private var currentStrokeBezierPath: UIBezierPath!
    private var preRenderImage: UIImage!
    private var pointCounter: Int = 0
    private var pointLimit: Int = 32
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.currentStrokeBezierPath = UIBezierPath()
        self.currentStrokeBezierPath.lineJoinStyle = .round
        self.currentStrokeBezierPath.lineCapStyle = .round
    }
    
    func renderToImage() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        if self.preRenderImage != nil {
            self.preRenderImage.draw(in: self.bounds)
        }
        
        self.currentStrokeBezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        self.currentStrokeBezierPath.stroke()
        
        preRenderImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.preRenderImage != nil {
            self.preRenderImage.draw(in: self.bounds)
        }
        
        self.currentStrokeBezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        self.currentStrokeBezierPath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            touch.type == .stylus else {
                return
        }
        lastPoint = touch.location(in: self)
        pointCounter = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            touch.type == .stylus else {
                return
        }
        let newPoint = touch.location(in: self)
        
        currentStrokeBezierPath.move(to: lastPoint)
        currentStrokeBezierPath.addLine(to: newPoint)
        lastPoint = newPoint
        
        pointCounter += 1
        
        if pointCounter == pointLimit {
            pointCounter = 0
            renderToImage()
            setNeedsDisplay()
            currentStrokeBezierPath.removeAllPoints()
        }
        else {
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pointCounter = 0
        renderToImage()
        setNeedsDisplay()
        currentStrokeBezierPath.removeAllPoints()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    func clear() {
        preRenderImage = nil
        currentStrokeBezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    func hasLines() -> Bool {
        return preRenderImage != nil || !currentStrokeBezierPath.isEmpty
    }
}