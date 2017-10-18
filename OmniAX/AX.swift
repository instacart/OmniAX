//
//  AX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

/// AX is a wrapper around UIAccessibility designed to ease the process of making in-app elements accessible to all users
public final class AX: NSObject {
    static let instance = AX()

    private static let defaultsForcedFeaturesKey = "com.OmniAX.userForceEnabledFeatures"

    private var systemEnabledFeatures: Features = []

    private var userForceEnabledFeatures: Features = []

    private var enabledFeatures: Features {
        return systemEnabledFeatures.union(userForceEnabledFeatures)
    }

    @objc public static var voiceOverEnabled: Bool {
        return AX.checkEnabled(features: .voiceOver)
    }

    private var transformer: AbbrevationTransformer {
        return customTransformer ?? _transformer
    }

    private lazy var _transformer: AbbrevationTransformer = {
        return Transformer()
    }()

    private var customTransformer: AbbrevationTransformer?

    /// Don't allow outside initialization of this class. Should be used through through it's static methods only
    private override init() {
        super.init()

        // Check system enabled features
        Features.all.forEach({ observe(feature: $0) })

        // Check for user forced defaults
        let forcedRawValue = UserDefaults.standard.integer(forKey: AX.defaultsForcedFeaturesKey)
        if forcedRawValue > 0 {
            userForceEnabledFeatures = Features(rawValue: UInt64(forcedRawValue))
        }
    }

    // MARK: - Configuration

    /// Configures AX with a custom abbreviation transformer
    public static func configure(customTransformer: AbbrevationTransformer) {
        AX.instance.customTransformer = customTransformer
    }

    /// Configures default AbbreviationTransformer
    ///
    /// - Parameters:
    ///   - knownAbbreviations: Optional dictionary of knownAbbreviations. Modified if non-nil
    ///   - transforms: Optional array of general transforms to be performed on AX.unabbreviate(string:). Modified if non-nil
    /// - Returns: true if transformer is not custom and was configured
    @discardableResult public static func configure(knownAbbreviations: [String: String]?, transforms: [Transform]?) -> Bool {
        if var transformer = AX.instance.transformer as? Transformer {
            if let knownAbbreviations = knownAbbreviations {
                transformer.knownAbbreviations = knownAbbreviations
            }
            if let transforms = transforms {
                transformer.generalTransforms = transforms
            }
            AX.instance._transformer = transformer
            return true
        }
        return false
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
        guard let enabled = feature.systemCheckEnabled else {
            return assertionFailure("Unknown/Unmapped feature")
        }
        if enabled {
            systemEnabledFeatures.insert(feature)
        } else {
            systemEnabledFeatures.remove(feature)
        }
    }

    private func updateUserDefaults() {
        UserDefaults.standard.set(userForceEnabledFeatures.rawValue, forKey: AX.defaultsForcedFeaturesKey)
        UserDefaults.standard.synchronize()
    }

    private func observe(feature: Features) {
        // Intial check for enabled
        checkSystemStatus(feature: feature)

        // Observe
        if let notification = feature.statusChangedNotification {
            notification.observe(onNext: { [weak self] _ in self?.checkSystemStatus(feature: feature) })
        } else {
            assertionFailure("Unmapped/Unknown feature")
        }
    }

    // MARK: - Public

    /// Add custom actions to an element to allow for custom gestures and interaction with an element
    ///
    /// - Parameters:
    ///   - replace: Controls whether included actions will replace or append the included actions
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
    public static func toggle(traits: Traits, enabled: Bool = true, for elements: [NSObject?], forceAccessible flag: Bool? = nil) {
        elements.forEach({ toggle(traits: traits, enabled: enabled, for: $0, forceAccessible: flag) })
    }

    /// Adds or removes the included traits to/from the element
    /// Modify isAccessibilityElement value if force flag is non-nil
    public static func toggle(traits: Traits, enabled: Bool = true, for element: NSObject?, forceAccessible flag: Bool? = nil) {
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

    /// Adds included AX features as forced options. (Example: in-app settings)
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
    /// Defaults to check if ALL features enabled
    public static func checkForceEnabled(features: Features, checkType: Features.EnabledCheckType = .all) -> Bool {
        return checkEnabled(features: features, checkType: checkType, within: AX.instance.userForceEnabledFeatures)
    }

    /// Returns Bool value indication if the included features are enabled
    /// Defaults to check if *ALL* features are enabled
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

    /// Convenience: Post an accessibility announcement notification, reading the included message
    public static func announce(message: String?) {
        guard let message = message else {
            return
        }

        post(notification: .announcement, focus: message)
    }

    /// Convenience: Post an accessibility announcement notification, reading the included preset message
    public static func announce(message: Message) {
        announce(message: message)
    }

    // MARK: - Summaries

    /// Summarize the accessibilityLabels from sub-elements into a parent element
    /// Useful for combining subviews into a more digestible accessibilty element
    ///
    /// - Parameters:
    ///   - elements: Elements to summarize
    ///   - element: Element to act as parent. If UIView and no custom frame passed, accessibilityFrame will be view's frame
    ///   - inheritTraits: Inherits the subElements' traits by default
    ///   - excludeHidden: Hidden UIView elements are excluded from summary by default
    ///   - frame: If non-nil, the accessibilyFrame of the parent element is set to this value. Will need to handle scrolling manually
    public static func summarize(elements: [NSObject?], in element: NSObject?, inheritTraits: Bool = true, excludeHidden: Bool = true, frame: CGRect? = nil) {
        guard voiceOverEnabled else {
            return
        }
        guard let element = element else {
            return
        }

        let accessibilityText = elements
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

        if let frame = frame {
            element.accessibilityFrame = frame
        }

        element.isAccessibilityElement = !accessibilityText.isBlank

        if inheritTraits {
            elements
                .flatMap({
                    guard excludeHidden, let view = $0 as? UIView else {
                        return $0?.accessibilityTraits
                    }
                    return view.isHidden ? nil : view.accessibilityTraits
                })
                .forEach({ element.accessibilityTraits |= $0 })
        }
    }

    /// Objective-C available overload of method by the same name
    @objc public static func summarize(elements: [NSObject], in element: NSObject?, inheritTraits: Bool = true, excludeHidden: Bool = true) {
        summarize(elements: elements as [NSObject?], in: element, inheritTraits: inheritTraits, excludeHidden: excludeHidden)
    }

    /// Replace occurrences of known abbrevations into their corresponding full words
    /// Uses built in Transformer by default. Configurable.
    @objc public static func unabbreviate(string: String?) -> String? {
        return AX.instance.transformer.unabbreviate(string: string)
    }

    /// Bool inidicating if the element the focused accessibilityElement
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
