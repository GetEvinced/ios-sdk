//
//  IpEnterViewController.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import UIKit

class IpEnterViewController: UIViewController {
    private let viewModel: IpEnterViewModel
    private var observations: [NSKeyValueObservation] = []
    
    private let titleLabel: UILabel = .titleLabel()
    
    private let scanButton: UIButton = .primaryButton()
    private let manualButton = UIButton(type: .system)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: IpEnterViewModel) {
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
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        let qrImageView = UIImageView(image: UIImage.bundledImage(named: "qr-read"))
        qrImageView.isAccessibilityElement = false
        qrImageView.contentMode = .center
        
        scanButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        manualButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

        let stackView = UIStackView(arrangedSubviews: [titleLabel, qrImageView, scanButton, manualButton])

        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.setCustomSpacing(30.0, after: scanButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            scanButton.heightAnchor.constraint(equalToConstant: 48.0),
            manualButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0)
        ])
    }
    
    private func bindViewModel() {
        titleLabel.text = viewModel.titleText
        scanButton.setTitle(viewModel.scanButtonText, for: .normal)
        manualButton.setTitle(viewModel.enterIpButtonText, for: .normal)
        
        scanButton.addTarget(self,
                             action: #selector(onScanTap),
                             for: .touchUpInside)
        manualButton.addTarget(self,
                               action: #selector(onManualTap),
                               for: .touchUpInside)
    }
    
    @objc private func onScanTap() {
        viewModel.qrReadPressed()
    }
    
    @objc private func onManualTap() {
        viewModel.manualEnterPressed()
    }
}
