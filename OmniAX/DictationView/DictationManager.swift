//
//  DictationManager.swift
//  OmniAX
//
//  Created by Dan Loman on 10/24/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Speech
import AudioToolbox

@available(iOS 10.0, *)
final class DictationManager {
    private lazy var audioEngine: AVAudioEngine = {
        return .init()
    }()

    private var recognitionTask: SFSpeechRecognitionTask?
    private weak var timer: Timer?

    private let nodeBus: AVAudioNodeBus = 0
    private let audioSession = AVAudioSession.sharedInstance()

    var output: OutputHandler<String>?

    func toggleDictation() {
        guard !audioEngine.isRunning else {
            stopRecording()
            return
        }

        output?(.loading(true))

        do {
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
                if let result = result {
                    let resultString = result.bestTranscription.formattedString
                    output(.success(resultString))
                    if result.isFinal {
                        self?.stopRecording()
                        AX.post(notification: .announcement, focus: String.localizedStringWithFormat("Dictate. Entered: %@", resultString))
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
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeMeasurement, options: [])
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
        guard audioEngine.isRunning else {
            return
        }
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: nodeBus)

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
                self?.stopRecording()
            })
        } else {
            timer = nil
        }
    }
}
