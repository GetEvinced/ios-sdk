//
//  LogRowCell.swift
//  Evinced
//
//  Created by Roy Zarchi on 31/08/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

class LogRowCell: UITableViewCell {
    @IBOutlet weak var logRow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
}
