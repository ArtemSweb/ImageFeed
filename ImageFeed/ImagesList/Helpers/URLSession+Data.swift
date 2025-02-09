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
        let fulFillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            print("запустили urlSession.data.task")
              if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                  if 200 ..< 300 ~= statusCode {
                      fulFillCompletionOnTheMainThread(.success(data))
                  } else {
                      fulFillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                  }
              } else if let error = error {
                  fulFillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
              } else {
                  fulFillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
              }
          })

          return task
    }
}
