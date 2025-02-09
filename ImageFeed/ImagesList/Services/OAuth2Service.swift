//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.02.2025.
//

import UIKit

class OAuth2Service {
    //Реализация синглтона
    static let shared = OAuth2Service()
    private init() {}
    
    private let baseURL = "https://nastya-image-feed.herokuapp.com/oauth2/token"
    
    //инициализация хранилища
    private let storage = OAuth2TokenStorage()
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        print("запустили OAuth2Service.makeOAuthTokenRequest")
            guard let url = URL(string: baseURL) else {
                print("Ошибка: не удалось создать URL \(baseURL)")
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
                print("Ошибка: не удалось создать тело запроса из URLComponents")
                return nil
            }
            
            request.httpBody = httpBody
            return request
        }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("запустили OAuth2Service.fetchAuthToken")
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось сформировать запрос"])))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                // декодируем данные
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    print(tokenResponse.accessToken) //Дебаг принтами
                    self.storage.token = tokenResponse.accessToken
                    DispatchQueue.main.async {
                        print(tokenResponse.accessToken)
                        completion(.success(tokenResponse.accessToken))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "OAuth2Service", code: 5, userInfo: [NSLocalizedDescriptionKey: "Ошибка декодирования JSON"])))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
