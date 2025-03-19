//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//
import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    func viewDidLoad()
    func getPhoto(index: Int) -> Photo
    func willDisplayRow(at index: Int)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    private let imagesListService = ImagesListService.shared
    private var imageListViewControllerObserver: NSObjectProtocol?
    
    weak var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    var photosCount: Int {
            return photos.count
        }
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateTableViewAnimated()
        imagesListService.fetchPhotosNextPage()
    }
    
    
    //MARK: - вспомогательные методы
    func updateTableViewAnimated() {
        imageListViewControllerObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            
            guard let self else { return }
            
            let oldCount = self.photosCount
            let newCount = self.imagesListService.photos.count
            print("[presenter]: newCount: \(newCount), oldCount: \(oldCount)")
            photos = self.imagesListService.photos
            
            guard newCount > oldCount else { return }
            
            print("[presenter]: photos.count: \(photos.count)")
            
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func getPhoto(index: Int) -> Photo {
        return photos[index]
    }
    
    func willDisplayRow(at index: Int) {
            if index == photos.count - 1 {
                imagesListService.fetchPhotosNextPage()
            }
        }
}
