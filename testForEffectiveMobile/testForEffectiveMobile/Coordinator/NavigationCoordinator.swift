//
//  NavigationCoordinator.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

protocol NavigationCoordinatorProtocol {
    func showLoginVC()
    func showCodeVerificationVC(email: String)
    func showMainVC()
    func showDetailVacancyVC(vacancy: Vacancy)
}

final class NavigationCoordinator: NavigationCoordinatorProtocol {
    
    private var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func showLoginVC() {
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: false)
    }
    
    func showCodeVerificationVC(email: String) {
        let codeVerificationVC = CodeVerificationViewController(email: email)
        navigationController?.pushViewController(codeVerificationVC, animated: true)
    }
    
    func showMainVC() {
        let tabBar = TabBarViewController()
        navigationController?.setViewControllers([tabBar], animated: true)
    }
    
    func showDetailVacancyVC(vacancy: Vacancy) {
        let detailVacancyVC = VacancyDetailViewController(vacancy: vacancy)
        navigationController?.pushViewController(detailVacancyVC, animated: true)
    }
}

