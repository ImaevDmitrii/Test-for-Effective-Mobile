//
//  SearchHeaderCollectionReusableView.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class SearchHeaderCollectionReusableView: UICollectionReusableView {
    
    private let searchTextField = CustomTextField(padding: 8)
    private let filterButton = UIButton()
    
    private let buttonIcon = UIImage(systemName: "slider.horizontal.3")
    private let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    private let heigh: CGFloat = 40
    private let spacing: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [searchTextField, filterButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .customGrey2
            $0.layer.cornerRadius = 8
        }
        
        searchIcon.tintColor = .customGrey4
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        searchTextField.placeholder = ("\(Localization.position), \(Localization.keywords)")
        searchTextField.font = .text1
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: searchTextField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGrey4]
        )
        searchTextField.backgroundColor = .customGrey2
        searchTextField.leftView = searchIcon
        searchTextField.leftViewMode = .always
        searchTextField.rightViewMode = .whileEditing
        searchTextField.tintColor = .customGrey4
        searchTextField.textColor = .customGrey4

        filterButton.setImage(buttonIcon, for: .normal)
        filterButton.tintColor = .white
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: heigh),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -spacing),
            
            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: heigh),
            filterButton.widthAnchor.constraint(equalToConstant: heigh)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            searchTextField.leftViewMode = .always
        } else {
            searchTextField.leftViewMode = .never
        }
    }
}

private extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
