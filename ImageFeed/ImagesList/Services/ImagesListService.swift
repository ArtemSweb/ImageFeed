//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 10.03.2025.
//
import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}


final class ImagesListService {
    
    private let storage = OAuth2TokenStorage()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    private (set) var photos: [Photo] = []
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
                print("❌ Ошибка загрузки или декодирования данных")
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
                    isLiked: $0.likedByUser
                )
            }

            DispatchQueue.main.async {
                self.photos.append(contentsOf: newPhotos)
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
}
