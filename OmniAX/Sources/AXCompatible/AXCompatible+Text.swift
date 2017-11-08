//
//  AXCompatible+Text.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

// MARK: - VoiceOver Unabbreviation

public extension AXType where Root: UILabel {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}

public extension AXType where Root: UITextView {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}

public extension AXType where Root: UITextField {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}

// MARK: - Dictation InputAccessoryView

public extension AXType where Root: UITextView {
    /// Sets a custom inputAccessoryView for the root UITextView
    /// Important to have values for the following Cocoa Keys in your app's Info.plist
    /// NSSpeechRecognitionUsageDescription and NSMicrophoneUsageDescription
    ///
    public func dictationInputAccessoryView<T: DictationDelegate>(parent: UIViewController?, delegate: T?) -> ManagedReference? {
        guard let (view, reference) = dictationView(parent: parent, delegate: delegate) else {
            return nil
        }
        root.inputAccessoryView = view
        return reference
    }
}

public extension AXType where Root: UITextField {
    /// Sets a custom inputAccessoryView for the root UITextField
    /// Important to have values for the following Cocoa Keys in your app's Info.plist
    /// NSSpeechRecognitionUsageDescription and NSMicrophoneUsageDescription
    ///
    public func dictationInputAccessoryView<T: DictationDelegate>(parent: UIViewController?, delegate: T?) -> ManagedReference? {
        guard let (view, reference) = dictationView(parent: parent, delegate: delegate) else {
            return nil
        }
        root.inputAccessoryView = view
        return reference
    }
}

fileprivate extension AXType {
    func dictationView<T: DictationDelegate>(parent: UIViewController?, delegate: T?) -> (UIView, ManagedReference)? {
        guard #available(iOS 10.0, *) else {
            return nil
        }
        return AX.dictationInputAccessoryView(parent: parent, delegate: delegate)
    }
}
