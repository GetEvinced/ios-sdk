//
//  ScannerViewController.swift
//  Evinced
//
//  Created by Alexandr Lambov on 16.12.2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private let viewModel: QrReadViewModel
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let containerView = UIView()
    
    private let cancelButton: UIButton = UIButton(type: .custom)
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel.titleLabel()
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = UILabel()
    
    init(viewModel: QrReadViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPreview()
        setupUi()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let captureSession = captureSession,
              !captureSession.isRunning else { return }
        
        captureSession.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let captureSession = captureSession,
              captureSession.isRunning else { return }

        captureSession.stopRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        for metadataObject in metadataObjects {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue,
                  validateIpAddress(ipToValidate: stringValue) else { continue }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            viewModel.qrDidRead(stringValue)
            
            captureSession?.stopRunning()
            break
        }
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

private extension ScannerViewController {
    
    func setupUi() {
        view.backgroundColor = .black
        
        cancelButton.setImage(UIImage.bundledImage(named: "back"), for: .normal)
        cancelButton.imageEdgeInsets   = UIEdgeInsets(top: .zero, left: -5.0, bottom: .zero, right:  5.0)
        cancelButton.titleEdgeInsets   = UIEdgeInsets(top: .zero, left:  5.0, bottom: .zero, right: -5.0)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30.0),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            cancelButton.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 40.0),
            titleLabel.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16.0)
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bindViewModel() {
        cancelButton.setTitle(viewModel.backButtonText, for: .normal)
        cancelButton.addTarget(self,
                               action: #selector(onCancelTap(_:)),
                               for: .touchUpInside)
        
        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
    }
    
    func setupPreview() {
//        func dispatchFailure() {
//            let failHandler = self.failHandler
//            DispatchQueue.main.async {
//               failHandler()
//            }
//        }

        guard Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") != nil else {
            viewModel.authorizationIssue()
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .denied, .restricted:
            viewModel.authorizationIssue()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] in
                guard $0 else {
                    self?.viewModel.authorizationIssue()
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setupPreview()
                }
            }
            return
        @unknown default:
            viewModel.authorizationIssue()
            return
        }
        
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            viewModel.authorizationIssue()
            return
        }

        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()

        guard captureSession.canAddOutput(metadataOutput) else {
            viewModel.authorizationIssue()
            return
        }
        
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        view.bringSubviewToFront(containerView)
        
        self.captureSession = captureSession
        self.previewLayer = previewLayer
    }
    
    @objc func onCancelTap(_ sender: Any?) {
        captureSession?.stopRunning()
        viewModel.backPressed()
    }
}
