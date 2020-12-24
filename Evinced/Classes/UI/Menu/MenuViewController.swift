//
//  MenuViewController.swift
//  Evinced
//
//  Created by Roy Zarchi on 16/08/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    static var displayed = false
    
    @IBOutlet weak var ipTextfield: UITextField!
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityLabel = "EVINCED_SKIP_RECURSIVE"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupIpTextfield()
        setupLogTableView()
        
        version.text = getVersion() ?? ""
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func D3Display(_ sender: Any) {
        EvincedEngine.scan()
    }
    
    @IBAction func readQR(_ sender: Any) {
        let qrReaderViewController = ScannerViewController(
            successHandler: { [weak self] in
                guard let self = self else { return }
                self.ipTextfield.text = $0
                self.saveAddrBtn(nil)
            },
            failHandler: { [weak self] in
                self?.dismiss(animated: true) { [weak self] in
                    self?.showAlert(title: "Scanning not supported",
                                    bodyText: "Your device does not support scanning a code from an item. Please use a device with a camera, check 'NSCameraUsageDescription' or camera permissions.")
                }
            },
            cancelHandler: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        present(qrReaderViewController, animated: true)
    }
    
    @IBAction func createFullTreeBtn(_ sender: Any) {
        EvincedEngine.smartScan()
    }
    
    @IBAction func saveAddrBtn(_ sender: UIButton?) {
        guard  let ipText = ipTextfield.text,
               validateIpAddress(ipToValidate: ipText) else {
            showAlert(title: "Invalid IP Address",
                      bodyText: "Please enter your desktop ip address without any additions. For example: 10.0.0.6")
            return
        }
        
        Locker.shared.set(ip: ipText)
        
        dismissKeyboard()
    }
    
    @IBAction func clearLogBtn(_ sender: UIButton) {
        Logger.shared.clear()
        dismissKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MenuViewController.displayed = true

        if let ip = Locker.shared.ip {
            ipTextfield.text = ip
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MenuViewController.displayed = false
    }
    
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "EVINCED_LOG_TABLEVIEW_CELL"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Logger.shared.log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell: LogRowCell = self.logTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! LogRowCell
        
        // set the text from the data model
        cell.logRow?.text = Logger.shared.log[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
}

private extension MenuViewController {
    
    func setupIpTextfield() {
        ipTextfield.layer.borderWidth = 1
        ipTextfield.layer.masksToBounds = true
        ipTextfield.layer.borderColor = UIColor.evincedGreen.cgColor
        ipTextfield.textColor = UIColor.evincedGreen
        ipTextfield.layer.cornerRadius = 6
        
        ipTextfield.attributedPlaceholder = NSAttributedString(string: ipTextfield.placeholder ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.evincedGreenOp])
    }
    
    func setupLogTableView() {
        logTableView.delegate = self
        logTableView.dataSource = self
        logTableView.estimatedRowHeight = 44.0
        logTableView.rowHeight = UITableView.automaticDimension
        logTableView.register(UINib(nibName: "LogRowCell", bundle: .init(for: LogRowCell.self)), forCellReuseIdentifier: cellReuseIdentifier)
        logTableView.layer.cornerRadius = 6
        logTableView.layer.borderColor = UIColor.evincedGreen.cgColor
        logTableView.layer.borderWidth = 1
        
        Logger.shared.changed = {
            self.logTableView.reloadData()
        }
    }
    
    func showAlert(title: String, bodyText: String) {
        let alertController = UIAlertController(title: title,
                                                message: bodyText,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default))
        
        self.present(alertController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
