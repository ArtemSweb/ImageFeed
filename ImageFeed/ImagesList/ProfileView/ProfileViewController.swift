//
//  PrifileViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 01.01.2025.
//
import Kingfisher
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfile(name: String, nickname: String, description: String)
    func updateAvatar(with url: URL)
    func showLogoutAlert()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private var presenter: ProfilePresenterProtocol?
    
    init(presenter: ProfilePresenterProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: - UI элементы + Верстка
    private let avatarImageView: UIImageView = {
        let image = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: image)
        return avatarImageView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(named: "Exit-icon")?.withRenderingMode(.alwaysOriginal),
            for: .normal)
        button.addTarget(
            self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return nameLabel
    }()
    
    private let nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.textColor = .ypGrey
        nicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return nicknameLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    //стек для лейблов профиля
    private let descriptionStackView: UIStackView = {
        let descriptionStackView = UIStackView()
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 8
        return descriptionStackView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        presenter?.viewDidLoad()
        
        addViews()
        configurateConstraints()
    }
    
    //MARK: - позиционирование элементов
    private func addViews() {
        [nameLabel, nicknameLabel, descriptionLabel].forEach {
            descriptionStackView.addArrangedSubview($0)
        }
        
        [avatarImageView, descriptionStackView, logoutButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configurateConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionStackView.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor, constant: 8),
            descriptionStackView.leadingAnchor.constraint(
                equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logoutButton.centerYAnchor.constraint(
                equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    //MARK: - Вспомогательные функции
    func updateProfile(name: String, nickname: String, description: String) {
        nameLabel.text = name
        nicknameLabel.text = nickname
        descriptionLabel.text = description
    }
    
    func updateAvatar(with url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 50, backgroundColor: .ypBlack)
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder_avatar"),
            options: [
                .processor(processor),
                .transition(.fade(3))
            ]
        ) { result in
            switch result {
            case .success:
                print("✅ Аватар установлен")
            case .failure(let error):
                print("❌ аватар не установлен: \(error)")
            }
        }
    }
    
    @objc
    private func exitButtonTapped() {
        self.presenter?.exitButtonTapped()
    }
    
    func showLogoutAlert(){
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            guard let presenter = self.presenter as? ProfilePresenter else { return }
            presenter.approveLogout()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true)
    }
}
