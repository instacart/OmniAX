//
//  AXMessage.swift
//  OmniAX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

public struct AXMessage {
    let rawValue: String

    public static let inProgress = AXMessage(rawValue: NSLocalizedString("In progress", comment: ""))
    public static let loading = AXMessage(rawValue: NSLocalizedString("Loading", comment: ""))
    public static let processing = AXMessage(rawValue: NSLocalizedString("Processing", comment: ""))

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// To create your own custom messages, simply extend AXMessage like the example below.
//
//  public extension Message {
//      public static let customMessage = Message(rawValue: "Custom message here")
//  }
//
