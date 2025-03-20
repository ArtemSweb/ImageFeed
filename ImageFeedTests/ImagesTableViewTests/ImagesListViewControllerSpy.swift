//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//
import XCTest 
@testable import ImageFeed

final class ImagesListViewSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    var updateTableAnimatedCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableAnimatedCalled = true
    }
    
    func hideProgressHUD() {
        hideLoadingCalled = true
    }
    
    func showProgressHUD() {
        showLoadingCalled = true
    }
    
    func updateLikeButton(at index: Int, isLiked: Bool) {
    }
}


final class ImagesListServiceStub: ImagesListServiceProtocol {

    var fetchNextPageCalled = false
    var changeLikeCalled = false
    var shouldFailOnChangeLike = false

    var photos: [Photo] = [
        Photo(
            photoResults: PhotoResult(
                id: "01",
                createdAt: "22-01-2025",
                width: 123,
                height: 123,
                likes: 1,
                likedByUser: true,
                description: nil,
                urls: UrlsResult(
                    thumb: "https://213.com/pic1.jpg",
                    regular: "https://213.com/pic2.jpg",
                    full: "https://213.com/pic3.jpg"))),
        Photo(
            photoResults: PhotoResult(
                id: "02",
                createdAt: "13-08-1989",
                width: 312,
                height: 312,
                likes: 13,
                likedByUser: false,
                description: "text",
                urls: UrlsResult(
                    thumb: "https://bestwebsite.com/pic1.jpg",
                    regular: "https://bestwebsite.com/pic2.jpg",
                    full: "https://bestwebsite.com/pic3.jpg")))
    ]

    func fetchPhotosNextPage() {
        fetchNextPageCalled = true
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true

        if shouldFailOnChangeLike {
            completion(.failure(NSError(domain: "Test", code: 0)))
        } else {
            completion(.success(()))
        }
    }
}
