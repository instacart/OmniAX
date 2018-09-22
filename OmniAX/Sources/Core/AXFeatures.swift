//
//  AXFeatures.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct AXFeatures: OptionSet {
    public let rawValue: UInt64

    public static let assistiveTouch        = AXFeatures(rawValue: 1 << 0)
    public static let boldText              = AXFeatures(rawValue: 1 << 1)
    public static let closedCaptioning      = AXFeatures(rawValue: 1 << 2)
    public static let darkerSystemColors    = AXFeatures(rawValue: 1 << 3)
    public static let grayscale             = AXFeatures(rawValue: 1 << 4)
    public static let guidedAccess          = AXFeatures(rawValue: 1 << 5)
    public static let invertColors          = AXFeatures(rawValue: 1 << 6)
    public static let monoAudio             = AXFeatures(rawValue: 1 << 7)
    public static let reduceMotion          = AXFeatures(rawValue: 1 << 8)
    public static let reduceTransparency    = AXFeatures(rawValue: 1 << 9)
    public static let shakeToUndo           = AXFeatures(rawValue: 1 << 10)
    public static let speakScreen           = AXFeatures(rawValue: 1 << 11)
    public static let speakSelection        = AXFeatures(rawValue: 1 << 12)
    public static let switchControl         = AXFeatures(rawValue: 1 << 13)
    public static let voiceOver             = AXFeatures(rawValue: 1 << 14)

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    var systemCheckEnabled: Bool? {
        if self == .assistiveTouch {
            return UIAccessibility.isAssistiveTouchRunning
        } else if self == .boldText {
            return UIAccessibility.isBoldTextEnabled
        } else if self == .closedCaptioning {
            return UIAccessibility.isClosedCaptioningEnabled
        } else if self == .darkerSystemColors {
            return UIAccessibility.isDarkerSystemColorsEnabled
        } else if self == .grayscale {
            return UIAccessibility.isGrayscaleEnabled
        } else if self == .guidedAccess {
            return UIAccessibility.isGuidedAccessEnabled
        } else if self == .invertColors {
            return UIAccessibility.isInvertColorsEnabled
        } else if self == .monoAudio {
            return UIAccessibility.isMonoAudioEnabled
        } else if self == .reduceMotion {
            return UIAccessibility.isReduceMotionEnabled
        } else if self == .reduceTransparency {
            return UIAccessibility.isReduceTransparencyEnabled
        } else if self == .shakeToUndo {
            return UIAccessibility.isShakeToUndoEnabled
        } else if self == .speakScreen {
            return UIAccessibility.isSpeakScreenEnabled
        } else if self == .speakSelection {
            return UIAccessibility.isSpeakSelectionEnabled
        } else if self == .switchControl {
            return UIAccessibility.isSwitchControlRunning
        } else if self == .voiceOver {
            return UIAccessibility.isVoiceOverRunning
        }
        return nil
    }

    var statusChangedNotification: Foundation.Notification.Name? {
        if self == .assistiveTouch {
            return UIAccessibility.assistiveTouchStatusDidChangeNotification
        } else if self == .boldText {
            return UIAccessibility.boldTextStatusDidChangeNotification
        } else if self == .closedCaptioning {
            return UIAccessibility.closedCaptioningStatusDidChangeNotification
        } else if self == .darkerSystemColors {
            return UIAccessibility.darkerSystemColorsStatusDidChangeNotification
        } else if self == .grayscale {
            return UIAccessibility.grayscaleStatusDidChangeNotification
        } else if self == .guidedAccess {
            return UIAccessibility.guidedAccessStatusDidChangeNotification
        } else if self == .invertColors {
            return UIAccessibility.invertColorsStatusDidChangeNotification
        } else if self == .monoAudio {
            return UIAccessibility.monoAudioStatusDidChangeNotification
        } else if self == .reduceMotion {
            return UIAccessibility.reduceMotionStatusDidChangeNotification
        } else if self == .reduceTransparency {
            return UIAccessibility.reduceTransparencyStatusDidChangeNotification
        } else if self == .shakeToUndo {
            return UIAccessibility.shakeToUndoDidChangeNotification
        } else if self == .speakScreen {
            return UIAccessibility.speakScreenStatusDidChangeNotification
        } else if self == .speakSelection {
            return UIAccessibility.speakSelectionStatusDidChangeNotification
        } else if self == .switchControl {
            return UIAccessibility.switchControlStatusDidChangeNotification
        } else if self == .voiceOver {
            return UIAccessibility.voiceOverStatusDidChangeNotification
        }
        return nil
    }

    // NOTE: - Perhaps utilize this technique instead of manual array: https://forums.developer.apple.com/thread/16252
    static var all: [AXFeatures] = [
        .assistiveTouch,
        .boldText,
        .closedCaptioning,
        .darkerSystemColors,
        .grayscale,
        .guidedAccess,
        .invertColors,
        .monoAudio,
        .reduceMotion,
        .reduceTransparency,
        .shakeToUndo,
        .speakScreen,
        .speakSelection,
        .switchControl,
        .voiceOver
    ]

    public enum EnabledCheckType {
        case any
        case all
    }
}

//    Create your own helper checks by extending AX
//
//    extension AX {
//        @objc public static var highContrastEnabled: Bool {
//            return AX.checkEnabled(features: [.darkerSystemColors, .reduceTransparency], checkType: .any)
//        }
//    }
//

