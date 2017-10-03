//
//  Sequence+AX.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension Sequence {
    public func array() -> [Element] {
        return Array(self)
    }
}

extension Sequence where Element: Hashable {
    public func set() -> Set<Element> {
        return Set(self)
    }
}
