//
//  Reference.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public final class Reference<T> {
    private(set) var wrapped: Wrapped<T>
    private weak var manager: ReferenceManager<T>?
    
    init(_ object: T?, manager: ReferenceManager<T>) {
        self.wrapped = Wrapped(object)
        self.manager = manager
    }
    
    deinit {
        manager?.remove(wrapped: wrapped)
    }
}
