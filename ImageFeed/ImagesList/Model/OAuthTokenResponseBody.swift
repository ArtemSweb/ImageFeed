//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.02.2025.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
