//
//  AppCoordinator.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let tabBarController: TabBarViewController
    
    init(navigationController: UINavigationController, tabBarController: TabBarViewController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func start() {
        let loginVC = LoginViewController()
        navigationController.setViewControllers([loginVC], animated: false)
    }
}
