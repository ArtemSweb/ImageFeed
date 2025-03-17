//
//  UserProfileImage.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 15.03.2025.
//

struct UserProfileImage: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let large: String
}
