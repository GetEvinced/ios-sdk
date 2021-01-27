//
//  ConnectionStatusViewController.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class ConnectionStatusViewController: UIViewController {
    
    private let checkmarkImageView: UIImageView = {
        let checkmarkImageView = UIImageView(image: UIImage.bundledImage(named: "checkmark"))
        checkmarkImageView.isAccessibilityElement = false
        return checkmarkImageView
    }()
    
    private let connectingLabel: UILabel = UILabel()
    
    private let disconnectButton: UIButton = .secondaryButton()
    
    private let exclamationMarkImageView: UIImageView = {
        let exclamationMarkImageView = UIImageView(image: UIImage.bundledImage(named: "exclamation-mark"))
        exclamationMarkImageView.isAccessibilityElement = false
        return exclamationMarkImageView
    }()
    
    private let switchControlLabel: UILabel = UILabel()
    
    private let switchControlButton: UIButton = .primaryButton()
    
    @objc dynamic private let viewModel: ConnectionStatusViewModel
    
    private var connectionTextObservation: NSKeyValueObservation?
    private var switchControlObservation: NSKeyValueObservation?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: ConnectionStatusViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
        setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.shouldDisappear()
    }
}

private extension ConnectionStatusViewController {
    
    func setupUi() {
        view.backgroundColor = .white
        
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkmarkImageView)
        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 22.0),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 22.0),
            checkmarkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            checkmarkImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0)
        ])
        
        connectingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectingLabel)
        NSLayoutConstraint.activate([
            connectingLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10.0),
            connectingLabel.topAnchor.constraint(equalTo: checkmarkImageView.topAnchor),
            connectingLabel.bottomAnchor.constraint(greaterThanOrEqualTo: checkmarkImageView.bottomAnchor),
            connectingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        ])
        
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(disconnectButton)
        NSLayoutConstraint.activate([
            disconnectButton.leadingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor),
            disconnectButton.topAnchor.constraint(equalTo: connectingLabel.bottomAnchor, constant: 17.0),
            disconnectButton.trailingAnchor.constraint(equalTo: connectingLabel.trailingAnchor),
            disconnectButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        exclamationMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exclamationMarkImageView)
        NSLayoutConstraint.activate([
            exclamationMarkImageView.leadingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor),
            exclamationMarkImageView.trailingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor),
            exclamationMarkImageView.heightAnchor.constraint(equalTo: checkmarkImageView.heightAnchor)
        ])
        
        switchControlLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchControlLabel)
        NSLayoutConstraint.activate([
            switchControlLabel.leadingAnchor.constraint(equalTo: connectingLabel.leadingAnchor),
            switchControlLabel.topAnchor.constraint(equalTo: exclamationMarkImageView.topAnchor),
            switchControlLabel.bottomAnchor.constraint(greaterThanOrEqualTo: exclamationMarkImageView.bottomAnchor),
            switchControlLabel.trailingAnchor.constraint(equalTo: connectingLabel.trailingAnchor)
        ])
        
        switchControlButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchControlButton)
        NSLayoutConstraint.activate([
            switchControlButton.leadingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor),
            switchControlButton.topAnchor.constraint(equalTo: switchControlLabel.bottomAnchor, constant: 25.0),
            switchControlButton.trailingAnchor.constraint(equalTo: connectingLabel.trailingAnchor),
            switchControlButton.heightAnchor.constraint(equalToConstant: 48.0),
            switchControlButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -30.0)
        ])
        
        connectingLabel.numberOfLines = 0
        switchControlLabel.numberOfLines = 0
    }
    
    func setupBindings() {
        connectingLabel.text = viewModel.connectionText
        connectionTextObservation = observe(\.viewModel.connectionText, options: [.new]) { [weak self] object, change in
            guard let self = self, let newText = change.newValue else { return }
            self.connectingLabel.text = newText
        }
        
        disconnectButton.setTitle(viewModel.disconnectButtonText, for: .normal)
        disconnectButton.addTarget(self,
                                   action: #selector(onDisconnectTap),
                                   for: .touchUpInside)
        
        setSwitchViewsHidden(viewModel.isSwitchViewHidden)
        switchControlObservation = observe(\.viewModel.isSwitchViewHidden, options: [.new]) { [weak self] object, change in
            guard let self = self, let hidden = change.newValue else { return }
            self.setSwitchViewsHidden(hidden)
        }
        
        switchControlLabel.text = viewModel.enableSwitchText
        
        switchControlButton.setTitle(viewModel.enableSwitchButtonText, for: .normal)
        switchControlButton.addTarget(self,
                                      action: #selector(onSwitchControlTap),
                                      for: .touchUpInside)
    }
    
    func setSwitchViewsHidden(_ hidden: Bool) {
        exclamationMarkImageView.isHidden = hidden
        switchControlLabel.isHidden = hidden
        switchControlButton.isHidden = hidden
    }
    
    @objc func onDisconnectTap() {
        viewModel.disconnectPressed()
    }
    
    @objc func onSwitchControlTap() {
        viewModel.switchPressed()
    }
}
