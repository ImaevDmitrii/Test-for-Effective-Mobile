//
//  NavigationController+Extension.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

extension UINavigationController {
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 34)]
        
        appearance.shadowColor = nil
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
        
        navigationBar.layer.masksToBounds = false
        navigationBar.isTranslucent = false
    }
    
    func setupBackButton(action: Selector, target: Any?) {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: target, action: action)
        backButton.tintColor = .white
        topViewController?.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .white
    }
    
    func setupRightButtons(favoriteAction: Selector, shareAction: Selector? = nil, eyeAction:  Selector? = nil, target: Any? = nil, isFavorite: Bool) {
        let favoriteImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        let favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: target, action: favoriteAction)
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: target, action: shareAction)
        let eyeButton = UIBarButtonItem(image: UIImage(systemName: "eye"), style: .plain, target: target, action: eyeAction)
        
        shareButton.isEnabled = shareAction != nil
        eyeButton.isEnabled = eyeAction != nil
        
        topViewController?.navigationItem.rightBarButtonItems = [favoriteButton, shareButton, eyeButton]
    }
}

