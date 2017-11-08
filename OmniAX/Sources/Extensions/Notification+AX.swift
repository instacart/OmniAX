//
//  Notification+AX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

extension Foundation.Notification.Name {
    func observe(onNext: @escaping (Foundation.Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: self, object: nil, queue: nil, using: onNext)
    }
}
