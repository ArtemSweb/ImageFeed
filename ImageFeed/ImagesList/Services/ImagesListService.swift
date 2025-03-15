//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 10.03.2025.
//
import Foundation

final class ImagesListService {
    
    private let storage = OAuth2TokenStorage()
    
    static let shared = ImagesListService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    private(set) var photos: [Photo] = []
    private var loadingPage = 1
    private let constPhotoPerPage: Int = 10
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        guard let token = storage.token else {
            return
        }
        
        guard let request = createRequest(token: token) else {
            print("❌ Некорректный request")
            return
        }
        
        print("Загрузка страницы \(loadingPage)")
        
        let task = urlSession.dataTask(with: request) { [weak self] data, _, error in
            guard
                let self = self,
                let data = data,
                error == nil,
                let photoResults = try? JSONDecoder().decode([PhotoResult].self, from: data)
            else {
                print("❌ Ошибка декодирования данных")
                return
            }
            let newPhotos = photoResults.map {
                Photo(
                    id: $0.id,
                    size: CGSize(width: $0.width, height: $0.height),
                    createdAt: self.dateFormatter.date(from: $0.createdAt),
                    welcomeDescription: $0.description,
                    thumbImageURL: $0.urls.thumb,
                    largeImageURL: $0.urls.regular,
                    fullImageURL: $0.urls.full,
                    isLiked: $0.likedByUser
                )
            }
            
            DispatchQueue.main.async {
                let existingIDs = Set(self.photos.map { $0.id })
                let filteredNewPhotos = newPhotos.lazy.filter { !existingIDs.contains($0.id) }
                
                self.photos.append(contentsOf: filteredNewPhotos)
                self.loadingPage += 1
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            }
        }
        task.resume()
    }
    
    private func createRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseIRL)/photos") else {
            print("❌ Некорректный URL")
            return nil
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(loadingPage)),
            URLQueryItem(name: "per_page", value: String(constPhotoPerPage))
        ]
        
        guard let finalURL = urlComponents?.url else {
            print("❌ Некорректный URL с параметрами")
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if let task = task, task.state == .running {
            task.cancel()
        }
        guard let token = storage.token else {
            return
        }
        
        guard let url = URL(string: "\(Constants.defaultBaseIRL)/photos/\(photoId)/like") else {
            print("❌ Некорректный URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        
        // Экспериментальный метод на дженериках. При таком подходе два раза срабатывает вызов функции лайка
        //        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResponse, Error>) in
        //            guard let self = self else { return }
        //
        //            switch result {
        //            case .success(let responseBody):
        //                if let index = self.photos.firstIndex(where: { $0.id == responseBody.photo.id}) {
        //                    var photo = self.photos[index]
        //                    photo.isLiked.toggle()
        //                    self.photos[index] = photo
        //
        //                    DispatchQueue.main.async {
        //                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        //                        completion(.success(()))
        //                    }
        //                    completion(.success(()))
        //                } else {
        //                    let error = NSError(domain: "Couldn't find Asset", code: 404, userInfo: nil)
        //                    completion(.failure(error))
        //                }
        //            case .failure(let error):
        //                print("❌ Ошибка: \(error.localizedDescription)")
        //                completion(.failure(error))
        //            }
        //        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка получения лайка \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                var photo = self.photos[index]
                photo.isLiked.toggle()
                self.photos[index] = photo
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    completion(.success(()))
                }
            }
        }
        
        task.resume()
    }
    
    func clearPhotos() {
        loadingPage = 1
        photos.removeAll()
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
        print("фоточки почищены")
    }
}
