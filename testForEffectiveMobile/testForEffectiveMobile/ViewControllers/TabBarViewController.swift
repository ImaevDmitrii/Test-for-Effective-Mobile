//
//  TabBarViewController.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

protocol FavoritesObserver: AnyObject {
    func favoritesDidUpdate(count: Int)
}

protocol TabBarInteractionControllable {
    var shouldDisableTabBarInteractions: Bool { get }
}

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate, FavoritesObserver {
    
    private let searchTitle = Localization.search
    private let favoritesTitle = Localization.favorites
    private let responsesTitle = Localization.responses
    private let messagesTitle = Localization.messages
    private let profileTitle = Localization.profile
    
    private let searchIcon = UIImage(systemName: "magnifyingglass")
    private let favoritesIcon = UIImage(systemName: "heart")
    private let responsesIcon = UIImage(systemName: "envelope")
    private let messagesIcon = UIImage(systemName: "message")
    private let profileIcon = UIImage(systemName: "person")
    
    private let favoritesManager = FavoritesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureStyleTabBar()
        favoritesManager.addObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdate), name: FavoritesManager.favoritesDidUpdateNotification, object: nil)
        self.delegate = delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesBadge(count: favoritesManager.loadFavoriteVacancies().count)
    }
    
    deinit {
        favoritesManager.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: FavoritesManager.favoritesDidUpdateNotification, object: nil)
    }
    
    private func configureTabBar() {
        let vacancyVC = VacancyCollectionViewController()
        let favoriteVC = FavoritesCollectionViewController()
        let responsesVC = StubViewController()
        let messagesVC = StubViewController()
        let profileVC = StubViewController()
        
        vacancyVC.tabBarItem = UITabBarItem(title: searchTitle, image: searchIcon, tag: 0)
        favoriteVC.tabBarItem = UITabBarItem(title: favoritesTitle, image: favoritesIcon, tag: 1)
        responsesVC.tabBarItem = UITabBarItem(title: responsesTitle, image: responsesIcon, tag: 2)
        messagesVC.tabBarItem = UITabBarItem(title: messagesTitle, image: messagesIcon, tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: profileTitle, image: profileIcon, tag: 4)
        
        viewControllers = [vacancyVC, favoriteVC, responsesVC, messagesVC, profileVC]
    }
    
    private func configureStyleTabBar() {
        tabBar.backgroundColor = .black
        tabBar.barTintColor = .clear
        tabBar.isTranslucent = true
        tabBar.tintColor = .customBlue
        tabBar.unselectedItemTintColor = .customGrey4
    }
    
    func favoritesDidUpdate(count: Int) {
        updateFavoritesBadge(count: count)
    }
    
    @objc private func handleFavoritesUpdate() {
        updateFavoritesBadge(count: favoritesManager.loadFavoriteVacancies().count)
    }
    
    private func updateFavoritesBadge(count: Int) {
        if count > 0 {
            tabBar.items?[1].badgeValue = "\(count)"
        } else {
            tabBar.items?[1].badgeValue = nil
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let currentVC = selectedViewController as? TabBarInteractionControllable, currentVC.shouldDisableTabBarInteractions {
            return false
        }
        return true
    }
}
