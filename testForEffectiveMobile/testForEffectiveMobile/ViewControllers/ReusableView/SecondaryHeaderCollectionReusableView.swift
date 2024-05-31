//
//  SecondaryHeaderCollectionReusableView.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 31.05.2024.
//

import UIKit

final class SecondaryHeaderCollectionReusableView: UICollectionReusableView {
    
    private let label = UILabel()
    
    func configureAsSecondaryHeader(count: Int) {
        let localizedCount = LocalizeCount.getVacancyText(for: count)
        label.text = "\(count) \(localizedCount)"
        label.textColor = .customGrey3
        label.font = .text1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
