//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 25.02.2025.
//

import UIKit

final class ProfileService {
    
    private let storage = OAuth2TokenStorage()
    static let shared = ProfileService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileServiceDidChange")
    var profile: Profile? = nil
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = task, task.state == .running {
           return
        }
        
        guard let token = storage.token else {
            return
        }
        
        guard let request = createRequest(token: token) else {
            completion(.failure(NSError(domain: "ProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey: "❌ Не удалось сформировать запрос"])))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func createRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/me") else {
            print("❌ Некорректный URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func clearProfile() {
        profile = nil
        NotificationCenter.default.post(name: ProfileService.didChangeNotification, object: self)
        print("профайл почищен")
    }
}
