//
//  AXCompatible+Message.swift
//  OmniAX
//
//  Created by Dan Loman on 9/22/18.
//  Copyright © 2018 Dan Loman. All rights reserved.
//

import Foundation

extension AX.Message: AXCompatible {}

extension AXType where Root == AX.Message {
    public func announce() {
        guard !root.rawValue.isEmpty else {
            return
        }

        AX.post(notification: .announcement, focus: root.rawValue)
    }
}
