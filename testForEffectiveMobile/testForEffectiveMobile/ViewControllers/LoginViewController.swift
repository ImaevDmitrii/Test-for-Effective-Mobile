//
//  LoginViewController.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class LoginViewController: UIViewController, TabBarInteractionControllable {
    
    var shouldDisableTabBarInteractions: Bool {
        true
    }
    
    private var coordinator: NavigationCoordinator {
        NavigationCoordinator(navigationController: navigationController)
    }

    private let tabBar: UITabBar
    
    private let titleLabel = UILabel()
    private let jobLabel = UILabel()
    private let employeeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let invalidEmailLabel = UILabel()
    
    private let emailTextField = CustomTextField(padding: 8)
    
    private let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
    private let clearButtonIcon = UIImage(systemName: "xmark")?.withTintColor(.customGrey4, renderingMode: .alwaysOriginal)
    
    private let jobSearchView = UIView()
    private let employeeSearchView = UIView()
    
    private let buttonStackView = UIStackView()
    
    private let clearButton = UIButton(type: .custom)
    private let continueButton = UIButton()
    private let loginButton = UIButton()
    private let findEmployeeButton = UIButton()
    
    private let cornerRadius: CGFloat = 10
    private let bigPadding: CGFloat = 24
    private let padding: CGFloat = 16
    
    init() {
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
    }
    
    private func setupNC() {
        navigationController?.setupNavigationBar()
    }
    
    private func setupUI() {
        view.addSubview(tabBar)
        
        [titleLabel, jobSearchView, employeeSearchView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.text = Localization.login
        titleLabel.textColor = .white
        titleLabel.font = .title2
        
        createJobSearchView()
        createEmployeeSearchView()
        
        let titleTopPadding: CGFloat = 37
        let titleLeadingPadding: CGFloat = 19
        let padding: CGFloat = 17
        let spacing: CGFloat = 20
        let jobViewSpacing: CGFloat = 110
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: titleLeadingPadding),
            
            jobSearchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: jobViewSpacing),
            jobSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            jobSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            employeeSearchView.topAnchor.constraint(equalTo: jobSearchView.bottomAnchor, constant: spacing),
            employeeSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            employeeSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    private func createJobSearchView() {
        [jobLabel, buttonStackView, emailTextField, invalidEmailLabel].forEach {
            jobSearchView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        jobSearchView.backgroundColor = .customGrey1
        jobSearchView.layer.cornerRadius = cornerRadius
        
        jobLabel.text = Localization.searchJob
        jobLabel.textColor = .white
        jobLabel.font = .title3
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGrey4]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: Localization.email, attributes: placeholderAttributes)
        emailTextField.backgroundColor = .customGrey2
        emailTextField.layer.cornerRadius = cornerRadius
        emailTextField.leftView = emailIcon
        emailTextField.leftViewMode = .always
        emailTextField.rightView = clearButton
        emailTextField.rightViewMode = .whileEditing
        emailTextField.tintColor = .customGrey4
        emailTextField.textColor = .customGrey4
        
        emailIcon.tintColor = .customGrey4
        
        clearButton.setImage(clearButtonIcon, for: .normal)
        clearButton.addTarget(self, action: #selector(clearEmailField), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        
        invalidEmailLabel.textColor = .customRed
        invalidEmailLabel.text = Localization.invalidEmailError
        invalidEmailLabel.font = .buttonText2
        invalidEmailLabel.isHidden = true
        
        continueButton.setTitle(Localization.continueText, for: .normal)
        continueButton.titleLabel?.font = .buttonText2
        continueButton.backgroundColor = .customBlue
        continueButton.layer.cornerRadius = cornerRadius
        continueButton.alpha = 0.5
        continueButton.isEnabled = false
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        continueButton.setTitleColor(.white, for: .normal)
        
        loginButton.setTitle(Localization.loginWithPassword, for: .normal)
        loginButton.titleLabel?.font = .buttonText2
        loginButton.setTitleColor(.customBlue, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 14
        
        [continueButton, loginButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        let topSpacing: CGFloat = 30
        let size: CGFloat = 40
        let invalidEmailSpacing: CGFloat = 5
        
        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: jobSearchView.topAnchor, constant: bigPadding),
            jobLabel.leadingAnchor.constraint(equalTo: jobSearchView.leadingAnchor, constant: padding),
            
            emailTextField.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: topSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: jobSearchView.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: jobSearchView.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: size),
            
            invalidEmailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: invalidEmailSpacing),
            invalidEmailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            invalidEmailLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: topSpacing),
            buttonStackView.leadingAnchor.constraint(equalTo: jobSearchView.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: jobSearchView.trailingAnchor, constant: -padding),
            buttonStackView.bottomAnchor.constraint(equalTo: jobSearchView.bottomAnchor, constant: -bigPadding),
            
            continueButton.heightAnchor.constraint(equalToConstant: size),
            loginButton.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    private func createEmployeeSearchView() {
        [employeeLabel, descriptionLabel, findEmployeeButton].forEach {
            employeeSearchView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        employeeSearchView.backgroundColor = .customGrey1
        employeeSearchView.layer.cornerRadius = cornerRadius
        
        employeeLabel.text = Localization.searchEmployee
        employeeLabel.textColor = .white
        employeeLabel.font = .title3
        
        descriptionLabel.text = Localization.jobDescription
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = .title3
        descriptionLabel.numberOfLines = 0
        
        findEmployeeButton.setTitle(Localization.iSearchEmployee, for: .normal)
        findEmployeeButton.titleLabel?.font = .buttonText2
        findEmployeeButton.backgroundColor = .customGreen
        findEmployeeButton.layer.cornerRadius = 16
        findEmployeeButton.setTitleColor(.white, for: .normal)
        
        let spacing: CGFloat = 22
        let size: CGFloat = 32
        
        NSLayoutConstraint.activate([
            employeeLabel.topAnchor.constraint(equalTo: employeeSearchView.topAnchor, constant: bigPadding),
            employeeLabel.leadingAnchor.constraint(equalTo: employeeSearchView.leadingAnchor, constant: padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: employeeLabel.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: employeeSearchView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: employeeSearchView.trailingAnchor, constant: -padding),
            
            findEmployeeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            findEmployeeButton.leadingAnchor.constraint(equalTo: employeeSearchView.leadingAnchor, constant: padding),
            findEmployeeButton.trailingAnchor.constraint(equalTo: employeeSearchView.trailingAnchor, constant: -padding),
            findEmployeeButton.bottomAnchor.constraint(equalTo: employeeSearchView.bottomAnchor, constant: -bigPadding),
            findEmployeeButton.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    @objc private func clearEmailField() {
        emailTextField.text = ""
        validateEmail()
    }
    
    @objc private func emailTextChanged() {
        validateEmail()
    }
    
    @objc private func continueButtonTapped() {
        guard let email = emailTextField.text, isValidEmail(email) else {
            showInvalidEmailError()
            return
        }
        coordinator.showCodeVerificationVC(email: email)
    }
    
    @objc private func loginButtonTapped() {
        
    }
    
    private func validateEmail() {
        guard let email = emailTextField.text, !email.isEmpty else {
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
            invalidEmailLabel.isHidden = true
            setTextFieldBorderColor(emailTextField, color: .clear)
            return
        }
        if isValidEmail(email) {
            continueButton.isEnabled = true
            continueButton.alpha = 1.0
            invalidEmailLabel.isHidden = true
            setTextFieldBorderColor(emailTextField, color: .clear)
        } else {
            showInvalidEmailError()
        }
    }
    
    private func showInvalidEmailError() {
        invalidEmailLabel.isHidden = false
        setTextFieldBorderColor(emailTextField, color: .customRed)
    }
    
    private func setTextFieldBorderColor(_ textField: UITextField, color: UIColor) {
        textField.layer.borderColor = color.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = cornerRadius
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
