//
//  Preferences.swift
//  Status
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Defaults

extension NSNotification.Name {
    static let shouldReloadStatusWidget = NSNotification.Name("shouldReloadStatusWidget")
}

extension Defaults.Keys {
	static let shouldShowLangItem		   = Defaults.Key<Bool>("shouldShowLangItem",		   default: true)
    static let shouldShowWifiItem          = Defaults.Key<Bool>("shouldShowWifiItem",          default: true)
    static let shouldShowPowerItem         = Defaults.Key<Bool>("shouldShowPowerItem",         default: true)
    static let shouldShowBatteryIcon       = Defaults.Key<Bool>("shouldShowBatteryIcon",       default: true)
    static let shouldShowBatteryPercentage = Defaults.Key<Bool>("shouldShowBatteryPercentage", default: true)
    static let shouldShowDateItem          = Defaults.Key<Bool>("shouldShowDateItem",          default: true)
    static let timeFormatTextField         = Defaults.Key<String>("timeFormatTextField",       default: "EE dd MMM HH:mm")
}
