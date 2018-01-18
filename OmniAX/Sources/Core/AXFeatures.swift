//
//  AXFeatures.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct AXFeatures: OptionSet {
    public let rawValue: UInt64

    @available(iOS 10.0, *)
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
        if #available(iOS 10.0, *), self == .assistiveTouch {
            return UIAccessibilityIsAssistiveTouchRunning()
        } else if self == .boldText {
            return UIAccessibilityIsBoldTextEnabled()
        } else if self == .closedCaptioning {
            return UIAccessibilityIsClosedCaptioningEnabled()
        } else if self == .darkerSystemColors {
            return UIAccessibilityDarkerSystemColorsEnabled()
        } else if self == .grayscale {
            return UIAccessibilityIsGrayscaleEnabled()
        } else if self == .guidedAccess {
            return UIAccessibilityIsGuidedAccessEnabled()
        } else if self == .invertColors {
            return UIAccessibilityIsInvertColorsEnabled()
        } else if self == .monoAudio {
            return UIAccessibilityIsMonoAudioEnabled()
        } else if self == .reduceMotion {
            return UIAccessibilityIsReduceMotionEnabled()
        } else if self == .reduceTransparency {
            return UIAccessibilityIsReduceTransparencyEnabled()
        } else if self == .shakeToUndo {
            return UIAccessibilityIsShakeToUndoEnabled()
        } else if self == .speakScreen {
            return UIAccessibilityIsSpeakScreenEnabled()
        } else if self == .speakSelection {
            return UIAccessibilityIsSpeakSelectionEnabled()
        } else if self == .switchControl {
            return UIAccessibilityIsSwitchControlRunning()
        } else if self == .voiceOver {
            return UIAccessibilityIsVoiceOverRunning()
        }
        return nil
    }

    var statusChangedNotification: Foundation.Notification.Name? {
        if #available(iOS 10.0, *), self == .assistiveTouch {
            return .UIAccessibilityAssistiveTouchStatusDidChange
        } else if self == .boldText {
            return .UIAccessibilityBoldTextStatusDidChange
        } else if self == .closedCaptioning {
            return .UIAccessibilityClosedCaptioningStatusDidChange
        } else if self == .darkerSystemColors {
            return .UIAccessibilityDarkerSystemColorsStatusDidChange
        } else if self == .grayscale {
            return .UIAccessibilityGrayscaleStatusDidChange
        } else if self == .guidedAccess {
            return .UIAccessibilityGuidedAccessStatusDidChange
        } else if self == .invertColors {
            return .UIAccessibilityInvertColorsStatusDidChange
        } else if self == .monoAudio {
            return .UIAccessibilityMonoAudioStatusDidChange
        } else if self == .reduceMotion {
            return .UIAccessibilityReduceMotionStatusDidChange
        } else if self == .reduceTransparency {
            return .UIAccessibilityReduceTransparencyStatusDidChange
        } else if self == .shakeToUndo {
            return .UIAccessibilityShakeToUndoDidChange
        } else if self == .speakScreen {
            return .UIAccessibilitySpeakScreenStatusDidChange
        } else if self == .speakSelection {
            return .UIAccessibilitySpeakSelectionStatusDidChange
        } else if self == .switchControl {
            return .UIAccessibilitySwitchControlStatusDidChange
        } else if self == .voiceOver {
// NOTE: - Compilation issue even with #available() check. Commenting until bump up of deployment target
//            if #available(iOS 11.0, *) {
//                return .UIAccessibilityVoiceOverStatusDidChange
//            } else {
                return .init(rawValue: UIAccessibilityVoiceOverStatusChanged)
//            }
        }
        return nil
    }

    // NOTE: - Perhaps utilize this technique instead of manual array: https://forums.developer.apple.com/thread/16252
    static var all: [AXFeatures] = {
        var features: [AXFeatures] = [
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
        if #available(iOS 10.0, *) {
            features.append(.assistiveTouch)
        }
        return features
    }()

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

