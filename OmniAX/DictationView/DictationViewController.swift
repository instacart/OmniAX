//
//  DictationViewController.swift
//  OmniAX
//
//  Created by Dan Loman on 10/26/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit
import Speech

@available(iOS 10.0, *)
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

public protocol DictationDelegate: class {
    func dispatch(result: Output<String>)
}

@available(iOS 10.0, *)
final class DictationViewController: UIViewController {
    private(set) var dictationView: DictationView = ._init() {
        $0.dictateButton.addTarget(self, action: #selector(didTapDictate(sender:)), for: .touchUpInside)
    }

    private weak var delegate: DictationDelegate? {
        return dictationView.delegate
    }

    private lazy var dictationManager: DictationManager = {
        return DictationManager()
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dictationView)

        dictationManager.output = { [weak self] in
            switch $0 {
            case .loading(let loading):
                self?.dictationView.show(loading: loading)
            case .failure:
                self?.dictationView.show(loading: false)
            case .success:
                break
            }
            self?.delegate?.dispatch(result: $0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkAccess()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        dictationView.frame = view.frame
    }

    @objc private func didTapDictate(sender: UIButton) {
        dictationManager.toggleDictation()
    }

    private func checkAccess() {
        let status = SFSpeechRecognizer.authorizationStatus()
        guard status == .notDetermined else {
            return dictationView.dictateButton.isEnabled = status == .authorized
        }

        SFSpeechRecognizer.requestAuthorization { state in
            OperationQueue.main.addOperation { [weak self] in
                self?.dictationView.dictateButton.isEnabled = state == .authorized
            }
        }
    }
}
