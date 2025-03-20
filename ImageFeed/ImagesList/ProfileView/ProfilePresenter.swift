//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 18.03.2025.
//
import UIKit

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func exitButtonTapped()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let logoutService = LogoutService.shared
    private var profileImageService = ProfileImageService.shared
    
    private var profileServiceObserver: NSObjectProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        print("[ProfilePresenter] viewDidLoad")
        observeSettings()
        updateAvatar()
        updateProfile()
    }
    
    func observeSettings() {
        //наблюдатель
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            print("❌ Ошибка получения аватара из хранилища")
            return
        }
        view?.updateAvatar(with: url)
    }
    
    private func updateProfile() {
        guard let profile = profileService.profile else {
            print("Данные профиля отсутствуют")
            return
        }
        view?.updateProfile(name: profile.name, nickname: profile.loginName, description: profile.bio ?? "")
    }
    
    func exitButtonTapped() {
        view?.showLogoutAlert()
    }
    
    func approveLogout() {
        logoutService.logout()
        UIApplication.shared.windows.first?.rootViewController = SplashViewController()
    }
}
