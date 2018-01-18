//
//  AXCompatible.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public protocol AXCompatible {
    associatedtype CompatibleType where CompatibleType: AXCompatible

    var ax: AXType<CompatibleType> { get }
}

extension AXCompatible {
    public var ax: AXType<Self> {
        return AXType(root: self)
    }

    public var test: AXType<Self> {
        get {
            return AXType(root: self)
        }
        set {
            test.root = newValue.root
        }
    }
}

public final class AXType<Root> {
    fileprivate(set) var root: Root
    
    init(root: Root) {
        self.root = root
    }
}
