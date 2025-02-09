//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 25.01.2025.
//
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let buttonSegueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == buttonSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(buttonSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - стили
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button") // 1
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button") // 2
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // 3
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP black") // 4
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                print("Токен: \(token)")
                
                DispatchQueue.main.async {
                    vc.dismiss(animated: true) {
                        self?.delegate?.didAuthenticate(self!)
                    }
                }
                
            case .failure(let error):
                print("Ошибка авторизации: \(error.localizedDescription)")
                self?.showAuthErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Упс!",
            message: "Что-то пошло не так. Попробуйте повторить авторизацию",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ЧТОЖ", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
