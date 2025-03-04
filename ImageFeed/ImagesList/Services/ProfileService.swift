//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 25.02.2025.
//

import UIKit

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespaces)
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

final class ProfileService {
    
    private let storage = OAuth2TokenStorage()
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile? = nil
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = task, task.state == .running {
            task.cancel()
        }
        
        guard let token = storage.token else {
            return
        }
        
        guard let request = createRequest(token: token) else {
            completion(.failure(NSError(domain: "ProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey: "❌ Не удалось сформировать запрос"])))
            return
        }
        
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success(let profileResult):
                // декодируем данные
                do {
                    let profile = try JSONDecoder().decode(ProfileResult.self, from: profileResult)
                    self.profile = Profile(profileResult: profile)
                    completion(.success(Profile(profileResult: profile)))
                } catch {
                    print("❌ Ошибка JSON: \(error)")
                }
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func createRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseIRL)/me") else {
            print("❌ Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }
}
