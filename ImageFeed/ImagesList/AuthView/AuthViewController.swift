//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 25.01.2025.
//
import UIKit
import ProgressHUD

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
        configureProgressHUD()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == buttonSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(buttonSegueIdentifier)")
                return
            }
            
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - стили
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP black")
    }
    
    private func configureProgressHUD() {
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.animationType = .pacmanProgress
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    vc.dismiss(animated: true) {
                        self.delegate?.didAuthenticate(self)
                    }
                }
            case .failure(let error):
                print("❌ Ошибка авторизации: \(error.localizedDescription)")
                self.showAuthErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    private func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
