//
//  PrifileViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 01.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    //MARK: - UI элементы + Верстка
    @IBOutlet private weak var logoutButton: UIButton!
    
    private let avatarImageView: UIImageView = {
        let image = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: image)
        return avatarImageView
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
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return descriptionLabel
    }()
    //стек для лейблов профиля
    private let descriptionStackView: UIStackView = {
        let descriptionStackView = UIStackView()
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 8
        return descriptionStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        configurateConstraints()
    }
    
    //MARK: - позиционирование элементов
    private func addViews(){
        [nameLabel, nicknameLabel, descriptionLabel].forEach { descriptionStackView.addArrangedSubview($0) }
        [avatarImageView, descriptionStackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configurateConstraints(){
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            descriptionStackView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
}
