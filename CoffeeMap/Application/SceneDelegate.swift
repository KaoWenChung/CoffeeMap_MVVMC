//
//  SceneDelegate.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let navigationViewController = UINavigationController()
        window.rootViewController = navigationViewController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationViewController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()

        self.window = window
        window.makeKeyAndVisible()
    }
}
