//
//  Preferences.swift
//  Status
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let shouldReloadStatusWidget = NSNotification.Name("shouldReloadStatusWidget")
}

internal struct Preferences {
	internal enum Keys: String {
		case shouldShowLangItem
		case shouldShowWifiItem
		case shouldShowPowerItem
		case shouldShowBatteryIcon
		case shouldShowBatteryPercentage
		case shouldShowDateItem
		case timeFormatTextField
	}
	static subscript<T>(_ key: Keys) -> T {
		get {
			guard let value = UserDefaults.standard.value(forKey: key.rawValue) as? T else {
				switch key {
				case .shouldShowLangItem:
					return false as! T
				case .shouldShowWifiItem:
					return true as! T
				case .shouldShowPowerItem:
					return true as! T
				case .shouldShowBatteryIcon:
					return true as! T
				case .shouldShowBatteryPercentage:
					return false as! T
				case .shouldShowDateItem:
					return true as! T
				case .timeFormatTextField:
					return "EE dd MMM HH:mm" as! T
				}
			}
			return value
		}
		set {
			UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
		}
	}
}
