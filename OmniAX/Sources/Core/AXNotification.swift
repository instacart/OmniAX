//
//  AXNotification.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public enum AXNotification {
    case announcement
    case layoutChanged
    case pageScrolled
    case pauseAssistance
    case resumeAssistance
    case screenChanged

    var mappedValue: UIAccessibilityNotifications {
        switch self {
        case .announcement:
            return UIAccessibilityAnnouncementNotification
        case .layoutChanged:
            return UIAccessibilityLayoutChangedNotification
        case .pageScrolled:
            return UIAccessibilityPageScrolledNotification
        case .pauseAssistance:
            return UIAccessibilityPauseAssistiveTechnologyNotification
        case .resumeAssistance:
            return UIAccessibilityResumeAssistiveTechnologyNotification
        case .screenChanged:
            return UIAccessibilityScreenChangedNotification
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
