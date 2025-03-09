//
//  ProfileResponse.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 01.03.2025.
//

//profile
struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespaces)
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

//profile image
struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let large: String
}
