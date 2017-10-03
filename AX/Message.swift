//
//  AX+Message.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct Message {
    let rawValue: String

    public static let inProgress = Message(rawValue: NSLocalizedString("In progress", comment: ""))
    public static let loading = Message(rawValue: NSLocalizedString("Loading", comment: ""))
    public static let processing = Message(rawValue: NSLocalizedString("Processing", comment: ""))

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// To create your own custom messages, simply extend Message like the example below. Unlike above, in extensions, these must be declared: `public static var`
//
//  public extension Message {
//      public static var customMessage = Message(rawValue: "Custom message here")
//  }
//
