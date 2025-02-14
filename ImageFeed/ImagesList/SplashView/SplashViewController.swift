//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 09.02.2025.
//
import UIKit
enum Identifire {
    static let showTabBarController = "TabBarViewController"
    static let showAuthenticationScreen = "ShowAuthenticationScreen"
}


final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            switchTabBarController()
        } else {
            print("Нет токена")
            performSegue(withIdentifier: Identifire.showAuthenticationScreen, sender: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - вспомогательные функции
    private func switchTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Ошибка конфигурации")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: Identifire.showTabBarController)
        
        window.rootViewController = tabBarController
    }
}


extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifire.showAuthenticationScreen {
            guard let navigationController = segue.destination as? UINavigationController,
                  let authViewController = navigationController.viewControllers[0] as? AuthViewController else {
                assertionFailure("Не удалось перейти на экран авторизации")
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
            self?.switchTabBarController()
        }
    }
}
