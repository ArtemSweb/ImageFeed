//
//  ImagesListPresenterTests.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//

import XCTest
@testable import ImageFeed

final class ImagesListPresenterTests: XCTestCase {

    var presenter: ImagesListViewPresenter!
    var view: ImagesListViewSpy!
    var imagesListService: ImagesListServiceStub!

    override func setUp() {
        super.setUp()
        view = ImagesListViewSpy()
        imagesListService = ImagesListServiceStub()
        presenter = ImagesListViewPresenter(view: view, service: imagesListService)
    }

    override func tearDown() {
        presenter = nil
        view = nil
        imagesListService = nil
        super.tearDown()
    }

    func testFetchesNextPage() {
        //given
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(imagesListService.fetchNextPageCalled)
    }

    func testDidTapLike() {
        //given
        //when
        presenter.viewDidLoad()
        presenter.didTapLike(at: 0)

        //then
        XCTAssertTrue(imagesListService.changeLikeCalled)
        XCTAssertTrue(view.updateTableAnimatedCalled)
    }
    
    func testShowsAndHidesLoading() {
        //given
        //when
        presenter.viewDidLoad()
        presenter.didTapLike(at: 0)
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        
        //then
        XCTAssertTrue(view.showLoadingCalled)
        XCTAssertTrue(view.hideLoadingCalled)
    }
}
