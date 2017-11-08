//
//  Dispatchable.swift
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
