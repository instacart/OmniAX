//
//  DictationManager.swift
//  OmniAX
//
//  Created by Dan Loman on 10/24/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Speech

@available(iOS 10.0, *)
final class DictationManager {
    private lazy var audioEngine: AVAudioEngine = {
        return .init()
    }()

    private var recognitionTask: SFSpeechRecognitionTask?
    private weak var timer: Timer?

    private let nodeBus: AVAudioNodeBus = 0

    var output: OutputHandler<String>?

    func toggleDictation() {
        guard !audioEngine.isRunning else {
            stopRecording()
            return
        }
        output?(.loading(true))
        do {
            guard let request = try setupAudioNode() else {
                return
            }
            guard try startAudioEngine() else {
                return
            }
            guard let speechRecognizer = SFSpeechRecognizer(), speechRecognizer.isAvailable else {
                return
            }
            guard let output = output else {
                return
            }
            resetAutostopTimer()
            recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                if let result = result {
                    output(.success(result.bestTranscription.formattedString))
                    if result.isFinal {
                        self?.stopRecording()
                    } else {
                        self?.resetAutostopTimer()
                    }
                } else if let error = error {
                    output(.failure(error))
                    self?.stopRecording()
                }
            })
        } catch {
            output?(.failure(error))
        }
    }

    private func setupAudioNode() throws -> SFSpeechAudioBufferRecognitionRequest? {
        let audioSession = AVAudioSession.sharedInstance()

        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

        guard let node = audioEngine.inputNode else {
            return nil
        }
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let format = node.outputFormat(forBus: nodeBus)
        node.installTap(onBus: nodeBus, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        return request
    }

    private func startAudioEngine() throws -> Bool {
        audioEngine.prepare()
        try audioEngine.start()
        return true
    }

    private func stopRecording() {
        audioEngine.stop()
        if let node = audioEngine.inputNode {
            node.removeTap(onBus: nodeBus)
        }
        recognitionTask?.cancel()
        recognitionTask = nil
        resetAutostopTimer(newTimer: false)
        output?(.loading(false))
    }

    private func resetAutostopTimer(newTimer: Bool = true) {
        timer?.invalidate()
        if newTimer {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                self?.stopRecording()
            })
        } else {
            timer = nil
        }
    }
}
