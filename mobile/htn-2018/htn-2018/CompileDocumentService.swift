//
//  CompileDocumentService.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-16.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import Alamofire

class CompileDocumentService: BaseApiService {
    override func endPoint() -> String {
        return "convert/build"
    }
    
    func requestService(document: Document) {
        let requestDict: JSONDict = [
            "blocks": document.orderedBlocks.map { $0.jsonDict() }
        ]
        
        print("request payload: ")
        let data = try! JSONSerialization.data(withJSONObject: requestDict, options: .sortedKeys)
        let string = String.init(data: data, encoding: String.Encoding.utf8)!
        print(string)
        
        Alamofire.request(
            "http://localhost:5000/",
            method: .post, parameters:
            requestDict,
            encoding: JSONEncoding.default,
            headers: nil
        )
    }
}
