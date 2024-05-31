//
//  VacancyDetailViewController.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class VacancyDetailViewController: UIViewController, FavoritesObserver {
    
    private var vacancy: Vacancy
    private let viewModel = VacanciesViewModel()
    private let favoritesManager = FavoritesManager()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let mainContainerView = UIView()
    private let largeContainerView = UIView()
    private let appliedNumbersView = UIView()
    private let lookingNumberView = UIView()
    
    private let titleLabel = UILabel()
    private let salaryLabel = UILabel()
    private let experienceLabel = UILabel()
    private let schedulesLabel = UILabel()
    
    private let appliedNumberLabel = UILabel()
    private let lookingNumberLabel = UILabel()
    private let companyLabel = UILabel()
    private let addressLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let responsibilitiesLabel = UILabel()
    private let responsibilitiesHeaderLabel = UILabel()
    private let askQuestionLabel = UILabel()
    private let receivedWithResponseLabel = UILabel()
    private let respondButton = UIButton(type: .system)
    private let questionsView = UIView()
    private let mapView = UIView()
    
    private let personIcon = UIImage(systemName: "person.circle")
    
    private let iconSize: CGFloat = 24
    private let padding: CGFloat = 16
    private let titleSpacing: CGFloat = 28
    private let spacing: CGFloat = 8
    private var numberViewsSize: CGFloat = 50
    private let buttonSize: CGFloat = 48
    
    init(vacancy: Vacancy) {
        self.vacancy = vacancy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        favoritesManager.addObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure(with: vacancy)
    }
    
    deinit {
        favoritesManager.removeObserver(self)
    }
    
    private func setup() {
        setupViewHierarchy()
        setupConstraints()
        configureStyles()
        configureActions()
    }
    
    private func setupViewHierarchy() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainContainerView)
        
        [scrollView, contentView, mainContainerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let elements = [
            titleLabel, salaryLabel, experienceLabel, schedulesLabel,
            descriptionLabel, responsibilitiesHeaderLabel, responsibilitiesLabel,
            askQuestionLabel, receivedWithResponseLabel, questionsView, respondButton]
        
        elements.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [appliedNumbersView, lookingNumberView, largeContainerView].forEach {
            mainContainerView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: titleSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            salaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            salaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            salaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            experienceLabel.topAnchor.constraint(equalTo: salaryLabel.bottomAnchor, constant: padding),
            experienceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            experienceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            schedulesLabel.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: spacing),
            schedulesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            schedulesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            responsibilitiesHeaderLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            responsibilitiesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            responsibilitiesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            responsibilitiesLabel.topAnchor.constraint(equalTo: responsibilitiesHeaderLabel.bottomAnchor, constant: padding),
            responsibilitiesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            responsibilitiesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            askQuestionLabel.topAnchor.constraint(equalTo: responsibilitiesLabel.bottomAnchor, constant: padding),
            askQuestionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            askQuestionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            receivedWithResponseLabel.topAnchor.constraint(equalTo: askQuestionLabel.bottomAnchor, constant: padding),
            receivedWithResponseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            receivedWithResponseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            questionsView.topAnchor.constraint(equalTo: receivedWithResponseLabel.bottomAnchor, constant: padding),
            questionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            questionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: padding),
            
            respondButton.topAnchor.constraint(equalTo: questionsView.bottomAnchor, constant: padding),
            respondButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            respondButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            respondButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            respondButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }
    
    private func configureStyles() {
        [titleLabel, responsibilitiesHeaderLabel].forEach {
            $0.font = .title2
            $0.textColor = .white
        }
        
        [salaryLabel, experienceLabel, schedulesLabel, descriptionLabel, responsibilitiesLabel, askQuestionLabel].forEach {
            $0.font = .text1
            $0.textColor = .white
        }
        
        receivedWithResponseLabel.tintColor = .customGrey3
        receivedWithResponseLabel.font = .title4
        receivedWithResponseLabel.textColor = .customGrey3
        
        responsibilitiesHeaderLabel.text = Localization.yourTasks
        receivedWithResponseLabel.text = Localization.receivedWithResponse
        respondButton.setTitle(Localization.respond, for: .normal)
        respondButton.backgroundColor = .customGreen
        respondButton.tintColor = .white
        respondButton.layer.cornerRadius = 8
        mapView.backgroundColor = .gray
        
        configureNumberViews()
        configureLargeContainer()
    }
    
    private func configureActions() {
        navigationController?.setupNavigationBar()
        navigationController?.setupBackButton(action: #selector(backButtonTapped), target: self)
    }
    
    private func configureNumberViews() {
        let firstCircleView = UIView()
        let secondCircleView = UIView()
        let personIcon = UIImageView()
        let eyeIcon = UIImageView()
        
        personIcon.image = UIImage(systemName: "person")
        eyeIcon.image = UIImage(systemName: "eye")
        
        [firstCircleView, secondCircleView].forEach {
            $0.layer.cornerRadius = iconSize / 2
            $0.clipsToBounds = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.opacity = 0.3
            $0.backgroundColor = .customGreen
        }
        
        [personIcon, eyeIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .white
        }
        
        [appliedNumbersView, lookingNumberView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .customDarkGreen
        }
        
        [appliedNumberLabel, lookingNumberLabel].forEach {
            $0.font = .text1
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [firstCircleView, personIcon, appliedNumberLabel].forEach {
            appliedNumbersView.addSubview($0)
        }
        
        [secondCircleView, eyeIcon, lookingNumberLabel].forEach {
            lookingNumberView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            appliedNumberLabel.topAnchor.constraint(equalTo: appliedNumbersView.topAnchor, constant: spacing),
            appliedNumberLabel.leadingAnchor.constraint(equalTo: appliedNumbersView.leadingAnchor, constant: spacing),
            appliedNumberLabel.trailingAnchor.constraint(equalTo: firstCircleView.leadingAnchor, constant: spacing),
            
            firstCircleView.topAnchor.constraint(equalTo: appliedNumbersView.topAnchor, constant: spacing),
            firstCircleView.trailingAnchor.constraint(equalTo: appliedNumbersView.trailingAnchor, constant: -spacing),
            firstCircleView.widthAnchor.constraint(equalToConstant: iconSize),
            firstCircleView.heightAnchor.constraint(equalToConstant: iconSize),
            
            personIcon.centerXAnchor.constraint(equalTo: firstCircleView.centerXAnchor),
            personIcon.centerYAnchor.constraint(equalTo: firstCircleView.centerYAnchor),
            personIcon.widthAnchor.constraint(equalToConstant: iconSize / 2),
            personIcon.heightAnchor.constraint(equalToConstant: iconSize / 2)
        ])
        
        NSLayoutConstraint.activate([
            lookingNumberLabel.topAnchor.constraint(equalTo: lookingNumberView.topAnchor, constant: spacing),
            lookingNumberLabel.leadingAnchor.constraint(equalTo: lookingNumberView.leadingAnchor, constant: spacing),
            lookingNumberLabel.trailingAnchor.constraint(equalTo: secondCircleView.leadingAnchor, constant: spacing),
            
            secondCircleView.topAnchor.constraint(equalTo: lookingNumberView.topAnchor, constant: spacing),
            secondCircleView.trailingAnchor.constraint(equalTo: lookingNumberView.trailingAnchor, constant: -spacing),
            secondCircleView.widthAnchor.constraint(equalToConstant: iconSize),
            secondCircleView.heightAnchor.constraint(equalToConstant: iconSize),
            
            eyeIcon.centerXAnchor.constraint(equalTo: secondCircleView.centerXAnchor),
            eyeIcon.centerYAnchor.constraint(equalTo: secondCircleView.centerYAnchor),
            eyeIcon.widthAnchor.constraint(equalToConstant: iconSize / 2),
            eyeIcon.heightAnchor.constraint(equalToConstant: iconSize / 2)
        ])
    }
    
    private func configureLargeContainer() {
        let verifiedIcon = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        let verifiedIconSize: CGFloat = 16
        let mapViewSize: CGFloat = 58
        
        largeContainerView.translatesAutoresizingMaskIntoConstraints = false
        largeContainerView.layer.cornerRadius = 8
        largeContainerView.backgroundColor = .customGrey1
        
        [companyLabel, mapView, addressLabel, verifiedIcon].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            largeContainerView.addSubview($0)
        }
        
        companyLabel.font = .title3
        addressLabel.font = .text1
        verifiedIcon.tintColor = .customGrey3
        
        [companyLabel, addressLabel].forEach {
            $0.textColor = .white
        }
        
        mapView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: largeContainerView.topAnchor, constant: padding),
            companyLabel.leadingAnchor.constraint(equalTo: largeContainerView.leadingAnchor, constant: padding),
            companyLabel.trailingAnchor.constraint(equalTo: verifiedIcon.leadingAnchor, constant: -spacing),
            
            verifiedIcon.topAnchor.constraint(equalTo: largeContainerView.topAnchor, constant: padding),
            verifiedIcon.leadingAnchor.constraint(equalTo: companyLabel.trailingAnchor, constant: spacing),
            verifiedIcon.widthAnchor.constraint(equalToConstant: verifiedIconSize),
            verifiedIcon.heightAnchor.constraint(equalToConstant: verifiedIconSize),
            
            mapView.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: spacing),
            mapView.leadingAnchor.constraint(equalTo: largeContainerView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: largeContainerView.trailingAnchor, constant: -padding),
            mapView.heightAnchor.constraint(equalToConstant: mapViewSize),
            
            addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: padding),
            addressLabel.leadingAnchor.constraint(equalTo: largeContainerView.leadingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: largeContainerView.trailingAnchor, constant: -padding),
            addressLabel.bottomAnchor.constraint(equalTo: largeContainerView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configure(with vacancy: Vacancy) {
        titleLabel.text = vacancy.title
        salaryLabel.text = vacancy.salary.full
        companyLabel.text = vacancy.company
        experienceLabel.text = "\(Localization.requiredExperience) \(vacancy.experience.text)"
        
        let schedulesText = vacancy.schedules.map { $0.capitalized }.joined(separator: ", ")
        schedulesLabel.text = schedulesText
        
        if let appliedNumber = vacancy.appliedNumber, let lookingNumber = vacancy.lookingNumber {
            appliedNumberLabel.text = "\(appliedNumber) \(LocalizeCount.localizePeopleCount(appliedNumber)) \(Localization.appliedNumberText)"
            lookingNumberLabel.text = "\(lookingNumber) \(LocalizeCount.localizePeopleCount(lookingNumber)) \(Localization.lookingNumberText)"
            
            appliedNumbersView.isHidden = false
            lookingNumberView.isHidden = false
        } else {
            appliedNumbersView.isHidden = true
            lookingNumberView.isHidden = true
        }
        
        addressLabel.text = "\(vacancy.address.town) \(vacancy.address.street) \(vacancy.address.house)"
        
        descriptionLabel.text = vacancy.description ?? ""
        responsibilitiesLabel.text = vacancy.responsibilities
        
        askQuestionLabel.text = vacancy.questions.isEmpty ? "" : Localization.askQuestion
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        responsibilitiesLabel.numberOfLines = 0
        responsibilitiesLabel.lineBreakMode = .byWordWrapping
        
        configureQuestionsView(with: vacancy.questions)
        
        NSLayoutConstraint.activate([
            mainContainerView.topAnchor.constraint(equalTo: schedulesLabel.bottomAnchor, constant: padding),
            mainContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mainContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
        configureMainContainer()
        
        self.vacancy.isFavorite = favoritesManager.isFavorite(vacancy: vacancy)
        navigationController?.setupRightButtons(favoriteAction: #selector(favoriteButtonTapped), target: self, isFavorite: vacancy.isFavorite)
    }
    
    private func configureQuestionsView(with questions: [String]) {
        questionsView.subviews.forEach { $0.removeFromSuperview() }
        
        var previousButton: UIButton?
        
        questions.forEach { question in
            let button = createQuestionButton(with: question)
            questionsView.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: questionsView.leadingAnchor, constant: spacing),
                button.trailingAnchor.constraint(lessThanOrEqualTo: questionsView.trailingAnchor, constant: -spacing)
            ])
            
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: spacing)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: questionsView.topAnchor, constant: spacing)
                ])
            }
            previousButton = button
        }
        
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.bottomAnchor.constraint(equalTo: questionsView.bottomAnchor, constant: -spacing)
            ])
        }
    }
    
    private func createQuestionButton(with question: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .customGrey1
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.tintColor = .white
        button.titleLabel?.font = .text1
        button.setTitle(question, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.sizeToFit()
        
        var config = UIButton.Configuration.plain()
        config.title = question
        config.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: spacing, trailing: padding)
        
        button.configuration = config
        
        return button
    }
    
    private func configureMainContainer() {
        var previousView: UIView? = nil
        
        if !appliedNumbersView.isHidden {
            NSLayoutConstraint.activate([
                appliedNumbersView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
                appliedNumbersView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
                appliedNumbersView.heightAnchor.constraint(equalToConstant: numberViewsSize),
                appliedNumbersView.widthAnchor.constraint(equalTo: lookingNumberView.isHidden ? appliedNumbersView.widthAnchor : lookingNumberView.widthAnchor)
            ])
            previousView = appliedNumbersView
        }
        
        if !lookingNumberView.isHidden {
            NSLayoutConstraint.activate([
                lookingNumberView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
                lookingNumberView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
                lookingNumberView.heightAnchor.constraint(equalToConstant: numberViewsSize)
            ])
            
            if let previousView = previousView {
                NSLayoutConstraint.activate([
                    lookingNumberView.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant: spacing)
                ])
            } else {
                NSLayoutConstraint.activate([
                    lookingNumberView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor)
                ])
            }
            previousView = lookingNumberView
        }
        
        if !largeContainerView.isHidden {
            NSLayoutConstraint.activate([
                largeContainerView.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? mainContainerView.topAnchor, constant: padding),
                largeContainerView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
                largeContainerView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
                largeContainerView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor)
            ])
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        viewModel.toggleFavorite(for: vacancy)
        configure(with: vacancy)
        favoritesManager.notifyObservers()
    }
    
    func favoritesDidUpdate(count: Int) {
        configure(with: vacancy)
    }
}
