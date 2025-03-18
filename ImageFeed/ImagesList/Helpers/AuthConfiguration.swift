//
//  Constants.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.01.2025.
//
import Foundation

enum Constants {
    static let accessKey: String = "-dAHq51u5Is9hY_HYNx6VOF1hCubdOyy6eOtK4TEQbk"
    static let secretKey: String = "wARpB7j0qw0OrAIZ-a9iScf1pcLLmt1e6qAAwyu3ozc"
    static let redirectUri: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
    static let baseURL: String = "https://unsplash.com/oauth/token"
    static let unsplashAuthorizeURLString =
    "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let baseURL: String
    let authURLString: String
    
    init(
        accessKey: String, secretKey: String, redirectURI: String,
        accessScope: String, authURLString: String, defaultBaseURL: URL,
        baseURL: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.baseURL = baseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectUri,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURL: Constants.defaultBaseURL,
            baseURL: Constants.baseURL)
        
    }
}
