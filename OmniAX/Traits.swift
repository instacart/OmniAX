//
//  AX+Traits.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit

public struct Traits: OptionSet {
    public let rawValue: UInt64

    public static let adjustable                = Traits(rawValue: UIAccessibilityTraitAdjustable)
    public static let allowsDirectInteraction   = Traits(rawValue: UIAccessibilityTraitAllowsDirectInteraction)
    public static let button                    = Traits(rawValue: UIAccessibilityTraitButton)
    public static let causesPageTurn            = Traits(rawValue: UIAccessibilityTraitCausesPageTurn)
    public static let header                    = Traits(rawValue: UIAccessibilityTraitHeader)
    public static let image                     = Traits(rawValue: UIAccessibilityTraitImage)
    public static let keyboardKey               = Traits(rawValue: UIAccessibilityTraitKeyboardKey)
    public static let link                      = Traits(rawValue: UIAccessibilityTraitLink)
    public static let none                      = Traits(rawValue: UIAccessibilityTraitNone)
    public static let notEnabled                = Traits(rawValue: UIAccessibilityTraitNotEnabled)
    public static let playsSound                = Traits(rawValue: UIAccessibilityTraitPlaysSound)
    public static let searchField               = Traits(rawValue: UIAccessibilityTraitSearchField)
    public static let selected                  = Traits(rawValue: UIAccessibilityTraitSelected)
    public static let startsMediaSession        = Traits(rawValue: UIAccessibilityTraitStartsMediaSession)
    public static let staticText                = Traits(rawValue: UIAccessibilityTraitStaticText)
    public static let summaryElement            = Traits(rawValue: UIAccessibilityTraitSummaryElement)
    @available(iOS 10.0, *)
    public static let tabBar                    = Traits(rawValue: UIAccessibilityTraitTabBar)
    public static let updatesFrequently         = Traits(rawValue: UIAccessibilityTraitUpdatesFrequently)

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}
