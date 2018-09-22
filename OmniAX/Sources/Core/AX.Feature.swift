//
//  AX.Feature.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

extension AX.Feature {
    var systemCheckEnabled: Bool {
        switch self {
        case .assistiveTouch:
            return UIAccessibility.isAssistiveTouchRunning
        case.boldText:
            return UIAccessibility.isBoldTextEnabled
        case.closedCaptioning:
            return UIAccessibility.isClosedCaptioningEnabled
        case.darkerSystemColors:
            return UIAccessibility.isDarkerSystemColorsEnabled
        case.grayscale:
            return UIAccessibility.isGrayscaleEnabled
        case.guidedAccess:
            return UIAccessibility.isGuidedAccessEnabled
        case.invertColors:
            return UIAccessibility.isInvertColorsEnabled
        case.monoAudio:
            return UIAccessibility.isMonoAudioEnabled
        case.reduceMotion:
            return UIAccessibility.isReduceMotionEnabled
        case.reduceTransparency:
            return UIAccessibility.isReduceTransparencyEnabled
        case.shakeToUndo:
            return UIAccessibility.isShakeToUndoEnabled
        case.speakScreen:
            return UIAccessibility.isSpeakScreenEnabled
        case.speakSelection:
            return UIAccessibility.isSpeakSelectionEnabled
        case.switchControl:
            return UIAccessibility.isSwitchControlRunning
        case.voiceOver:
            return UIAccessibility.isVoiceOverRunning
        }
    }

    var statusChangedNotification: Foundation.Notification.Name {
        switch self {
        case .assistiveTouch:
            return UIAccessibility.assistiveTouchStatusDidChangeNotification
        case.boldText:
            return UIAccessibility.boldTextStatusDidChangeNotification
        case.closedCaptioning:
            return UIAccessibility.closedCaptioningStatusDidChangeNotification
        case.darkerSystemColors:
            return UIAccessibility.darkerSystemColorsStatusDidChangeNotification
        case.grayscale:
            return UIAccessibility.grayscaleStatusDidChangeNotification
        case.guidedAccess:
            return UIAccessibility.guidedAccessStatusDidChangeNotification
        case.invertColors:
            return UIAccessibility.invertColorsStatusDidChangeNotification
        case.monoAudio:
            return UIAccessibility.monoAudioStatusDidChangeNotification
        case.reduceMotion:
            return UIAccessibility.reduceMotionStatusDidChangeNotification
        case.reduceTransparency:
            return UIAccessibility.reduceTransparencyStatusDidChangeNotification
        case.shakeToUndo:
            return UIAccessibility.shakeToUndoDidChangeNotification
        case.speakScreen:
            return UIAccessibility.speakScreenStatusDidChangeNotification
        case.speakSelection:
            return UIAccessibility.speakSelectionStatusDidChangeNotification
        case.switchControl:
            return UIAccessibility.switchControlStatusDidChangeNotification
        case.voiceOver:
            return UIAccessibility.voiceOverStatusDidChangeNotification
        }
    }

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
