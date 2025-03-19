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
    func didTapLike(at index: Int)
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
            
            photos = self.imagesListService.photos
            
            guard newCount > oldCount else { return }
            
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
    
    func didTapLike(at index: Int) {
        
        guard let view else { return }
        let photo = photos[index]
        
        view.showProgressHUD()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self
            else { return }
            
            DispatchQueue.main.async {
                self.view?.hideProgressHUD()
                
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    self.view?.updateLikeButton(at: index, isLiked: self.photos[index].isLiked)
                    print("✅ Обработка нажатия лайка прошла успешно")
                    
                case .failure:
                    print("❌ Ошибка лайка, photo.id: \(photo.id)")
                }
            }
        }
    }
}
