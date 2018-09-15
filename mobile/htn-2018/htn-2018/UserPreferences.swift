//
//  UserPreferences.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation

class UserPreferences {
    private struct Key {
        static let loggedIn = "isLoggedIn"
        static let userId = "userId"
    }
    
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Key.loggedIn)
    }
    
    static func setLoggedIn(_ loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: Key.loggedIn)
    }
    
    static func userId() -> String? {
        return UserDefaults.standard.string(forKey: Key.userId)
    }
    
    static func setUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: Key.userId)
    }
}
