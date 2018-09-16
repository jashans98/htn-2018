//
//  CompileDocumentService.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-16.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import Alamofire

typealias CompileDocumentServiceCompletionBlock = (String) -> Void

class CompileDocumentService: BaseApiService {
    override func endPoint() -> String {
        return "convert/build/test.pdf"
    }
    
    var completionBlock: CompileDocumentServiceCompletionBlock?
    
    func requestService(document: Document, completionBlock: CompileDocumentServiceCompletionBlock? = nil) {
        let requestDict: JSONDict = [
            "blocks": document.orderedBlocks.map { $0.jsonDict() }
        ]
        
        self.completionBlock = completionBlock
        
        print("request payload: ")
        let data = try! JSONSerialization.data(withJSONObject: requestDict, options: .sortedKeys)
        let string = String.init(data: data, encoding: String.Encoding.utf8)!
        print(string)
        
        Alamofire.request(
            "http://172.20.10.4:5000/" + endPoint(),
            method: .post,
            parameters: requestDict,
            encoding: JSONEncoding.default,
            headers: nil
        ).responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                let jsonDict = JSON as! NSDictionary
                if let pdfUrl = jsonDict.object(forKey: "url") as? String {
                    self.completionBlock?(pdfUrl)
                }
            case .failure(let error):
                print("sad error: \(error)")
            }
        }
    }
}
