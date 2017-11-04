//
//  AXCompatible.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public protocol AXCompatible {
    associatedtype AXCompatibleType where AXCompatibleType: AXCompatible

    var ax: AXType<AXCompatibleType> { get }
}

extension AXCompatible {
    public var ax: AXType<Self> {
        return AXType(root: self)
    }
}

public struct AXType<Root> {
    let root: Root
    
    init(root: Root) {
        self.root = root
    }
}
