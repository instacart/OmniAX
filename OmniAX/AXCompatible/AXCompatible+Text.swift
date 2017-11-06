//
//  AXCompatible+Text.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public extension AXType where Root: UITextView {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }

    /// Sets a custom inputAccessoryView for the root UITextView
    /// Important to have values for the following Cocoa Keys in your app's Info.plist
    /// NSSpeechRecognitionUsageDescription and NSMicrophoneUsageDescription
    ///
    public func dictationInputAccessoryView(parent: UIViewController?, delegate: AXDictationDelegate?) {
        if #available(iOS 10.0, *) {
            root.inputAccessoryView = AX.dictationInputAccessoryView(parent: controller, delegate: delegate)
        }
    }
}

public extension AXType where Root: UITextField {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }

    /// Sets a custom inputAccessoryView for the root UITextField
    /// Important to have values for the following Cocoa Keys in your app's Info.plist
    /// NSSpeechRecognitionUsageDescription and NSMicrophoneUsageDescription
    ///
    public func dictationInputAccessoryView(parent: UIViewController?, delegate: AXDictationDelegate?) {
        if #available(iOS 10.0, *) {
            root.inputAccessoryView = AX.dictationInputAccessoryView(parent: parent, delegate: delegate)
        }
    }
}

public extension AXType where Root: UILabel {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}

extension AX {
    @available(iOS 10.0, *)
    private static let dictationViewController = DictationViewController()

    static func dictationInputAccessoryView(parent: UIViewController?, delegate: AXDictationDelegate?) -> UIView? {
        var width: CGFloat = UIScreen.main.bounds.width

        var controller: UIViewController? = nil
        if #available(iOS 10.0, *) {
            controller = AX.dictationViewController
            (controller as? DictationViewController)?.dictationView.delegate = delegate
        }

        controller?.view.removeFromSuperview()

        if let parent = parent, let child = controller {
            parent.addChildViewController(child)
            child.didMove(toParentViewController: parent)

            width = parent.view.bounds.width
        }

        controller?.view.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: width,
                height: 60
            )
        )

        return controller?.view
    }
}
