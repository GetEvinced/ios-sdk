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
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let successHandler: (String) -> Void
    private let failHandler: () -> Void
    private let cancelHandler: () -> Void
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        return cancelButton
    }()
    
    init(successHandler: @escaping (String) -> Void,
         failHandler: @escaping () -> Void,
         cancelHandler: @escaping () -> Void) {
        self.successHandler = successHandler
        self.failHandler = failHandler
        self.cancelHandler = cancelHandler
        
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

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            successHandler(stringValue)
        }

        cancelHandler()
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
        func dispatchFailure() {
            let failHandler = self.failHandler
            DispatchQueue.main.async {
               failHandler()
            }
        }

        guard Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") != nil else {
            dispatchFailure()
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .denied, .restricted:
            dispatchFailure()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] in
                guard $0 else {
                    dispatchFailure()
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setupPreview()
                }
            }
            return
        @unknown default:
            dispatchFailure()
            return
        }
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            dispatchFailure()
            return
        }

        captureSession.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()

        guard captureSession.canAddOutput(metadataOutput) else {
            dispatchFailure()
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
        cancelHandler()
    }
}
