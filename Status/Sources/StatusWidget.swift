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
import TinyConstraints

extension NSImage {
	/// Returns an NSImage snapshot of the passed view in 2x resolution.
	convenience init?(frame: NSRect, view: NSView) {
		guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: frame) else {
			return nil
		}
		self.init()
		view.cacheDisplay(in: frame, to: bitmapRep)
		addRepresentation(bitmapRep)
		bitmapRep.size = frame.size
	}
}

class StatusWidget: PKWidget {
    
	static var identifier: String = "StatusWidget"
    var customizationLabel: String = "Status"
	var view: NSView!
    
	private var stackView: NSStackView {
		return view as! NSStackView
	}
	private var loadedItems: [StatusItem] = []
	
	var imageForCustomization: NSImage {
		let stackView = NSStackView(frame: .zero)
		stackView.orientation = .horizontal
		stackView.alignment = .centerY
		stackView.distribution = .fill
		stackView.spacing = 8
		if Preferences[.shouldShowLangItem] {
			stackView.addArrangedSubview(SLangItem().view)
		}
		if Preferences[.shouldShowWifiItem] {
			stackView.addArrangedSubview(SWifiItem().view)
		}
		if Preferences[.shouldShowPowerItem] {
			stackView.addArrangedSubview(SPowerItem().view)
		}
		if Preferences[.shouldShowDateItem] {
			stackView.addArrangedSubview(SClockItem().view)
		}
		return NSImage(frame: NSRect(origin: .zero, size: stackView.fittingSize), view: stackView) ?? NSImage()
	}
	
	func prepareForCustomization() {
		clearItems()
	}
	
    required init() {
		view = NSStackView(frame: .zero)
		stackView.orientation = .horizontal
		stackView.alignment = .centerY
		stackView.distribution = .fill
		stackView.spacing = 8
    }
    
    deinit {
		clearItems()
    }
	
    func viewDidAppear() {
		loadStatusElements()
		NotificationCenter.default.addObserver(self, selector: #selector(loadStatusElements), name: .shouldReloadStatusWidget, object: nil)
    }
    
    func viewWillDisappear() {
        clearItems()
		NotificationCenter.default.removeObserver(self)
    }
    
	private func clearItems() {
		for view in stackView.arrangedSubviews {
			stackView.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
		for item in loadedItems {
			item.didUnload()
		}
		loadedItems.removeAll()
	}
	
    @objc private func loadStatusElements() {
		clearItems()
		if Preferences[.shouldShowLangItem] {
			let item = SLangItem()
			loadedItems.append(item)
			stackView.addArrangedSubview(item.view)
		}
		if Preferences[.shouldShowWifiItem] {
			let item = SWifiItem()
			loadedItems.append(item)
			stackView.addArrangedSubview(item.view)
		}
		if Preferences[.shouldShowPowerItem] {
			let item = SPowerItem()
			loadedItems.append(item)
			stackView.addArrangedSubview(item.view)
		}
		if Preferences[.shouldShowDateItem] {
			let item = SClockItem()
			loadedItems.append(item)
			stackView.addArrangedSubview(item.view)
		}
		stackView.height(30)
    }
	
}
