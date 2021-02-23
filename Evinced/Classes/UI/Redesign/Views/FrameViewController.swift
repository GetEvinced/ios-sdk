//
//  FrameViewController.swift
//  Evinced
//
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import UIKit

class FrameViewController: UIViewController {
    
    @objc dynamic private let viewModel: FrameViewModel
    private var pageObservation: NSKeyValueObservation?
    private var dismissObservation: NSKeyValueObservation?
    
    private weak var routingDelegate: RoutingDelegate?
    private let pageViewProvider: PageViewProvider
    
    private let logoImageView = UIImageView(image: UIImage.bundledImage(named: "evinced-logo"))
    
    private let closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage.bundledImage(named: "close"),
                             for: .normal)
        return closeButton
    }()
    
    private lazy var topView = UIStackView(arrangedSubviews: [logoImageView, closeButton])
    
    private lazy var topHideConstraint: NSLayoutConstraint = {
        topView.heightAnchor.constraint(equalToConstant: .zero)
    }()
    
    private let containerController = UINavigationController()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: FrameViewModel,
         routingDelegate: RoutingDelegate,
         pageViewProvider: PageViewProvider) {
        self.viewModel = viewModel
        self.routingDelegate = routingDelegate
        self.pageViewProvider = pageViewProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        bindViewModel()
    }
}

extension FrameViewController: ErrorMessageDelegate {
    func errorMessage(_ message: String, actionHandler: @escaping () -> Void) {
        let alertViewController = UIAlertController(title: "Sorry",
                                                    message: message,
                                                    preferredStyle: .alert)
        
        alertViewController.addAction(
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: { _ in actionHandler()})
        )
        
        present(alertViewController, animated: true)
    }
}

private extension FrameViewController {
    
    func setupUi() {
        view.backgroundColor = .white
        if #available(iOS 13, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let setupStackSubview: (UIView) -> Void = { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        setupStackSubview(logoImageView)
        setupStackSubview(closeButton)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 20.0),
            logoImageView.widthAnchor.constraint(equalToConstant: 150.0),
            closeButton.heightAnchor.constraint(equalToConstant: 15.0),
            closeButton.widthAnchor.constraint(equalToConstant: 15.0)
        ])
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.axis = .horizontal
        topView.alignment = .center
        topView.distribution = .equalCentering
        
        view.addSubview(topView)
        let heightConstraint = topView.heightAnchor.constraint(equalToConstant: 60.0)
        heightConstraint.priority = .required - 1.0
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            heightConstraint
        ])
        
        containerController.setNavigationBarHidden(true, animated: false)
        
        guard let navigationView = containerController.view else {
            assertionFailure("No view in navigation view")
            return
        }
        
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bindViewModel() {
        closeButton.addTarget(self, action: #selector(onCloseTap), for: .touchUpInside)
        
        processPageViewModel(viewModel.page, animated: false)
        
        pageObservation = observe(\.viewModel.page, options: [.new]) { [weak self] _, change in
            guard let self = self,
                  let pageViewModel = change.newValue else { return }
            self.processPageViewModel(pageViewModel, animated: true)
        }
        
        dismissObservation = observe(\.viewModel.dismiss, options: [.new]) { [weak self] _, change in
            guard let self = self,
                  let shouldDismiss = change.newValue,
                  shouldDismiss == true else { return }
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    func processPageViewModel(_ pageModel: PageViewModel, animated: Bool) {
        topHideConstraint.isActive = pageModel.isFullScreen
        
        let pageViewController = pageViewProvider.viewController(for: pageModel)
        
        if let errorMessageSource = pageModel as? ErrorMessageSource {
            errorMessageSource.errorMessageDelegate = self
        }
        
        containerController.setViewControllers([pageViewController],
                                                animated: animated)
    }
    
    @objc func onCloseTap() {
        viewModel.closePressed()
    }
}

