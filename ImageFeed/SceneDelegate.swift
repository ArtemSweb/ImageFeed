//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 19.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
}
