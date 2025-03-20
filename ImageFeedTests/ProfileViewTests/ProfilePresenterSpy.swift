//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//
import XCTest
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var viewDidLoadCalled = false
    var logoutButtonTappedCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func exitButtonTapped() {
        logoutButtonTappedCalled = true
    }
}
