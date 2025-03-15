//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 10.03.2025.
//
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageURL: String
    var isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case likes
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}

struct UrlsResult: Codable{
    let thumb: String
    let regular: String
    let full: String
}

//Экспериментальная структура для лайкаю, для дженерик варианта
struct PhotoResponse: Codable {
    let photo: Photo
    
    struct Photo: Codable {
        let id: String
    }
}
