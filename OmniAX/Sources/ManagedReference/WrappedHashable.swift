//
//  Wrapped.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

final class WrappedHashable<T: AnyObject> {
    let id = UUID()
    private(set) weak var wrapped: T?
    
    init(_ wrapped: T?) {
        self.wrapped = wrapped
    }
}

extension WrappedHashable: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: WrappedHashable, rhs: WrappedHashable) -> Bool {
        return lhs.id == rhs.id
    }
}
