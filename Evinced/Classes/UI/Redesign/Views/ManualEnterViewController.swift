//
//  ManualEnterViewController.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import UIKit

class ManualEnterViewController: UIViewController {
    @objc dynamic private let viewModel: ManualEnterViewModel
    private var observation: NSKeyValueObservation?
    
    private let containerView = UIView()
    
    private let titleLabel: UILabel = .titleLabel()
    private let ipTextField = UITextField()
    
    private let backButton: UIButton = .secondaryButton()
    private let connectButton: UIButton = .primaryButton()
    
    private var topConstraint: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ManualEnterViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        bindViewModel()
    }
}

private extension ManualEnterViewController {
    
    func setupUi() {
        view.backgroundColor = .white
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = vericalStack()
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 48.0),
            connectButton.heightAnchor.constraint(equalToConstant: 48.0),
            
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        let topConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        self.topConstraint = topConstraint
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil);
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil);
    }
    
   func setupTiitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    func setupTextField() {
        ipTextField.backgroundColor = .evincedLightGray
        ipTextField.translatesAutoresizingMaskIntoConstraints = false
        ipTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        ipTextField.clipsToBounds = true
        
        ipTextField.leftView = UIView(frame: CGRect(x: .zero,
                                                    y: .zero,
                                                    width: 10.0,
                                                    height: .zero))
        ipTextField.leftViewMode = .always
        
        let ipFieldLayer = ipTextField.layer
        ipFieldLayer.borderWidth = 1.0
        ipFieldLayer.borderColor = UIColor.evincedGray.cgColor
        ipFieldLayer.cornerRadius = 4.0
    }
    
    func horizontalStack() -> UIStackView {
        let horizontalStackView = UIStackView(arrangedSubviews: [backButton, connectButton])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 15.0
        horizontalStackView.distribution = .fillEqually
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        setupTiitleLabel()
        setupTextField()
        
        return horizontalStackView
    }
    
    func vericalStack() -> UIStackView {
        let vericalStackView = UIStackView(arrangedSubviews: [titleLabel, ipTextField, horizontalStack()])

        vericalStackView.axis = .vertical
        vericalStackView.spacing = 24.0
        vericalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return vericalStackView
    }
    
    func bindViewModel() {
        titleLabel.text = viewModel.titleText
        
        ipTextField.text = viewModel.ipText
        
        connectButton.isEnabled = viewModel.isConnectEnabled
        observation = observe(\.viewModel.isConnectEnabled, options: [.new]) { [weak self] object, change in
            guard let self = self, let isEnabled = change.newValue else { return }
            self.connectButton.isEnabled = isEnabled
        }
        
        ipTextField.addTarget(self,
                              action: #selector(ipTextChanged(_:)),
                              for: .editingChanged)
        
        backButton.setTitle(viewModel.backButtonText, for: .normal)
        connectButton.setTitle(viewModel.connectButtonText, for: .normal)
        
        backButton.addTarget(self,
                             action: #selector(onBackTap),
                             for: .touchUpInside)
        connectButton.addTarget(self,
                                action: #selector(onManualTap),
                                for: .touchUpInside)
    }
    
    @objc func ipTextChanged(_ textField: UITextField) {
        viewModel.ipText = textField.text
    }
    
    @objc func onBackTap() {
        viewModel.backPressed()
    }
    
    @objc func onManualTap() {
        viewModel.connectPressed()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        topConstraint?.constant = -150.0 // Move view 150 points upward
        view.layoutSubviews()
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        topConstraint?.constant = 0 // Move view to original position
    }
}
