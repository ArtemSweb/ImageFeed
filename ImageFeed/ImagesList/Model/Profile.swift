//
//  Profile.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 16.03.2025.
//

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
