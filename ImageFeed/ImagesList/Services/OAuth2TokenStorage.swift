//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.02.2025.
//

import UIKit

final class OAuth2TokenStorage {
    private let bearerTokenKey = "BearerToken"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: bearerTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: bearerTokenKey)
        }
    }
}
