//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 17.03.2025.
//
import Foundation


protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    
    func code(from url: URL) -> String?
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
                
                view?.load(request: request)
                didUpdateProgressValue(0)
        
//        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
//            return
//        }
//        
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//        
//        guard let url = urlComponents.url else {
//            return
//        }
//        
//        let request = URLRequest(url: url)
//        
//        didUpdateProgressValue(0)
//        
//        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String?{
        
        authHelper.code(from: url)
//        if
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
    }
}
