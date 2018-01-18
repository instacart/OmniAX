//
//  AXTraits.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct AXTraits: OptionSet {
    public let rawValue: UInt64

    public static let adjustable                = AXTraits(rawValue: UIAccessibilityTraitAdjustable)
    public static let allowsDirectInteraction   = AXTraits(rawValue: UIAccessibilityTraitAllowsDirectInteraction)
    public static let button                    = AXTraits(rawValue: UIAccessibilityTraitButton)
    public static let causesPageTurn            = AXTraits(rawValue: UIAccessibilityTraitCausesPageTurn)
    public static let header                    = AXTraits(rawValue: UIAccessibilityTraitHeader)
    public static let image                     = AXTraits(rawValue: UIAccessibilityTraitImage)
    public static let keyboardKey               = AXTraits(rawValue: UIAccessibilityTraitKeyboardKey)
    public static let link                      = AXTraits(rawValue: UIAccessibilityTraitLink)
    public static let none                      = AXTraits(rawValue: UIAccessibilityTraitNone)
    public static let notEnabled                = AXTraits(rawValue: UIAccessibilityTraitNotEnabled)
    public static let playsSound                = AXTraits(rawValue: UIAccessibilityTraitPlaysSound)
    public static let searchField               = AXTraits(rawValue: UIAccessibilityTraitSearchField)
    public static let selected                  = AXTraits(rawValue: UIAccessibilityTraitSelected)
    public static let startsMediaSession        = AXTraits(rawValue: UIAccessibilityTraitStartsMediaSession)
    public static let staticText                = AXTraits(rawValue: UIAccessibilityTraitStaticText)
    public static let summaryElement            = AXTraits(rawValue: UIAccessibilityTraitSummaryElement)
    @available(iOS 10.0, *)
    public static let tabBar                    = AXTraits(rawValue: UIAccessibilityTraitTabBar)
    public static let updatesFrequently         = AXTraits(rawValue: UIAccessibilityTraitUpdatesFrequently)

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}
