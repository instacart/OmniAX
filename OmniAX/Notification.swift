//
//  Notification.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public enum Notification {
    case announcement
    case layoutChanged
    case pageScrolled
    case pauseAssistance
    case resumeAssistance
    case screenChanged

    var mappedValue: UIAccessibility.Notification {
        switch self {
        case .announcement:
            return UIAccessibility.Notification.announcement
        case .layoutChanged:
            return UIAccessibility.Notification.layoutChanged
        case .pageScrolled:
            return UIAccessibility.Notification.pageScrolled
        case .pauseAssistance:
            return UIAccessibility.Notification.pauseAssistiveTechnology
        case .resumeAssistance:
            return UIAccessibility.Notification.resumeAssistiveTechnology
        case .screenChanged:
            return UIAccessibility.Notification.screenChanged
        }
    }

    var isVoiceOverSpecific: Bool {
        switch self {
        case .pauseAssistance, .resumeAssistance:
            return false
        case .announcement, .layoutChanged, .pageScrolled, .screenChanged:
            return true
        }
    }
}
