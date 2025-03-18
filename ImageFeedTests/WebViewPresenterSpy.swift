//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 18.03.2025.
//

import ImageFeed
import Foundation
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
