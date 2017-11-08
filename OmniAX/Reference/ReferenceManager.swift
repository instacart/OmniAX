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
    
    final func add(_ wrapped: WrappedHashable<AnyObject>) -> Reference {
        outputs.insert(wrapped)
        
        return Reference(wrapped: wrapped, manager: self)
    }
}



final class DictationReferenceManager: ReferenceManager, Dispatchable {
    typealias DispatchType = Output<String>
    
    func dispatch(output: Output<String>) {
        for observer in outputs {
            (observer.wrapped as? DictationDelegate)?.dispatch(output: output)
        }
    }
}
