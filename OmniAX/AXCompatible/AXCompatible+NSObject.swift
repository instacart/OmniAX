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
    var isFocused: Bool {
        return AX.isFocused(element: root)
    }
    
    func toggle(traits: Traits, enabled: Bool = true, forceAccessible: Bool = true) {
        AX.toggle(
            traits: traits,
            enabled: enabled,
            for: root,
            forceAccessible: forceAccessible
        )
    }
    
    func summarizeInSelf(elements: [NSObject?], inheritTraits: Bool = true, excludeHidden: Bool = true, frame: CGRect? = nil) {
        AX.summarize(
            elements: elements,
            in: root,
            inheritTraits: inheritTraits,
            excludeHidden: excludeHidden,
            frame: frame
        )
    }
}
