//
//  Output.swift
//  OmniAX
//
//  Created by Dan Loman on 10/26/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation
import Speech

typealias OutputHandler<A> = (Output<A>) -> Void

public enum Output<A> {
    case loading(Bool)
    case success(A)
    case failure(Error)
}

extension Output where A == String {
    static func handle(output: @escaping OutputHandler<String>) -> ((SFSpeechRecognitionResult?, Error?) -> Void) {
        return { result, error in
            if let result = result {
                output(.success(result.bestTranscription.formattedString))
            } else if let error = error {
                output(.failure(error))
            }
        }
    }
}
