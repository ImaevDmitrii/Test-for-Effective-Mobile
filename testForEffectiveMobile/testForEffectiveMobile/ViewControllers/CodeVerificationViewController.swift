//
//  CodeVerificationViewController.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class CodeVerificationViewController: UIViewController, TabBarInteractionControllable {
    
    var shouldDisableTabBarInteractions: Bool {
        true
    }
    
    private var coordinator: NavigationCoordinator {
        NavigationCoordinator(navigationController: navigationController)
    }
    
    private let instructionLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let codeStackView = UIStackView()
    private var codeTextFields: [UITextField] = []
    private let verifyButton = UIButton()
    
    private let email: String
    private let tabBar: UITabBar
    
    init(email: String) {
        self.email = email
        let tabBarVC = TabBarViewController()
        self.tabBar = tabBarVC.tabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNC()
    }
    
    private func setupNC() {
        navigationController?.setupNavigationBar()
        navigationController?.setupBackButton(action: #selector(backButtonTapped), target: self)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(tabBar)
        
        [instructionLabel, descriptionLabel, codeStackView, verifyButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        instructionLabel.text = "\(Localization.codeSent) \(email)"
        instructionLabel.textColor = .white
        instructionLabel.font = .title2
        
        descriptionLabel.text = Localization.codeVerificationDescription
        descriptionLabel.textColor = .white
        descriptionLabel.font = .title3
        descriptionLabel.numberOfLines = 0
        
        codeStackView.axis = .horizontal
        codeStackView.spacing = 8
        
        for _ in 0..<4 {
            let textField = createCodeTextField()
            textField.tintColor = .white
            codeTextFields.append(textField)
            codeStackView.addArrangedSubview(textField)
        }
        
        verifyButton.setTitle(Localization.confirm, for: .normal)
        verifyButton.backgroundColor = .customBlue
        verifyButton.layer.cornerRadius = 10
        verifyButton.alpha = 0.5
        verifyButton.isEnabled = false
        verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        
        let spacing: CGFloat = 16
        let topPadding: CGFloat = 135
        let padding: CGFloat = 14
        let instuctionTrailingPadding: CGFloat = 25
        let descriptionTrailingPadding: CGFloat = 21
        let buttonTrailingPadding: CGFloat = 19
        let buttonSize: CGFloat = 48
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -instuctionTrailingPadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -descriptionTrailingPadding),
            
            codeStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: spacing),
            codeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            verifyButton.topAnchor.constraint(equalTo: codeStackView.bottomAnchor, constant: spacing),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonTrailingPadding),
            verifyButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }
    
    private func createCodeTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.textAlignment = .center
        textField.font = .codeButton
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.codeButton
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "*", attributes: placeholderAttributes)
        
        let textFieldSize: CGFloat = 48
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: textFieldSize),
            textField.heightAnchor.constraint(equalToConstant: textFieldSize)
        ])
        
        return textField
    }
    
    @objc private func verifyButtonTapped() {
        coordinator.showMainVC()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateVerifyButtonState() {
        let isCodeComplete = codeTextFields.allSatisfy { $0.text?.count == 1 }
        verifyButton.isEnabled = isCodeComplete
        verifyButton.alpha = isCodeComplete ? 1.0 : 0.5
    }
}

// MARK: UITextFieldDelegate

extension CodeVerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        if newLength > 1 {
            return false
        }
        
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        textField.text = string
        if string.count == 1 {
            if let nextTextField = codeTextFields.first(where: { $0.text?.isEmpty ?? true }) {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if string.isEmpty {
            if let previousTextField = codeTextFields.last(where: { $0 != textField && $0.text?.isEmpty == false }) {
                previousTextField.becomeFirstResponder()
            }
        }
        updateVerifyButtonState()
        return false
    }
}
