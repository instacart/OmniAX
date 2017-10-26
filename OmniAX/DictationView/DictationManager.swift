//
//  DictationManager.swift
//  OmniAX
//
//  Created by Dan Loman on 10/24/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Speech

@available(iOS 10.0, *)
struct DictationManager {
    private lazy var audioEngine: AVAudioEngine = {
        return .init()
    }()

    private var recognitionTask: SFSpeechRecognitionTask?

    var output: OutputHandler<String>?

    mutating func beginDictation() {
        output?(.loading(true))
        guard let request = setupAudioNode() else {
            return
        }
        guard startAudioEngine() else {
            return
        }
        guard let speechRecognizer = SFSpeechRecognizer(), speechRecognizer.isAvailable else {
            return
        }
        guard let output = output else {
            return
        }
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: Output.handle(output: output))
    }

    private mutating func setupAudioNode() -> SFSpeechAudioBufferRecognitionRequest? {
        guard let node = audioEngine.inputNode else {
            return nil
        }
        let request = SFSpeechAudioBufferRecognitionRequest()
        let nodeBus: AVAudioNodeBus = 0
        let format = node.outputFormat(forBus: nodeBus)
        node.installTap(onBus: nodeBus, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        return request
    }

    private mutating func startAudioEngine() -> Bool {
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            output?(.failure(error))
            return false
        }
        return true
    }
}
