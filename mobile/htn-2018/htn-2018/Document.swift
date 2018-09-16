//
//  Document.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation

typealias JSONDict = [String : Any]

func convertTouchesToStrokesJSON(_ touches: [CanvasTouch]) -> [JSONDict] {
    var xArr = [Int]()
    var yArr = [Int]()
    var tArr = [Int]()
    
    var stokesArr = [JSONDict]()
    
    for touch in touches {
        xArr.append(Int(touch.point.x))
        yArr.append(Int(touch.point.y))
        tArr.append(Int(touch.time * 1000))
        
        if touch.type == .up {
            stokesArr.append(["x": xArr, "y": yArr, "t": tArr])
            xArr = []
            yArr = []
            tArr = []
        }
    }
    
    return stokesArr
}

class Document {
    
    enum Block {
        case Text(value: String)
        case Math(touches: [CanvasTouch])
        
        func jsonDict() -> JSONDict {
            switch self {
            case .Text(let text):
                 return ["type": "text", "data": text]
            case .Math(let touches):
                return [
                    "type": "math",
                    "width": 1080,
                    "height": 120,
                    "data": convertTouchesToStrokesJSON(touches)
                ]
            }
        }
    }
    
    var documentId: String? = nil
    var orderedBlocks: [Block]
    
    var isCreatedOnServer: Bool {
        return self.documentId != nil
    }
    
    init(id: String? = nil, orderedBlocks: [Document.Block]? = nil) {
        self.documentId = id
        
        if let blocks = orderedBlocks {
            self.orderedBlocks = blocks
        } else {
            self.orderedBlocks = []
        }
    }
    
    func append(block: Block) {
        self.orderedBlocks.append(block)
    }
    
    func deleteBlock(atIndex index: Int) {
        self.orderedBlocks.remove(at: index)
    }
}
