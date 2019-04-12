//
//  AX+Traits.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct Traits: OptionSet {
    public let rawValue: UInt64

    public static let adjustable                = Traits(rawValue: UIAccessibilityTraits.adjustable.rawValue)
    public static let allowsDirectInteraction   = Traits(rawValue: UIAccessibilityTraits.allowsDirectInteraction.rawValue)
    public static let button                    = Traits(rawValue: UIAccessibilityTraits.button.rawValue)
    public static let causesPageTurn            = Traits(rawValue: UIAccessibilityTraits.causesPageTurn.rawValue)
    public static let header                    = Traits(rawValue: UIAccessibilityTraits.header.rawValue)
    public static let image                     = Traits(rawValue: UIAccessibilityTraits.image.rawValue)
    public static let keyboardKey               = Traits(rawValue: UIAccessibilityTraits.keyboardKey.rawValue)
    public static let link                      = Traits(rawValue: UIAccessibilityTraits.link.rawValue)
    public static let none                      = Traits(rawValue: UIAccessibilityTraits.none.rawValue)
    public static let notEnabled                = Traits(rawValue: UIAccessibilityTraits.notEnabled.rawValue)
    public static let playsSound                = Traits(rawValue: UIAccessibilityTraits.playsSound.rawValue)
    public static let searchField               = Traits(rawValue: UIAccessibilityTraits.searchField.rawValue)
    public static let selected                  = Traits(rawValue: UIAccessibilityTraits.selected.rawValue)
    public static let startsMediaSession        = Traits(rawValue: UIAccessibilityTraits.startsMediaSession.rawValue)
    public static let staticText                = Traits(rawValue: UIAccessibilityTraits.staticText.rawValue)
    public static let summaryElement            = Traits(rawValue: UIAccessibilityTraits.summaryElement.rawValue)
    @available(iOS 10.0, *)
    public static let tabBar                    = Traits(rawValue: UIAccessibilityTraits.tabBar.rawValue)
    public static let updatesFrequently         = Traits(rawValue: UIAccessibilityTraits.updatesFrequently.rawValue)

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}
