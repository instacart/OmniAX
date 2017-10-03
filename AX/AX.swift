//
//  AX.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit

/// AX is a wrapper around UIAccessibility designed to
/// ease the process of making in-app elements accessible to all users
public final class AX: NSObject {
    static let instance = AX()

    private static let defaultsForcedFeaturesKey = "AX.userForceEnabledFeatures"

    private var systemEnabledFeatures: Features = []

    private var userForceEnabledFeatures: Features = []

    private var enabledFeatures: Features {
        return systemEnabledFeatures.union(userForceEnabledFeatures)
    }

    @objc public static var voiceOverEnabled: Bool {
        return AX.checkEnabled(features: .voiceOver)
    }

    @objc public static var highContrastEnabled: Bool {
        return AX.checkEnabled(features: .highContrast)
    }

    private var transformer: AbbrevationTransformer {
        return customTransformer ?? _transformer
    }

    private lazy var _transformer: AbbrevationTransformer = {
        return Transformer()
    }()

    private var customTransformer: AbbrevationTransformer?

    /// Don't allow outside initialization of this class.
    /// Should be used through through it's static methods only
    private override init() {
        super.init()
        // Check system enabled features
        [.voiceOver, .reduceMotion, .highContrast].forEach({ checkSystemStatus(feature: $0) })

        // Check for user forced defaults
        let forcedRawValue = UserDefaults.standard.integer(forKey: AX.defaultsForcedFeaturesKey)
        if forcedRawValue > 0 {
            userForceEnabledFeatures = Features(rawValue: UInt64(forcedRawValue))
        }

        if #available(iOS 11.0, *) {
            observe(notification: .UIAccessibilityVoiceOverStatusDidChange, onNext: { [weak self] _ in
                self?.checkSystemStatus(feature: .voiceOver)
            })
        } else {
            observe(notification: Foundation.Notification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), onNext: { [weak self] _ in
                self?.checkSystemStatus(feature: .voiceOver)
            })
        }

        observe(notification: .UIAccessibilityReduceMotionStatusDidChange, onNext: { [weak self] _ in
            self?.checkSystemStatus(feature: .reduceMotion)
        })

        observe(notification: .UIAccessibilityDarkerSystemColorsStatusDidChange, onNext: { [weak self] _ in
            self?.checkSystemStatus(feature: .highContrast)
        })
    }

    // MARK: - Configuration

    public static func configure(customTransformer: AbbrevationTransformer) {
        AX.instance.customTransformer = customTransformer
    }

    public static func configure(transforms: [Transform]) {
        if var transformer = AX.instance.transformer as? Transformer {
            transformer.generalTransforms = transforms
        }
    }

    public static func configure(knownAbbreviations: [String: String]) {
        if var transformer = AX.instance.transformer as? Transformer {
            transformer.knownAbbreviations = knownAbbreviations
        }
    }

    // MARK: - Private

    private static func checkEnabled(features: Features, checkType: Features.EnabledCheckType, within: Features) -> Bool {
        switch checkType {
        case .all:
            return within.contains(features)
        case .any:
            return !within.isDisjoint(with: features)
        }
    }

    /// Performs a system check for enabled/disabled status of the included feature
    private func checkSystemStatus(feature: Features) {
        if feature.systemCheckEnabled == true {
            systemEnabledFeatures.insert(feature)
        } else {
            systemEnabledFeatures.remove(feature)
        }
    }

    private func updateUserDefaults() {
        UserDefaults.standard.set(userForceEnabledFeatures.rawValue, forKey: AX.defaultsForcedFeaturesKey)
        UserDefaults.standard.synchronize()
    }

    private func observe(notification name: Foundation.Notification.Name, onNext: @escaping (Foundation.Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: onNext)
    }

    // MARK: - Public

    /// Adds custom actions to an element to allow for custom gestures and interaction with an element
    ///
    /// - Parameters:
    ///   - append: Controls whether included actions will update by appending
    ///     (or updating a matching existing action) or if array will supplant current actions altogether
    @objc public static func add(customActions: [UIAccessibilityCustomAction], to element: NSObject?, replace: Bool = false) {
        guard let element = element else {
            return
        }
        if replace {
            element.accessibilityCustomActions = customActions
        } else {
            var actionSet = (element.accessibilityCustomActions ?? []).set()
            customActions.forEach({ actionSet.update(with: $0) })
            element.accessibilityCustomActions = actionSet.array()
        }
    }

    /// Adds/removes the same set of traits to all included elements
    public static func set(traits: Traits, enabled: Bool = true, for elements: [NSObject?], forceAccessible flag: Bool? = nil) {
        elements.forEach({ set(traits: traits, enabled: enabled, for: $0, forceAccessible: flag) })
    }

    /// Adds or removes the included traits to/from the element
    /// Forces isAccessibilityElement value if flag included (otherwise untouched)
    public static func set(traits: Traits, enabled: Bool = true, for element: NSObject?, forceAccessible flag: Bool? = nil) {
        guard let element = element else {
            return
        }

        if traits == .none {
            element.accessibilityTraits = traits.rawValue
        } else {
            if enabled {
                element.accessibilityTraits |= traits.rawValue
            } else {
                element.accessibilityTraits &= ~traits.rawValue
            }
        }

        if let flag = flag {
            element.isAccessibilityElement = flag
        }
    }

    // MARK: - Features

    /// Adds included AX features as forced options.
    /// checkEnabled(features:) will now return true for included features
    /// Note: - Will NOT enable UIAccessibility features. This is for your custom handling only
    public static func addForced(features: Features) {
        AX.instance.userForceEnabledFeatures.insert(features)
        AX.instance.updateUserDefaults()
    }

    /// Removes included AX features from forced options. Defaults to system value
    public static func removeForced(features: Features) {
        AX.instance.userForceEnabledFeatures.remove(features)
        AX.instance.updateUserDefaults()
    }

    /// Check to see if user's in-app settings have force enabled the included AX Features
    public static func checkForceEnabled(features: Features, checkType: Features.EnabledCheckType = .all) -> Bool {
        return checkEnabled(features: features, checkType: checkType, within: AX.instance.userForceEnabledFeatures)
    }

    /// Returns Bool value indication if the included features are enabled
    /// Check performed based on the comparison type provided
    public static func checkEnabled(features: Features, checkType: Features.EnabledCheckType = .all) -> Bool {
        return checkEnabled(features: features, checkType: checkType, within: AX.instance.enabledFeatures)
    }

    // MARK: - Notifications/Announcements

    /// Post an accessibility notification, focusing on/announcing the included focus item
    public static func post(notification: Notification, focus: Any?) {
        guard !notification.isVoiceOverSpecific || voiceOverEnabled else {
            return
        }

        UIAccessibilityPostNotification(notification.mappedValue, focus)
    }

    /// Post an accessibility announcement notification, reading the included message
    public static func announce(message: String?) {
        guard let message = message else {
            return
        }

        post(notification: .announcement, focus: message)
    }

    /// Post an accessibility announcement notification, reading the included preset message
    public static func announce(message: Message) {
        announce(message: message)
    }

    // MARK: - Summaries

    /// Summarize the accessibilityLabels from subElements into a parent element.
    /// Useful for combining subviews into a more digestible accessibilty element
    /// Inherits the subElements' traits by default
    public static func summarize(subElements: [NSObject?], in element: NSObject?, inheritTraits: Bool = true, excludeHidden: Bool = true) {
        guard voiceOverEnabled else {
            return
        }
        guard let element = element else {
            return
        }
        let accessibilityText = subElements
            .flatMap({
                $0?.isAccessibilityElement = ($0 === element)
                if excludeHidden, let view = $0 as? UIView {
                    return view.isHidden ? nil : view.accessibilityLabel
                } else if $0 is NSString {
                    return $0 as? String
                }
                return $0?.accessibilityLabel
            })
            .joined(separator: ", ")

        element.accessibilityLabel = accessibilityText
        element.isAccessibilityElement = !accessibilityText.isBlank

        if inheritTraits {
            subElements
                .flatMap({
                    guard excludeHidden, let view = $0 as? UIView else {
                        return $0?.accessibilityTraits
                    }
                    return view.isHidden ? nil : view.accessibilityTraits
                })
                .forEach({ element.accessibilityTraits |= $0 })
        }
    }

    /// Summarize the accessibilityLabels from subElements into a parent element.
    /// Useful for combining subviews into a more digestible accessibilty element
    /// Inherits the subElements' traits by default
    /// Objective-C available overload of method by the same name
    @objc public static func summarize(subElements: [NSObject], in element: NSObject?, inheritTraits: Bool = true, excludeHidden: Bool = true) {
        summarize(subElements: subElements as [NSObject?], in: element, inheritTraits: inheritTraits, excludeHidden: excludeHidden)
    }

    /// Uses regular expression to replace occurrences of known unit
    /// abbrevations into their corresponding full words
    @objc public static func unabbreviate(string: String?) -> String? {
        return AX.instance.transformer.unabbreviate(string: string)
    }

    public static func isFocused(element: NSObject?) -> Bool {
        guard voiceOverEnabled else {
            return false
        }
        guard let element = element else {
            return false
        }
        return element.accessibilityElementIsFocused()
    }
}
