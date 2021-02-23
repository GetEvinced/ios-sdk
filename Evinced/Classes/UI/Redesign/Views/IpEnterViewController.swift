//
//  IpEnterViewController.swift
//  Evinced
//
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import UIKit

class IpEnterViewController: UIViewController {
    private let viewModel: IpEnterViewModel
    private var observations: [NSKeyValueObservation] = []
    
    private let titleLabel: UILabel = .titleLabel()
    
    private let scanButton: UIButton = .primaryButton()
    
    private let cantScanLabel = UILabel()
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
}

private extension IpEnterViewController {
    
    func setupUi() {
        view.backgroundColor = .white
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        let qrImageView = UIImageView(image: UIImage.bundledImage(named: "qr-read"))
        qrImageView.isAccessibilityElement = false
        qrImageView.contentMode = .center
        
        scanButton.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        cantScanLabel.font = .systemFont(ofSize: 16.0)
        cantScanLabel.translatesAutoresizingMaskIntoConstraints = false
        
        manualButton.translatesAutoresizingMaskIntoConstraints = false
        
        let horizonatalStackView = UIStackView(arrangedSubviews: [UIView(), cantScanLabel, manualButton, UIView()])
        
        horizonatalStackView.axis = .horizontal
        horizonatalStackView.spacing = 10.0
        
        horizonatalStackView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, qrImageView, scanButton, horizonatalStackView])

        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.setCustomSpacing(30.0, after: scanButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            scanButton.heightAnchor.constraint(equalToConstant: 48.0),
            horizonatalStackView.heightAnchor.constraint(equalToConstant: 30.0),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0)
        ])
    }
    
    func bindViewModel() {
        titleLabel.text = viewModel.titleText
        scanButton.setTitle(viewModel.scanButtonText, for: .normal)
        cantScanLabel.text = viewModel.cantScanText
        
        let manualAttributed = NSAttributedString(string: viewModel.enterIpButtonText,
                                                  attributes: [.font: UIFont.systemFont(ofSize: 16.0),
                                                               .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                               .foregroundColor: UIColor.darkGreen])
        manualButton.setAttributedTitle(manualAttributed, for: .normal)
        
        scanButton.addTarget(self,
                             action: #selector(onScanTap),
                             for: .touchUpInside)
        manualButton.addTarget(self,
                               action: #selector(onManualTap),
                               for: .touchUpInside)
    }
    
    @objc func onScanTap() {
        viewModel.qrReadPressed()
    }
    
    @objc func onManualTap() {
        viewModel.manualEnterPressed()
    }
}
