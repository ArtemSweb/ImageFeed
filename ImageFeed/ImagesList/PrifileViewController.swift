//
//  PrifileViewController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 01.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
//MARK: - UI элементы
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
//MARK: - функции кнопок
    @IBAction func logoutFromProfile(_ sender: Any) {
    }
}
