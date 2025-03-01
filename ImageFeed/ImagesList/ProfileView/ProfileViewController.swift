//
//  PrifileViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 01.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    //MARK: - UI элементы + Верстка
    private let avatarImageView: UIImageView = {
        let image = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: image)
        return avatarImageView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Exit-icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self ,action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return nameLabel
    }()
    
    private let nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.textColor = .ypGrey
        nicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return nicknameLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "lorem  ipsum dolor sit amet consectetur adipisicing elit. Quo, voluptatem! Quasi, voluptates! Quo, voluptatem! Quo, voluptatem! Quo, voluptatem!"
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

        updateProfile()

        
        addViews()
        configurateConstraints()
    }
    
    //MARK: - позиционирование элементов
    private func addViews(){
        [nameLabel, nicknameLabel, descriptionLabel].forEach {
            descriptionStackView.addArrangedSubview($0)
        }
        
        [avatarImageView, descriptionStackView, logoutButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configurateConstraints(){
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            descriptionStackView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Вспомогательные функции
    
    private func updateProfile(){
        if let profile = ProfileService.shared.profile {
            nameLabel.text = profile.name
            nicknameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    }
    
    @objc
    private func exitButtonTapped() {
        print("Logout")
    }
}
