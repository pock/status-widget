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
    
    /// Core
    private var statusElements: [StatusItem] = [
        SWifiItem(),
        SPowerItem(),
        SClockItem()
    ]
    private var statusElementViews: [String: NSView] = [:]
    
    /// UI
    private var stackView: NSStackView!
    
    required init() {
        self.customizationLabel = "Status"
        self.initStackView()
        self.loadStatusElements()
        self.view = stackView
    }
    
    deinit {
        statusElementViews.removeAll()
        for item in statusElements {
            item.didUnload()
        }
        statusElements.removeAll()
    }
    
    func viewDidAppear() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: .shouldReloadStatusWidget, object: nil, queue: .main, using: { [weak self] _ in
            self?.loadStatusElements()
        })
    }
    
    func viewWillDisappear() {
        for item in statusElements {
            item.didUnload()
        }
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
    private func initStackView() {
        stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 100, height: 30))
        stackView.orientation  = .horizontal
        stackView.alignment    = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing      = 8
    }
    
    private func clearStackView() {
        stackView.arrangedSubviews.forEach({ subview in
            stackView.removeView(subview)
        })
    }
    
    private func loadStatusElements() {
        clearStackView()
        statusElements.filter({ $0.enabled }).forEach({ item in
            item.didLoad()
            if let cachedView = statusElementViews[item.title] {
                item.reload()
                stackView.addArrangedSubview(cachedView)
            }else {
                statusElementViews[item.title] = item.view
                item.reload()
                stackView.addArrangedSubview(item.view)
            }
        })
    }
    
    
}
