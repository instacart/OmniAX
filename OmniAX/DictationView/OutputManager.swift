//
//  OutputManager.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public protocol Dispatchable: class {
    associatedtype DispatchType
    
    func dispatch(output: DispatchType)
}

class GenericReferenceManager<Handler: Dispatchable> {
    private(set) var outputs: Set<Wrapped<Handler>> = []

    final func remove(wrapped: Wrapped<Handler>) {
        outputs.remove(wrapped)
    }
    
    final func add(_ object: Handler?) -> Reference<Handler> {
        let reference: Reference<Handler> = Reference(object: object, manager: self)
        outputs.insert(reference.wrapped)
        
        return reference
    }
    
    func dispatch(output: Handler.DispatchType) {
        for observer in outputs {
            observer.wrapped?.dispatch(output: output)
        }
    }
}

protocol AXDictationDelegate: class {
    func dispatch(output: Output<String>)
}

final class WrappedDelegate {
    private weak var delegate: AXDictationDelegate?
}

typealias WrappedOutput = Wrapped<DictationDelegate>

final class DictationReferenceManager: GenericReferenceManager<WrappedDelegate> {}
