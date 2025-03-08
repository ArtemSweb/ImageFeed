//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.02.2025.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let bearerTokenKey = "BearerToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: bearerTokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: bearerTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: bearerTokenKey)
            }
        }
    }
}
