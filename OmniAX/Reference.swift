//
//  Reference.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public final class Reference<T: Dispatchable> {
    private(set) var wrapped: Wrapped<T>
    private weak var manager: GenericReferenceManager<T>?
    
    init(object: T?, manager: GenericReferenceManager<T>) {
        let wrapped: Wrapped<T> = Wrapped(wrapped: object)
        self.wrapped = wrapped
        self.manager = manager
    }
    
    deinit {
        manager?.remove(wrapped: wrapped)
    }
}
