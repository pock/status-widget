//
//  SPowerItem.swift
//  Pock
//
//  Created by Pierluigi Galdi on 23/02/2019.
//  Copyright © 2019 Pierluigi Galdi. All rights reserved.
//

import Foundation
import AppKit
import IOKit.ps

struct SPowerStatus {
	var isCharging: Bool, isCharged: Bool, currentValue: Int
}

internal class SPowerItem: StatusItem {
    
    /// Core
    private var refreshTimer: Timer?
	private var powerStatus: SPowerStatus = SPowerStatus(isCharging: false, isCharged: false, currentValue: 0)
    private var shouldShowBatteryIcon: Bool {
        return Preferences[.shouldShowBatteryIcon]
    }
    private var shouldShowBatteryPercentage: Bool {
        return Preferences[.shouldShowBatteryPercentage]
    }
    
    /// UI
    private let stackView: NSStackView = NSStackView(frame: .zero)
    private let iconView: NSImageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 26, height: 26))
    private let bodyView: NSView      = NSView(frame: NSRect(x: 2, y: 2, width: 21, height: 8))
    private let valueLabel: NSTextField = NSTextField(labelWithString: "-%")
    
    init() {
		print("[Status]: init SPowerItem")
        didLoad()
    }
    
    deinit {
        didUnload()
		print("[Status]: deinit SPowerItem")
    }
    
    func didLoad() {
        bodyView.layer?.cornerRadius = 1
        configureValueLabel()
        configureStackView()
		reload()
		refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, repeats: true, action: { [weak self] in
			self?.reload()
		})
    }
    
    func didUnload() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    var enabled: Bool{ return Preferences[.shouldShowPowerItem] }
    
    var title: String  { return "power" }
    
    var view: NSView { return stackView }
    
    func action() {
        /** nothing to do here */
    }
    
    private func configureValueLabel() {
        valueLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        valueLabel.sizeToFit()
    }
    
    private func configureStackView() {
        stackView.orientation = .horizontal
        stackView.alignment = .centerY
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(iconView)
    }
    
    @objc func reload() {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        for ps in sources {
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]
            if let capacity = info[kIOPSCurrentCapacityKey] as? Int {
                self.powerStatus.currentValue = capacity
            }
            if let isCharging = info[kIOPSIsChargingKey] as? Bool {
                self.powerStatus.isCharging = isCharging
            }
			if let isCharged = info[kIOPSIsChargedKey] as? Bool {
				self.powerStatus.isCharged = isCharged
			}
        }
		self.updateIcon(value: self.powerStatus.currentValue)
    }
    
    private func updateIcon(value: Int) {
        if shouldShowBatteryIcon {
            var iconName: NSImage.Name!
			if powerStatus.isCharged {
				iconView.subviews.forEach({ $0.removeFromSuperview() })
				iconName = "powerIsCharged"
			}else if powerStatus.isCharging {
                iconView.subviews.forEach({ $0.removeFromSuperview() })
                iconName = "powerIsCharging"
            }else {
                iconName = "powerEmpty"
                buildBatteryIcon(withValue: value)
            }
			iconView.image    = Bundle(for: StatusWidget.self).image(forResource: iconName)
            iconView.isHidden = false
        }else {
            iconView.isHidden = true
            iconView.image    = nil
            iconView.subviews.forEach({ $0.removeFromSuperview() })
        }
        valueLabel.stringValue = shouldShowBatteryPercentage ? "\(value)%" : ""
        valueLabel.isHidden    = !shouldShowBatteryPercentage
    }
    
    private func buildBatteryIcon(withValue value: Int) {
        let width = ((CGFloat(value) / 100) * (iconView.frame.width - 7))
        if !iconView.subviews.contains(bodyView) {
            iconView.addSubview(bodyView)
        }
		switch value {
		case 0...20:
			bodyView.layer?.backgroundColor = NSColor.red.cgColor
		default:
			bodyView.layer?.backgroundColor = NSColor.white.cgColor
		}
        bodyView.frame.size.width = max(width, 1.25)
    }
}
