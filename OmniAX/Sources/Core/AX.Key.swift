//
//  AX.Key.swift
//  OmniAX
//
//  Created by Dan Loman on 9/22/18.
//  Copyright © 2018 Dan Loman. All rights reserved.
//

import Foundation

extension AX.Key {
    static let defaultsForcedFeatures: AX.Key = "com.OmniAX.userForceEnabledFeatures"
}

extension AX.Key: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
