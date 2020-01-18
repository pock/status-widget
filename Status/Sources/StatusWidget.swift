//
//  StatusWidget.swift
//  Status
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit
import PockKit

class StatusWidget: PKWidget {
    
    var identifier: NSTouchBarItem.Identifier = NSTouchBarItem.Identifier(rawValue: "StatusWidget")
    var customizationLabel: String = "Status"
    var view: NSView!
    
    required init() {
        self.view = PKButton(title: "Status", target: self, action: #selector(printMessage))
    }
    
    @objc private func printMessage() {
        NSLog("[StatusWidget]: Hello, World!")
    }
    
}
