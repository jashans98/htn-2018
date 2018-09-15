//
//  BaseApiService.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import Alamofire


class BaseApiService {
    
    private static let serverUrl = "https://localhost:8080/" // TODO: change this when the server is hosted
    var requestParameters: [String: Any] = [:]
    
    final func addParameter(_ value: Any, forKey key: String) {
        self.requestParameters[key] = value
    }
    
    final func startService() {
        guard let requestEndpoint = URL(string: BaseApiService.serverUrl + endPoint()) else {
            fatalError("invalid URL created for request")
        }
        
        Alamofire.request(requestEndpoint,
                          method: .post,
                          parameters: self.requestParameters).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let responseValue = response.result.value,
                let jsonDict = responseValue as? NSDictionary
            else {
                self.handleFailure()
                return
            }
            
            self.handleSuccess(jsonDict)
        }
    }
    
    func handleSuccess(_ jsonData: NSDictionary) {
        fatalError("Subclass of BaseApiService must implement handleSuccess(_:)")
    }
    
    func handleFailure() {
        // Subclass may override for special error handling
    }
    
    func endPoint() -> String {
        fatalError("subclass must provide endPoint()")
    }
}
