//
//  ProfileViewControllerTests.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    
    func testLogoutButtonTap() {
        //given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        
        //when
        _ = viewController.view
        viewController.logoutButton.sendActions(for: .touchUpInside)
        
        //then
        XCTAssertTrue(presenter.logoutButtonTappedCalled)
    }
    
    func testUpdateLabelsInfo() {
        //given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        
        let (name, nickname, description) = ("name", "nickname", "description")
        
        //when
        _ = viewController.view
        viewController.updateProfile(name: name, nickname: nickname, description: description)
        
        //then
        XCTAssertEqual(viewController.nameLabel.text, name)
        XCTAssertEqual(viewController.nicknameLabel.text, nickname)
        XCTAssertEqual(viewController.descriptionLabel.text, description)
    }
    
    func testProfileViewControllerCallsViewDidLoad() {
        //given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
}
