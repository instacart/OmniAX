//
//  Dictation.swift
//  OmniAX
//
//  Created by Dan Loman on 10/24/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit
import Speech

typealias ResultHandler<A> = (Result<A>) -> Void

public enum Result<A> {
    case success(A)
    case failure(Error)
    case loading(Bool)
}

@available(iOS 10.0, *)
extension Result where A == String {
    static func handle(output: @escaping ResultHandler<String>) -> ((SFSpeechRecognitionResult?, Error?) -> Void) {
        return { result, error in
            if let result = result {
                output(.success(result.bestTranscription.formattedString))
            } else if let error = error {
                output(.failure(error))
            }
        }
    }
}

public protocol DictationOutput: class {
    func dispatch(result: Result<String>)
}

@available(iOS 10.0, *)
final class DictationViewController: UIViewController {
    private(set) var dictationView: DictationView = .init()

    private weak var output: DictationOutput? {
        return dictationView.output
    }

    private lazy var dictationManager: DictationManager = {
        return DictationManager()
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        dictationView.setup()
        dictationView.dictateButton.addTarget(self, action: #selector(didTapDictate(sender:)), for: .touchUpInside)

        view.addSubview(dictationView)

        dictationManager.output = { [weak self] in
            switch $0 {
            case .loading(let loading):
                self?.dictationView.show(loading: loading)
            case .failure:
                self?.dictationView.show(loading: false)
            case .success:
                self?.dictationView.show(loading: false)
            }
            self?.output?.dispatch(result: $0)
        }
    }

    @objc private func didTapDictate(sender: UIButton) {
        dictationManager.beginDictation()
    }
}

public final class DictationView: UIView {
    let dictateButton: UIButton = .init(type: .custom)

    public weak var output: DictationOutput?

    func setup() {
        addSubview(dictateButton)
        func setupConstraints() {
        }

        setupConstraints()
    }

    func show(loading: Bool) {

    }
}

@available(iOS 10.0, *)
struct DictationManager {
    private lazy var audioEngine: AVAudioEngine = {
        return .init()
    }()

    private var recognitionTask: SFSpeechRecognitionTask?

    var output: ResultHandler<String>?

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
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: Result.handle(output: output))
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

@available(iOSApplicationExtension 10.0, *)
extension AX {
    static var dictationViewController: DictationViewController = .init()

    public static var dictationInputAccessoryView: DictationView {
        return dictationViewController.dictationView
    }
}
