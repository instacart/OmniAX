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

public protocol DictationOutput: class {
    func dispatch(result: Output<String>)
}

@available(iOS 10.0, *)
final class DictationViewController: UIViewController {
    private(set) var dictationView: DictationView = ._init() {
        $0.dictateButton.addTarget(self, action: #selector(didTapDictate(sender:)), for: .touchUpInside)
    }

    private weak var output: DictationOutput? {
        return dictationView.output
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
                self?.dictationView.show(loading: false)
            }
            self?.output?.dispatch(result: $0)
        }
    }

    @objc private func didTapDictate(sender: UIButton) {
        dictationManager.beginDictation()
    }
}
