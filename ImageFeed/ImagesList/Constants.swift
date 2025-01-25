//
//  Constants.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.01.2025.
//
import UIKit

enum Constants {
    static let accessKey: String = "-dAHq51u5Is9hY_HYNx6VOF1hCubdOyy6eOtK4TEQbk"
    static let secretKey: String = "wARpB7j0qw0OrAIZ-a9iScf1pcLLmt1e6qAAwyu3ozc"
    static let redirectUri: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseIRL: URL = URL(string: "https://api.unsplash.com")!
}
