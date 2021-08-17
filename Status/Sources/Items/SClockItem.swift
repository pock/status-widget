//
//  SClockItem.swift
//  Pock
//
//  Created by Pierluigi Galdi on 23/02/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit
import TinyConstraints

internal class SClockItem: StatusItem {
    
    /// Core
    private var refreshTimer: Timer?
    
    /// UI
    private var clockLabel: NSTextField! = NSTextField(labelWithString: "…")
    
    init() {
		print("[Status]: init SClockItem")
        didLoad()
    }
    
    deinit {
        didUnload()
		print("[Status]: deinit SClockItem")
    }
    
    func didLoad() {
        // Required else it will lose reference to button currently being displayed
        if clockLabel == nil {
            clockLabel = NSTextField(labelWithString: "…")
        }
        clockLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        clockLabel.maximumNumberOfLines = 1
        reload()
		refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, repeats: true, action: { [weak self] in
			self?.reload()
		})
    }
    
    func didUnload() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    var enabled: Bool{ return Preferences[.shouldShowDateItem] }
    
    var title: String  { return "clock" }
    
    var view: NSView { return clockLabel }
    
    func action() {
        /** nothing to do here */
    }
    
    @objc func reload() {
        let formatter = DateFormatter()
        formatter.dateFormat = Preferences[.timeFormatTextField]
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US_POSIX")
        clockLabel?.stringValue = formatter.string(from: Date())
        clockLabel?.sizeToFit()
    }
    
}
