//
//  MoreVacancyButtonCollectionReusableView.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class MoreVacancyButtonCollectionReusableView: UICollectionReusableView {
    
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        button.backgroundColor = .customBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .buttonText1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configure(with numberOfVacancies: Int) {
        let vacancyText = LocalizeCount.getVacancyText(for: numberOfVacancies)
        let buttonText = "\(Localization.more) \(numberOfVacancies) \(vacancyText)"
        button.setTitle(buttonText, for: .normal)
    }
}
