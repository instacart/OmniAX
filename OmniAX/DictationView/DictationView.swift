//
//  DictationView.swift
//  OmniAX
//
//  Created by Dan Loman on 10/26/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit

final class DictationView: UIView {
    let dictateButton: UIButton = ._init() {
        let icon: UIImage = #imageLiteral(resourceName: "microphone")
        $0.setImage(icon, for: .normal)
        $0.accessibilityLabel = NSLocalizedString("Dictate", comment: "")
        $0.accessibilityHint = NSLocalizedString("Press to dictate", comment: "")
    }

    public weak var output: DictationOutput?

    init() {
        super.init(frame: .zero)

        addSubview(dictateButton)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        dictateButton.constrain() {
            let widthHeight: CGFloat = 50

            $0.pin(\.centerXAnchor)
                .pin(\.centerYAnchor, to: self)
                .set(\.heightAnchor)
                .set(\.widthAnchor, to: widthHeight)
        }
    }

    func show(loading: Bool) {
    }
}

@available(iOSApplicationExtension 10.0, *)
extension AX {
    static var dictationViewController: DictationViewController = .init()

    public static var dictationInputAccessoryView: UIView {
        return dictationViewController.view
    }
}
