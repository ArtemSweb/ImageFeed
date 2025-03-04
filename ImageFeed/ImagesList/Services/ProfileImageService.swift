//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 04.03.2025.
//
import UIKit

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let storage = OAuth2TokenStorage()
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<UserResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        guard let request = createRequest(userName: username) else {
            completion(.failure(NSError(domain: "ProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey: "❌ Не удалось сформировать запрос"])))
            return
        }
        
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success(let profileResult):
                // декодируем данные
                do {
                    let avatarUrl = try JSONDecoder().decode(UserResult.self, from: profileResult)
                    self.avatarURL = avatarUrl.profileImage.small
                    completion(.success(avatarUrl))
                } catch {
                    print("❌ Ошибка JSON: \(error)")
                }
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileResult])
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
