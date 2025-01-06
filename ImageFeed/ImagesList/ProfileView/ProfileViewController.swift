//
//  PrifileViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 01.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
//MARK: - UI элементы
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var logoutButton: UIButton!
    
//MARK: - функции кнопок
    @IBAction func logoutFromProfile(_ sender: Any) {
    }
}
