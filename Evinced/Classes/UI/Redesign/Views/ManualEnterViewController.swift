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
    
    private let titleLabel: UILabel = .titleLabel()
    
    private let ipTextField = UITextField()
    
    private let backButton: UIButton = .secondaryButton()
    private let connectButton: UIButton = .primaryButton()
    
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
    
    private func setupUi() {
        view.backgroundColor = .white
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 160.0),
            connectButton.widthAnchor.constraint(equalToConstant: 160.0)
        ])
        
        let horizontalStackView = UIStackView(arrangedSubviews: [backButton, connectButton])
        horizontalStackView.axis = .horizontal
        
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .equalCentering
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        ipTextField.backgroundColor = UIColor(hex: "#F6F6F6FF")
        ipTextField.translatesAutoresizingMaskIntoConstraints = false
        ipTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ipTextField, horizontalStackView])

        stackView.axis = .vertical
        stackView.spacing = 24.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 48.0),
            connectButton.heightAnchor.constraint(equalToConstant: 48.0),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil);
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil);
    }
    
    private func bindViewModel() {
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
    
    @objc private func ipTextChanged(_ textField: UITextField) {
        viewModel.ipText = textField.text
    }
    
    @objc private func onBackTap() {
        viewModel.backPressed()
    }
    
    @objc private func onManualTap() {
        viewModel.connectPressed()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}
