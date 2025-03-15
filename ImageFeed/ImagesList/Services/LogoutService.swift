//
//  LogoutService.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 15.03.2025.
//
import WebKit
import SwiftKeychainWrapper

final class LogoutService{
    static let shared = LogoutService()
    
    private init(){}
    
    func logout(){
        print("запускаем очистку")
        UserDefaults.standard.removeObject(forKey: "BearerToken")
        KeychainWrapper.standard.removeObject(forKey: "BearerToken")
        
        cleanCookies()
        
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearAvatar()
        ImagesListService.shared.clearPhotos()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
