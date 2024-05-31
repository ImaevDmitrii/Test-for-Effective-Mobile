//
//  VacancyCollectionViewCell.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class VacancyCollectionViewCell: UICollectionViewCell {
    
    private let lookingNumberLabel = UILabel()
    private let favoriteButton = UIButton()
    private let titleLabel = UILabel()
    private let townLabel = UILabel()
    private let companyLabel = UILabel()
    private let verifiedIcon = UIImageView(image: UIImage(systemName: "checkmark.circle"))
    private let experienceLabel = UILabel()
    private let portfolioIcon = UIImageView(image: UIImage(systemName: "briefcase"))
    private let publishedDateLabel = UILabel()
    private let applyButton = UIButton()
    
    private let heartIcon = UIImage(systemName: "heart")
    private let heartFillIcon = UIImage(systemName: "heart.fill")
    
    var favoriteButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let heartIconSize: CGFloat = 24
        let iconSize: CGFloat = 16
        let spacing: CGFloat = 10
        let padding: CGFloat = 16
        let iconSpacing: CGFloat = 8
        let smallSpacing: CGFloat = 4
        let buttonSpacing: CGFloat = 21
        let buttonHeight: CGFloat = 32
        
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        [lookingNumberLabel, favoriteButton, titleLabel, townLabel, townLabel, companyLabel, verifiedIcon, experienceLabel, portfolioIcon, publishedDateLabel, applyButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        favoriteButton.setImage(heartIcon, for: .normal)
        favoriteButton.tintColor = .customGrey4
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        
        verifiedIcon.tintColor = .customGrey3
        
        portfolioIcon.tintColor = .white
        
        lookingNumberLabel.font = .text1
        lookingNumberLabel.textColor = .customGreen
        
        titleLabel.font = .title3
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        townLabel.font = .text1
        townLabel.textColor = .lightGray
        
        companyLabel.font = .text1
        companyLabel.textColor = .lightGray
        
        experienceLabel.font = .text1
        experienceLabel.textColor = .white
        
        publishedDateLabel.font = .text1
        publishedDateLabel.textColor = .customGrey3
        
        applyButton.setTitle(Localization.reply, for: .normal)
        applyButton.backgroundColor = .customGreen
        applyButton.layer.cornerRadius = 16
        
        
        NSLayoutConstraint.activate([
            lookingNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            lookingNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            favoriteButton.widthAnchor.constraint(equalToConstant: heartIconSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: heartIconSize),
            
            titleLabel.topAnchor.constraint(equalTo: lookingNumberLabel.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            townLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            townLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            companyLabel.topAnchor.constraint(equalTo: townLabel.bottomAnchor, constant: smallSpacing),
            companyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            verifiedIcon.centerYAnchor.constraint(equalTo: companyLabel.centerYAnchor),
            verifiedIcon.leadingAnchor.constraint(equalTo: companyLabel.trailingAnchor, constant: iconSpacing),
            verifiedIcon.widthAnchor.constraint(equalToConstant: iconSize),
            verifiedIcon.heightAnchor.constraint(equalToConstant: iconSize),
            
            portfolioIcon.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: spacing),
            portfolioIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            portfolioIcon.widthAnchor.constraint(equalToConstant: iconSize),
            portfolioIcon.heightAnchor.constraint(equalToConstant: iconSize),
            
            experienceLabel.centerYAnchor.constraint(equalTo: portfolioIcon.centerYAnchor),
            experienceLabel.leadingAnchor.constraint(equalTo: portfolioIcon.trailingAnchor, constant: iconSpacing),
            experienceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            publishedDateLabel.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: spacing),
            publishedDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            publishedDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            applyButton.topAnchor.constraint(equalTo: publishedDateLabel.bottomAnchor, constant: buttonSpacing),
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            applyButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    func configure(with vacancy: Vacancy) {
        if let lookingNumber = vacancy.lookingNumber {
            lookingNumberLabel.text = "\(Localization.lokingNow) \(lookingNumber) \(LocalizeCount.localizePeopleCount(lookingNumber))"
        } else {
            lookingNumberLabel.text = nil
        }
        
        favoriteButton.setImage(vacancy.isFavorite ?  heartFillIcon : heartIcon, for: .normal)
        titleLabel.text = vacancy.title
        townLabel.text = vacancy.address.town
        companyLabel.text = vacancy.company
        experienceLabel.text = vacancy.experience.previewText
        publishedDateLabel.text = "\(Localization.published) \(formatterPublishedDate(vacancy.publishedDate))"
    }
    
    @objc private func favoriteButtonAction() {
           favoriteButtonTapped?()
       }
    
    private func formatterPublishedDate(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else { return date }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month], from: date)
        guard let day = components.day, let month = components.month else { return date.description }
        
        let monthName = formatter.monthSymbols[month - 1]
        return "\(day) \(monthName)"
    }
}
