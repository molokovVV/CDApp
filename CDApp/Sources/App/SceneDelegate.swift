//
//  SceneDelegate.swift
//  CDApp
//
//  Created by Виталик Молоков on 05.05.2023.
//

import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let assembly = Assembly()
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController, assembly: assembly)
        router.setRootVC()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
