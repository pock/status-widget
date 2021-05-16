//
//  StatusItem.swift
//  Status
//
//  Created by Pierluigi Galdi on 18/01/2020.
//  Copyright © 2020 Pierluigi Galdi. All rights reserved.
//

import Foundation
import PockKit

class StatusItemView: PKView {
    weak var item: StatusItem?
    override func didTapHandler() {
        item?.action()
    }
}

protocol StatusItem: AnyObject {
    var enabled: Bool   { get }
    var title:   String { get }
    var view:    NSView { get }
    func action()
    func reload()
    func didLoad()
    func didUnload()
}


extension Timer {
	private class TempWrapper {
		var timerAction: () -> ()
		weak var target: AnyObject?
		init(timerAction: @escaping () -> (), target: AnyObject) {
			self.timerAction = timerAction
			self.target = target
		}
	}
	public class func scheduledTimer(timeInterval: TimeInterval, target: AnyObject, repeats: Bool = false, action: @escaping () -> ()) -> Timer {
		return scheduledTimer(
			timeInterval: timeInterval,
			target: self,
			selector: #selector(self._timeAction(timer:)),
			userInfo: TempWrapper(timerAction:action, target: target),
			repeats: repeats
		)
	}
	@objc class func _timeAction(timer: Timer) {
		if let tempWrapper = timer.userInfo as? TempWrapper {
			if let _ = tempWrapper.target {
				tempWrapper.timerAction()
			} else {
				timer.invalidate()
			}
		}
	}
}
