//
//  AXCompatible+NSObject.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension NSObject: AXCompatible {}

extension AXType where Root: NSObject {
    public var isFocused: Bool {
        return AX.isFocused(element: root)
    }

    public var customActions: [UIAccessibilityCustomAction]? {
        get {
            return root.accessibilityCustomActions
        }
        set {
            root.accessibilityCustomActions = newValue
        }
    }

    /// Summarize the accessibilityLabels from sub-elements into self as parent element
    /// Useful for combining subviews into a more digestible accessibilty element
    /// If summary accessibility text is not blank, sets elements isAccessibilityElement = true
    ///
    /// - Parameters:
    ///   - children: Elements to summarize
    ///   - inheritTraits: Inherits the subElements' traits by default
    ///   - excludeHidden: Hidden UIView elements are excluded from summary by default
    ///   - frame: If non-nil, the accessibilyFrame of the parent element is set to this value. Will need to handle scrolling manually
    public func summarize(children: [NSObject?], inheritTraits: Bool = true, excludeHidden: Bool = true, frame: CGRect? = nil) {
        AX.summarize(
            elements: children,
            in: root,
            inheritTraits: inheritTraits,
            excludeHidden: excludeHidden,
            frame: frame
        )
    }

    public func toggle(traits: UIAccessibilityTraits, enabled: Bool = true, forceAccessible: Bool = true) {
        AX.toggle(
            traits: traits,
            enabled: enabled,
            for: root,
            forceAccessible: forceAccessible
        )
    }

    // MARK: - Notifications/Announcements

    /// Post an accessibility notification, focusing on (or announcing) self (root)
    public func post(notification: UIAccessibility.Notification) {
        guard !notification.isVoiceOverSpecific || AX.voiceOverEnabled else {
            return
        }

        UIAccessibility.post(notification: notification, argument: root)
    }
}
