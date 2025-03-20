//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 18.03.2025.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterTests: XCTestCase {
    
    func testUpdateProfile(){
        //given
        let view = ProfileViewSpy()
        let presenter = ProfilePresenter(view: view)
        
        let profileResult = ProfileResult(username: "YP_student", firstName: "Artem", lastName: "logName", bio: "description")
        
        //when
        ProfileService.shared.profile = Profile(profileResult: profileResult)
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(view.updateProfileCalled)
    }
    
    func testUpdateAvatar(){
        //given
        let view = ProfileViewSpy()
        let presenter = ProfilePresenter(view: view)
        
        //when
        ProfileImageService.shared.avatarURL = "https://example.com/avatar.jpg"
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testexitButtonTapped(){
        //given
        let view = ProfileViewSpy()
        let presenter = ProfilePresenter(view: view)
        
        //when
        presenter.exitButtonTapped()
        
        //then
        XCTAssertTrue(view.showLogoutAlertCalled)
    }
}
