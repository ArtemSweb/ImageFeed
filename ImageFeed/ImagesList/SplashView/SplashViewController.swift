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
    private let profileImageService = ProfileImageService.shared
    
    //MARK: - UI элементы
    private let launchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launchIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkTokenExpiration()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Верстка
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(launchImageView)
        
        launchImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    //MARK: - вспомогательные функции
    private func switchTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("❌ Ошибка")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: IdentifierConstants.showTabBarController)
        
        window.rootViewController = tabBarController
    }
    
    private func checkTokenExpiration() {
        if let token = storage.token {
            fetchProfile()
        } else {
            guard let authViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                return
            }
            
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
}

//MARK: - Расширения
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchProfile()
        }
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile {[weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                guard ProfileService.shared.profile != nil else {
                    print("❌ Данные профиля не загружаются")
                    return
                }
                
                print("✅ Профиль успешно загружен: \(profile.username)")
                self.fetchProfileImage(username: profile.username)
                self.switchTabBarController()
                
            case .failure(let error):
                print("❌ Ошибка загрузки профиля: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let image):
                guard ProfileImageService.shared.avatarURL != nil else {
                    return
                }
                print("✅ аватар успешно загружен")
                
            case .failure(let error):
                print("❌ Ошибка загрузки аватара: \(error.localizedDescription)")
            }
        }
    }
}

