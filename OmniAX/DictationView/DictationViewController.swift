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

public protocol AXDictationDelegate: class {
    func dispatch(result: Output<String>)
}

@available(iOS 10.0, *)
final class DictationViewController: UIViewController {
    private(set) var dictationView: DictationView = ._init() {
        $0.dictateButton.addTarget(self, action: #selector(didTapDictate(sender:)), for: .touchUpInside)
    }

    private weak var delegate: AXDictationDelegate? {
        return dictationView.delegate
    }

    fileprivate lazy var dictationManager: DictationManager = {
        return DictationManager()
    }()

    override func loadView() {
        view = dictationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dictationManager.output = { [weak self] in
            switch $0 {
            case .loading(let loading):
                self?.dictationView.show(loading: loading)
            case .failure:
                self?.dictationView.show(loading: false)
            case .success:
                break
            }
            DictationOutputManager.instance.dispatch(output: $0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkAccess()
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

//final class OutputManager {
//    private let outputs = NSPointerArray.weakObjects()
//
//    var activeOutput: AnyObject? {
//        outputs.compact()
//
//        for pointerIndex in 0..<outputs.count {
//            guard let pointer = outputs.pointer(at: pointerIndex) else { continue }
//            let object = Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
//
//            if let object = object as? UITextField, object.isFirstResponder {
//                return object
//            } else if let object = object as? UITextView, object.isFirstResponder {
//                return object
//            }
//        }
//        return nil
//    }
//
//    func add(output: UIResponder) {
//        let outputPointer = Unmanaged.passUnretained(output).toOpaque()
//        outputs.addPointer(outputPointer)
//    }
//}
//
//extension OutputManager: AXDictationDelegate {
//    func dispatch(result: Output<String>) {
//        switch result {
//        case .success(let text):
//            set(text: text, for: activeOutput)
//        default:
//            break
//        }
//    }
//
//    private func set(text: String, for output: AnyObject?) {
//        if let active = output as? UITextField {
//            active.text = text
//        } else if let active = output as? UITextView {
//            active.text = text
//        }
//    }
//}

public protocol DictationDelegate: class {
    func dispatch(output: Output<String>)
}

final class DictationOutputManager {
    static let instance = DictationOutputManager()
    
    var outputs: Set<WrappedDelegate> = []
    
    func remove(wrapped: WrappedDelegate) {
        outputs.remove(wrapped)
    }
    
    func add(delegate: DictationDelegate?) -> OutputReference {
        let reference = OutputReference(delegate: delegate)
        outputs.insert(reference.wrapped)
        
        return reference
    }
    
    func dispatch(output: Output<String>) {
        outputs.forEach({ $0.delegate?.dispatch(output: output) })
    }
}

final class WrappedDelegate {
    let id = UUID()
    weak var delegate: DictationDelegate?
    
    init(delegate: DictationDelegate?) {
        self.delegate = delegate
    }
}

extension WrappedDelegate: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: WrappedDelegate, rhs: WrappedDelegate) -> Bool {
        return lhs.id == rhs.id
    }
}

public final class OutputReference {
    private(set) var wrapped: WrappedDelegate

    init(delegate: DictationDelegate?) {
        self.wrapped = WrappedDelegate(delegate: delegate)
    }

    deinit {
        DictationOutputManager.instance.remove(wrapped: wrapped)
    }
}

@available(iOS 10.0, *)
extension AX {
    fileprivate static let dictationViewController = DictationViewController()
    
    static func dictationInputAccessoryView(parent: UIViewController?, delegate: DictationDelegate?) -> (UIView, OutputReference) {
        var width: CGFloat = UIScreen.main.bounds.width
        
        let controller = AX.dictationViewController

        controller.view.removeFromSuperview()

        if let parent = parent {
            parent.addChildViewController(controller)
            controller.didMove(toParentViewController: parent)

            width = parent.view.bounds.width
        }

        controller.view.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: width,
                height: 60
            )
        )

        return (controller.view, DictationOutputManager.instance.add(delegate: delegate))
    }
}
