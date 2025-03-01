//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 09.02.2025.
//
import UIKit
enum IdentifierConstants {
    static let showTabBarController = "TabBarViewController"
    static let showAuthenticationScreen = "ShowAuthenticationScreen"
}

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkTokenExpiration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProfileData()
    }
    
    //MARK: - вспомогательные функции
    private func switchTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Ошибка")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: IdentifierConstants.showTabBarController)
        
        window.rootViewController = tabBarController
    }
    
    private func checkTokenExpiration() {
        if let token = storage.token {
            switchTabBarController()
        } else {
            performSegue(withIdentifier: IdentifierConstants.showAuthenticationScreen, sender: nil)
        }
    }
}


extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierConstants.showAuthenticationScreen {
            guard let navigationController = segue.destination as? UINavigationController,
                  let authViewController = navigationController.viewControllers[0] as? AuthViewController else {
                assertionFailure("Ошибка перехода на экран авторизации")
                return
            }
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            
            guard let self else { return }
            
            print("загружаем профиль")
            self.switchTabBarController()
            self.fetchProfileData()
        }
    }
    
    private func fetchProfileData() {
        
        profileService.fetchProfile { [weak self] result in
            print("загружаем профиль-1")
            switch result {
            case .success(let profile):
                guard ProfileService.shared.profile != nil else {
                    print("Данные профиля не загружаются")
                    return
                }
                print("✅ Профиль успешно загружен: \(profile.name)")
                
            case .failure(let error):
                print("❌ Ошибка загрузки профиля: \(error.localizedDescription)")
            }
        }
    }
}

