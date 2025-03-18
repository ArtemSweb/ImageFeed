//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 08.03.2025.
//
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        
        let profileViewController = ProfileViewController(presenter: nil)
        let presenter = ProfilePresenter(view: profileViewController)
        profileViewController.configure(presenter)
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imageListViewController, profileViewController]
        
    }
}
