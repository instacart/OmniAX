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
}

public extension AXType where Root: UITextField {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}

public extension AXType where Root: UILabel {
    public func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}
