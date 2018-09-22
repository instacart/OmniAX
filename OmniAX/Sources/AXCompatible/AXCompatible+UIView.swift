//
//  AXCompatible+UIView.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension AXType where Root: UIView {
    public var colorInversionIgnored: Bool {
        get {
            return root.accessibilityIgnoresInvertColors
        }
        set {
            root.accessibilityIgnoresInvertColors = newValue
        }
    }
}
