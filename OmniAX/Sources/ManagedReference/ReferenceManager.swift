//
//  ReferenceManager.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

class ReferenceManager {
    private(set) var outputs: Set<WrappedHashable<AnyObject>> = []

    final func remove(wrapped: WrappedHashable<AnyObject>) {
        outputs.remove(wrapped)
    }
    
    final func add(_ wrapped: WrappedHashable<AnyObject>) -> ManagedReference {
        outputs.insert(wrapped)
        
        return ManagedReference(wrapped: wrapped, manager: self)
    }
}
