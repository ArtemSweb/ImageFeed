//
//  Photo.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 16.03.2025.
//
import Foundation

private let dateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
}()

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageURL: String
    var isLiked: Bool
    
    init(photoResults: PhotoResult) {
        self.id = photoResults.id
        self.size = CGSize(width: photoResults.width, height: photoResults.height)
        self.createdAt = dateFormatter.date(from: photoResults.createdAt)
        self.welcomeDescription = photoResults.description
        self.thumbImageURL = photoResults.urls.thumb
        self.largeImageURL = photoResults.urls.regular
        self.fullImageURL = photoResults.urls.full
        self.isLiked = photoResults.likedByUser
    }
}
