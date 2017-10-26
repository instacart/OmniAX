//
//  String+AX.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension String {
    var completeRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }

    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}

