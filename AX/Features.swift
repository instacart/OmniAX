//
//  AX+Features.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct Features: OptionSet {
    public let rawValue: UInt64

    public static let highContrast     = Features(rawValue: 1 << 0)
    public static let reduceMotion     = Features(rawValue: 1 << 1)
    public static let voiceOver        = Features(rawValue: 1 << 2)

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    var systemCheckEnabled: Bool? {
        if self == .highContrast {
            return UIAccessibilityDarkerSystemColorsEnabled()
        } else if self == .reduceMotion {
            return UIAccessibilityIsReduceMotionEnabled()
        } else if self == .voiceOver {
            return UIAccessibilityIsVoiceOverRunning()
        }
        return nil
    }

    public enum EnabledCheckType {
        case any
        case all
    }
}
