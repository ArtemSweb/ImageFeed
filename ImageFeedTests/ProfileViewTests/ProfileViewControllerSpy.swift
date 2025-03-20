//
//  ProfileViewSpy.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 18.03.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileViewSpy: ProfileViewControllerProtocol {

    var updateProfileCalled = false
    var updateAvatarCalled = false
    var showLogoutAlertCalled = false
    
    var receivedName: String?
    var receivedLogin: String?
    var receivedBio: String?
    var receivedAvatarURL: URL?
    
    func updateProfile(name: String, nickname: String, description: String) {
        updateProfileCalled = true
        receivedName = name
        receivedLogin = nickname
        receivedBio = description
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
        receivedAvatarURL = url
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}
