//
//  DictationReferenceManager.swift
//  OmniAX
//
//  Created by Dan Loman on 11/8/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

final class DictationReferenceManager: ReferenceManager, Dispatchable {
    typealias DispatchType = Output<String>
    
    func dispatch(output: Output<String>) {
        for observer in outputs {
            (observer.wrapped as? DictationDelegate)?.dispatch(output: output)
        }
    }
}
