//
//  UIAccessibility.Notification+OmniAX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

extension UIAccessibility.Notification {
    var isVoiceOverSpecific: Bool {
        switch self {
        case .announcement, .layoutChanged, .pageScrolled, .screenChanged:
            return true
        default:
            return false
        }
    }
}
