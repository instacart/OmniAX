//
//  AXCompatible+String.swift
//  OmniAX
//
//  Created by Dan Loman on 9/22/18.
//  Copyright © 2018 Dan Loman. All rights reserved.
//

import Foundation

extension String: AXCompatible {}

extension AXType where Root == String {
    /// An unabbreviated version of self, transformed by configured/default transformers
    public var unabbreviated: String {
        return AX.unabbreviate(string: root) ?? root
    }

    /// Post an accessibility announcement notification, reading self
    public func announce() {
        guard !root.isEmpty else {
            return
        }

        AX.post(notification: .announcement, focus: root)
    }
}
