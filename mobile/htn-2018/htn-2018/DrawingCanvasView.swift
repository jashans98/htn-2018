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
    enum Event: String {
        case up = "up"
        case down = "down"
        case move = "move"
    }
    
    let point: CGPoint
    let type: Event
    let time: TimeInterval
    
    func jsonDict() -> JSONDict {
        return [
            "width: ": 1080,
            "height": 120,
            "data": [
                "type": "move",
                "x": point.x,
                "y": point.y,
                "time": time
            ]
        ]
    }
}

class DrawingCanvasView: UIView {
    var drawColor: UIColor = Colors.gray2
    var lineWidth: CGFloat = 2.0
    
    var isDrawing: Bool = false
    
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
        
        self.backgroundColor = Colors.white
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
        
        guard let event = event else {
            return
        }
        
        self.isDrawing = true
        
        
        self.lastPoint = touch.location(in: self)
        self.allPoints.append(CanvasTouch(point: self.lastPoint, type: .down, time: event.timestamp))
        
        pointCounter = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            touch.type == .stylus else {
                return
        }
        let newPoint = touch.location(in: self)
        
        guard let event = event else {
            return
        }
        
        currentStrokeBezierPath.move(to: lastPoint)
        currentStrokeBezierPath.addLine(to: newPoint)
        lastPoint = newPoint
        
        self.allPoints.append(CanvasTouch(point: self.lastPoint, type: .move, time: event.timestamp))
        
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
        
        guard let event = event else {
            return
        }
        
        if let lastPoint = self.lastPoint {
            self.allPoints.append(CanvasTouch(point: lastPoint, type: .up, time: event.timestamp))
        } else if let lastPoint = self.allPoints.last?.point {
            self.allPoints.append(CanvasTouch(point: lastPoint, type: .up, time: event.timestamp))
        }
        
        self.isDrawing = false
    }
    
    func addPointStart(_ canvasPoint: CanvasTouch) {
        self.isDrawing = true
        
        
        self.lastPoint = canvasPoint.point
        self.allPoints.append(canvasPoint)
        
        pointCounter = 0
    }
    
    func addPointMove(_ canvasPoint: CanvasTouch) {
        currentStrokeBezierPath.move(to: lastPoint)
        currentStrokeBezierPath.addLine(to: canvasPoint.point)
        lastPoint = canvasPoint.point
        
        self.allPoints.append(canvasPoint)
        
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
    
    func addPointEnd(_ point: CanvasTouch) {
        self.allPoints.append(point)
        self.isDrawing = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // redraws the canvas from an array of canvas points
    func setupWithCanvasPoints(_ canvasPoints: [CanvasTouch]) {
        self.clear()
        for point in canvasPoints {
            switch point.type {
            case .down:
                self.addPointStart(point)
            case .move:
                self.addPointMove(point)
            case .up:
                self.addPointEnd(point)
            }
        }
    }
    
    func clear() {
        preRenderImage = nil
        currentStrokeBezierPath.removeAllPoints()
        setNeedsDisplay()
        self.allPoints = []
    }
    
    func hasLines() -> Bool {
        return preRenderImage != nil || !currentStrokeBezierPath.isEmpty
    }
}
