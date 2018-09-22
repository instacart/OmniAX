//
//  Storage.swift
//  OmniAX
//
//  Created by Dan Loman on 9/22/18.
//  Copyright © 2018 Dan Loman. All rights reserved.
//

import Foundation

struct SimpleStorage {
    let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func set<T>(value: T, for key: AX.Key) {
        defaults.set(value, forKey: key.rawValue)
        sync()
    }

    func value<T>(for key: AX.Key) -> T? {
        return defaults.value(forKey: key.rawValue) as? T
    }

    private func sync() {
        defaults.synchronize()
    }
}
