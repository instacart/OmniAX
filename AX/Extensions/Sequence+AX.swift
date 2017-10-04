//
//  Sequence+AX.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension Sequence {
    func array() -> [Iterator.Element] {
        return Array(self)
    }
}

extension Sequence where Iterator.Element: Hashable {
    func set() -> Set<Iterator.Element> {
        return Set(self)
    }
}
