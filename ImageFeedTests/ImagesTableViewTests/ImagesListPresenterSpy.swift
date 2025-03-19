//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//
import XCTest
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    
    
    var viewDidLoadCalled = false
    var didTapLikeCalled = false
    var photosCount: Int {
        return 1
    }
    
    func getPhoto(index: Int) -> Photo {
        return Photo(
            photoResults: PhotoResult(
                id: "1",
                createdAt: "22-03-2025",
                width: 123,
                height: 123,
                likes: 1,
                likedByUser: true,
                description: nil,
                urls: UrlsResult(
                    thumb: "https://213.com/pic1.jpg",
                    regular: "https://213.com/pic2.jpg",
                    full: "https://213.com/pic3.jpg")))
    }
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func willDisplayRow(at index: Int) {}
    
    func didTapLike(at index: Int) {
        didTapLikeCalled = true
    }
}

final class TableViewSpy: UITableView {
    
    var insertRowsCalled = false
    var insertedIndexPaths: [IndexPath] = []
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        insertRowsCalled = true
        insertedIndexPaths = indexPaths
    }
    
    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        updates?()
        completion?(true)
    }
}
