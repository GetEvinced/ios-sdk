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
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        return cancelButton
    }()
    
    init(viewModel: QrReadViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        setupPreview()
        
        setupUi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        for metadataObject in metadataObjects {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue,
                  validateIpAddress(ipToValidate: stringValue) else { continue }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            viewModel.qrDidRead(stringValue)
            
            captureSession.stopRunning()
            break
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

private extension ScannerViewController {
    
    func setupUi() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24.0),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0)
        ])
        
        cancelButton.addTarget(self,
                               action: #selector(onCancelTap(_:)),
                               for: .touchUpInside)
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
        
        captureSession = AVCaptureSession()
        
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

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
        view.bringSubviewToFront(cancelButton)
    }
    
    @objc func onCancelTap(_ sender: Any?) {
        captureSession.stopRunning()
        viewModel.backPressed()
    }
}
