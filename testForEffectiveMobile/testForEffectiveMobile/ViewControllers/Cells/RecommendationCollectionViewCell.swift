//
//  RecommendationCollectionViewCell.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class RecommendationCollectionViewCell: UICollectionViewCell {
    private let avatarView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let avatarIconSize: CGFloat = 32
        let iconImageSize: CGFloat = 24
        let padding: CGFloat = 8
        
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        [avatarView, iconImageView, titleLabel, button].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        avatarView.tintColor = .white
        avatarView.layer.cornerRadius = avatarIconSize / 2
        avatarView.clipsToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .title4
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        button.setTitleColor(.customGreen, for: .normal)
        button.titleLabel?.font = .buttonText2
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarView.widthAnchor.constraint(equalToConstant: avatarIconSize),
            avatarView.heightAnchor.constraint(equalToConstant: avatarIconSize),
            
            iconImageView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: iconImageSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconImageSize),
            
            titleLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -padding),
            
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(with offer: Offer) {
        titleLabel.text = offer.title
        if let buttonText = offer.button?.text {
            button.setTitle(buttonText, for: .normal)
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        configureAvatar(with: offer.id)
    }
    
    private func configureAvatar(with id: String?) {
        let alpha: CGFloat = 0.3
        
        guard let id = id else {
            avatarView.backgroundColor = UIColor.customBlue.withAlphaComponent(alpha)
            iconImageView.image = UIImage(systemName: "questionmark.circle")?.withTintColor(.customBlue, renderingMode: .alwaysOriginal)
            return
        }
        
        switch id {
        case "temporary_job":
            avatarView.backgroundColor = UIColor.customGreen.withAlphaComponent(alpha)
            iconImageView.image = UIImage(systemName: "clock")?.withTintColor(.customGreen, renderingMode: .alwaysOriginal)
        case "level_up_resume":
            avatarView.backgroundColor = UIColor.customGreen.withAlphaComponent(alpha)
            iconImageView.image = UIImage(systemName: "arrow.up")?.withTintColor(.customGreen, renderingMode: .alwaysOriginal)
        case "near_vacancies":
            avatarView.backgroundColor = UIColor.customBlue.withAlphaComponent(alpha)
            iconImageView.image = UIImage(systemName: "location")?.withTintColor(.customBlue, renderingMode: .alwaysOriginal)
        default:
            avatarView.backgroundColor = UIColor.customBlue.withAlphaComponent(alpha)
            iconImageView.image = UIImage(systemName: "questionmark.circle")?.withTintColor(.customBlue, renderingMode: .alwaysOriginal)
        }
    }
}
