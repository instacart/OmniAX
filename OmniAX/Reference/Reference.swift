//
//  Reference.swift
//  OmniAX
//
//  Created by Dan Loman on 11/7/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

public final class Reference {
    private let wrapped: WrappedHashable<AnyObject>
    private weak var manager: ReferenceManager?
    
    init(wrapped: WrappedHashable<AnyObject>, manager: ReferenceManager?) {
        self.wrapped = wrapped
        self.manager = manager
    }
    
    deinit {
        manager?.remove(wrapped: wrapped)
    }
}
