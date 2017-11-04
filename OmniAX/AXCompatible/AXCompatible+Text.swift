//
//  AXCompatible+Text.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

// MARK: - Definitions

protocol OptionalTextable {
    var text: String? { get set }
}

protocol ImplicitlyUnwrappedTextable {
    var text: String! { get set }
}

typealias ImplicitlyUnwrappedTextContainer = ImplicitlyUnwrappedTextable & NSObject

typealias OptionalTextContainer = OptionalTextable & NSObject

// MARK: - Compliance

//extension UILabel: OptionalTextable, AXCompatible {
//    typealias AXCompatibleType = UILabel
//}
//
//extension UITextField: OptionalTextable, AXCompatible {
//    typealias AXCompatibleType = UITextField
//}
//
//extension UITextView: ImplicitlyUnwrappedTextable, AXCompatible {
//    typealias AXCompatibleType = UITextView
//}

// MARK: - AX Methods

extension AXType where Root: ImplicitlyUnwrappedTextContainer {
    func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}

extension AXType where Root: OptionalTextContainer {
    func unabbreviateVoiceOverText() {
        root.accessibilityLabel = AX.unabbreviate(string: root.text)
    }
}
