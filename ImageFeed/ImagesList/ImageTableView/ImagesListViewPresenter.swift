//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.03.2025.
//
import Foundation



public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
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
        print("[ImagesListViewPresenter] viewDidLoad() [START]")
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
            photos = self.imagesListService.photos
            
            guard newCount > oldCount else { return }
            
            let newPhotos = photos.suffix(from: oldCount)
            self.photos.append(contentsOf: newPhotos)
            
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
}
