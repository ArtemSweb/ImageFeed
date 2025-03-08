//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 04.03.2025.
//
import UIKit

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let storage = OAuth2TokenStorage()
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        guard let request = createRequest(userName: username) else {
            completion(.failure(NSError(domain: "ProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey: "❌ Не удалось сформировать запрос"])))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                let avatarUrl = userResult.profileImage.large
                self.avatarURL = avatarUrl
                completion(.success(avatarUrl))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func createRequest(userName: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseIRL)/users/\(userName)") else {
            print("❌ Invalid URL")
            return nil
        }
        guard let token = storage.token else {
            print("❌ Ошибка с Bearer токеном")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
