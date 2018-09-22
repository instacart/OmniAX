//
//  AX.Message.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public extension AX.Message {
    public static let inProgress = AX.Message(rawValue: NSLocalizedString("In progress", comment: ""))
    public static let loading = AX.Message(rawValue: NSLocalizedString("Loading", comment: ""))
    public static let processing = AX.Message(rawValue: NSLocalizedString("Processing", comment: ""))
}

// To create your own custom messages, simply extend AXMessage like the example below.
//
//  public extension AX.Message {
//      public static let customMessage = Message(rawValue: "Custom message here")
//  }
//

extension AX.Message: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}
