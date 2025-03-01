//
//  URLSession+Data.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.02.2025.
//
import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        print(request)
        let fulFillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulFillCompletionOnTheMainThread(.success(data))
                } else {
                    print("Ошибка запроса. Код ответа сервера: \(statusCode)")
                    fulFillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Ошибка: \(error)")
                fulFillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Неизвестная ошибка NetworkError.urlSessionError")
                fulFillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
