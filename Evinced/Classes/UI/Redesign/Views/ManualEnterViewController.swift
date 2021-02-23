//
//  ManualEnterViewController.swift
//  Evinced
//
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import UIKit

class ManualEnterViewController: UIViewController {
    @objc dynamic private let viewModel: ManualEnterViewModel
    private var observation: NSKeyValueObservation?
    
    private let containerView = UIView()
    
    private let titleLabel: UILabel = .titleLabel()
    private let urlTextField = UITextField()
    
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

extension ManualEnterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil);
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil);
    }
    
   func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    func setupTextField() {
        urlTextField.backgroundColor = .evincedLightGray
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        urlTextField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        urlTextField.clipsToBounds = true
        
        urlTextField.leftView = UIView(frame: CGRect(x: .zero,
                                                     y: .zero,
                                                     width: 10.0,
                                                     height: .zero))
        urlTextField.leftViewMode = .always
        
        urlTextField.keyboardType = .asciiCapable
        urlTextField.autocorrectionType = .no
        urlTextField.autocapitalizationType = .none
        urlTextField.delegate = self
        
        let urlFieldLayer = urlTextField.layer
        urlFieldLayer.borderWidth = 1.0
        urlFieldLayer.borderColor = UIColor.evincedGray.cgColor
        urlFieldLayer.cornerRadius = 4.0
    }
    
    func horizontalStack() -> UIStackView {
        let horizontalStackView = UIStackView(arrangedSubviews: [backButton, connectButton])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 15.0
        horizontalStackView.distribution = .fillEqually
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        setupTitleLabel()
        setupTextField()
        
        return horizontalStackView
    }
    
    func vericalStack() -> UIStackView {
        let vericalStackView = UIStackView(arrangedSubviews: [titleLabel, urlTextField, horizontalStack()])

        vericalStackView.axis = .vertical
        vericalStackView.spacing = 24.0
        vericalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return vericalStackView
    }
    
    func bindViewModel() {
        titleLabel.text = viewModel.titleText
        
        urlTextField.text = viewModel.ipText
        
        connectButton.isEnabled = viewModel.isConnectEnabled
        observation = observe(\.viewModel.isConnectEnabled, options: [.new]) { [weak self] object, change in
            guard let self = self, let isEnabled = change.newValue else { return }
            self.connectButton.isEnabled = isEnabled
        }
        
        urlTextField.addTarget(self,
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
    
    func animateWithKeyboard(
            notification: NSNotification,
            animations: ((_ keyboardFrame: CGRect) -> Void)?
        ) {
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo?[durationKey] as? Double ?? .zero
        
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrame = notification.userInfo?[frameKey] as? CGRect ?? .zero
        
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveRawValue = notification.userInfo?[curveKey] as? Int ?? 0
        let curve = UIView.AnimationCurve(rawValue: curveRawValue) ?? .easeIn

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrame)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }
        
        // Start the animation
        animator.startAnimation()
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let buttonBottom = view.convert(CGPoint(x: connectButton.bounds.width,
                                                y: connectButton.bounds.height),
                                        from: connectButton)
        
        let bottomDistance = view.bounds.height - buttonBottom.y
        
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.topConstraint?.constant = bottomDistance - keyboardFrame.height - 10.0
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        animateWithKeyboard(notification: notification) { (keyboardFrame) in
            self.topConstraint?.constant = .zero
        }
    }
}
