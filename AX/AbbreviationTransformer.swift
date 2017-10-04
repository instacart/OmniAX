//
//  AbbreviationTransformer.swift
//  AX
//
//  Created by Dan Loman on 10/3/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

/// Pass an array of Transforms to AX.configure(knownAbbreviations:transformers:) to utilize in AX.unabbreviate(string:)
public typealias Transform = (String) -> String

public protocol AbbrevationTransformer {
    func unabbreviate(string: String?) -> String?
}

public extension Transformer {

    /// Creates a regex find/replace Transform function for Transformer to understand.
    ///
    /// - Parameters:
    ///   - pattern: regex pattern to match
    ///   - value: replace with
    /// - Returns: Transform function
    public static func replace(pattern: String, with value: String) -> Transform {
        return { string -> String in
            var correctedString = string
            do {
                let regEx = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
                correctedString = regEx.stringByReplacingMatches(in: correctedString, options: [], range: correctedString.completeRange, withTemplate: value)
            } catch {}
            return correctedString
        }
    }
}

public struct Transformer: AbbrevationTransformer {
    var knownAbbreviations: [String: String] = [:]

    var generalTransforms: [Transform] = []

    // Keep init internal. AX users can create custom AbbreviationTransformer type
    init() {}

    /// Uses regular expression to replace occurrences of known abbrevations into their corresponding full words
    /// Iterates through and performs all generalTransform functions passed in AX configuration
    public func unabbreviate(string: String?) -> String? {
        guard AX.voiceOverEnabled, var correctedString = string else {
            return string
        }

        // Replace abbreviations
        for (key, value) in knownAbbreviations {
            correctedString = Transformer.replace(pattern: "\\b\(key)\\b", with: value)(correctedString)
        }

        // Perform general transforms
        generalTransforms.forEach({ transform in
            correctedString = transform(correctedString)
        })

        return correctedString
    }
}
