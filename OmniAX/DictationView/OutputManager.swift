//
//  OutputManager.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

final class ReferenceManager<T> {
    fileprivate var outputs: Set<Wrapped<T>> = []
    
    func remove(wrapped: Wrapped<T>) {
        outputs.remove(wrapped)
    }
    
    func add(_ object: T?) -> Reference<T> {
        let reference = Reference(object, manager: self)
        outputs.insert(reference.wrapped)
        
        return reference
    }
}

extension ReferenceManager where T == DictationDelegate {
    func dispatch(output: Output<String>) {
        outputs.forEach({ $0.wrapped?.dispatch(output: output) })
    }
}
