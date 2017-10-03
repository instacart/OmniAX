//
//  AX+Traits.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct Traits: OptionSet {
    public let rawValue: UInt64

    public static let adjustable = Traits(rawValue: UIAccessibilityTraitAdjustable)
    public static let button = Traits(rawValue: UIAccessibilityTraitButton)
    public static let header = Traits(rawValue: UIAccessibilityTraitHeader)
    public static let image = Traits(rawValue: UIAccessibilityTraitImage)
    public static let link = Traits(rawValue: UIAccessibilityTraitLink)
    public static let none = Traits(rawValue: UIAccessibilityTraitNone)
    public static let notEnabled = Traits(rawValue: UIAccessibilityTraitNotEnabled)
    public static let searchField = Traits(rawValue: UIAccessibilityTraitSearchField)
    public static let selected = Traits(rawValue: UIAccessibilityTraitSelected)

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}
