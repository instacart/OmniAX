//
//  DictationManager.swift
//  OmniAX
//
//  Created by Dan Loman on 10/24/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Speech
import AudioToolbox

final class DictationManager {
    private lazy var audioEngine: AVAudioEngine = .init()

    private var recognitionTask: SFSpeechRecognitionTask?
    private weak var timer: Timer?

    private let nodeBus: AVAudioNodeBus = 0
    private let audioSession = AVAudioSession.sharedInstance()

    var output: OutputHandler<String>?

    func toggleDictation() {
        do {
            guard !audioEngine.isRunning else {
                try stopRecording()
                return
            }

            output?(.loading(true))

            AudioPlayer.play(sound: .startRecording)

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
                do {
                    if let result = result {
                        let resultString = result.bestTranscription.formattedString
                        output(.success(resultString))
                        if result.isFinal {
                            try self?.stopRecording()
                            AX.announce(message: .localizedStringWithFormat("Dictate. Entered: %@", resultString))
                        } else {
                            self?.resetAutostopTimer()
                        }
                    } else if let error = error {
                        output(.failure(error))
                        try self?.stopRecording()
                    }
                } catch {
                    output(.failure(error))
                }
            })
        } catch {
            output?(.failure(error))
        }
    }

    private func setupAudioNode() throws -> SFSpeechAudioBufferRecognitionRequest? {
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .allowBluetoothA2DP)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        let node = audioEngine.inputNode
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

    private func stopRecording() throws {
        guard audioEngine.isRunning else {
            return
        }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: nodeBus)
        
        try audioSession.setCategory(.playback, mode: .default, options: [])

        recognitionTask?.cancel()
        recognitionTask = nil
        resetAutostopTimer(newTimer: false)

        AudioPlayer.play(sound: .stopRecording)

        output?(.loading(false))
    }

    private func resetAutostopTimer(newTimer: Bool = true) {
        timer?.invalidate()
        if newTimer {
            timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { [weak self] _ in
                do {
                    try self?.stopRecording()
                } catch {
                    self?.output?(.failure(error))
                }
            })
        } else {
            timer = nil
        }
    }
}
