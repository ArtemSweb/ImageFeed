//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.02.2025.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let storage = OAuth2TokenStorage()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(NSError(domain: "OAuth2Service", code: 2, userInfo: [NSLocalizedDescriptionKey: "Неверный запрос"])))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NSError(domain: "OAuth2Service", code: 2, userInfo: [NSLocalizedDescriptionKey: "Неверный запрос"])))
                return
            }
        }
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось сформировать запрос"])))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseBody):
                self.storage.token = responseBody.accessToken
                print("✅ Токен получен: \(responseBody.accessToken)")
                completion(.success(responseBody.accessToken))
            case .failure(let error):
                print("❌ Ошибка получения токена: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: Constants.baseURL) else {
            print("❌ Ошибка: не удалось получить URL \(Constants.baseURL)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let httpBody = urlComponents.query?.data(using: .utf8) else {
            print("❌ Тело (httpBody) не сформировано для POST запроса")
            return nil
        }
        
        request.httpBody = httpBody
        return request
    }
}
