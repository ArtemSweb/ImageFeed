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
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListViewPresenter(view: imagesListViewController)
        imagesListViewController.configure(imagesListPresenter)
        
        
        let profileViewController = ProfileViewController(presenter: nil)
        let presenter = ProfilePresenter(view: profileViewController)
        profileViewController.configure(presenter)
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
        
    }
}
