//
//  Output.swift
//  OmniAX
//
//  Created by Dan Loman on 10/26/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

typealias OutputHandler<A> = (Output<A>) -> Void

public enum Output<A> {
    case loading(Bool)
    case success(A)
    case failure(Error)
}
