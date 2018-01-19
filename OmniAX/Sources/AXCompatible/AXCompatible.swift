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
}

public final class AXType<Root> {
    let root: Root
    
    init(root: Root) {
        self.root = root
    }
}
