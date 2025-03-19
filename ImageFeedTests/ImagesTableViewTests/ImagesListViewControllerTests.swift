//
//  ImagesListViewControllerTests.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {
    
    var sut: ImagesListViewController!
    var presenterSpy: ImagesListPresenterSpy!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as? ImagesListViewController else {
            XCTFail("Не удалось получить ImageListViewController из storyboard")
            return
        }
        
        sut = viewController
        presenterSpy = ImagesListPresenterSpy()
        sut.configure(presenterSpy)
        
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsPresenterViewDidLoad() {
        //given
        //when
        sut.viewDidLoad()
        
        //then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testUpdateTableViewAnimated() {
        //given
        let tableViewSpy = TableViewSpy()
        
        //when
        sut.setValue(tableViewSpy, forKey: "tableView")
        sut.updateTableViewAnimated(oldCount: 0, newCount: 3)
        
        //then
        XCTAssertTrue(tableViewSpy.insertRowsCalled)
        XCTAssertEqual(tableViewSpy.insertedIndexPaths, [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)])
    }
    
}
