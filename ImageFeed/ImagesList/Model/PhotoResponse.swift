//
//  PhotoResponse.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 16.03.2025.
//

struct PhotoResponse: Codable {
    let photo: Photo
    
    struct Photo: Codable {
        let id: String
    }
}
