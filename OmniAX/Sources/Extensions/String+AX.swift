//
//  String+AX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

extension String {
    var completeRange: NSRange {
        return NSRange(location: 0, length: count)
    }

    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        if let string = self {
            return string.isBlank
        }
        return true
    }
}

