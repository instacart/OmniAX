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
        let icon: UIImage = .imageFromLiteral(#imageLiteral(resourceName: "IconMicrophone"))
        $0.setImage(icon, for: .normal)
        $0.setImage(icon.with(color: .lightGray), for: .highlighted)
        $0.accessibilityLabel = NSLocalizedString("Dictate", comment: "")
        $0.accessibilityHint = NSLocalizedString("Press to dictate", comment: "")
    }

    weak var delegate: DictationDelegate?

    private lazy var borderLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        return layer
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        addSubview(dictateButton)

        layer.addSublayer(borderLayer)

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
                .set(\.heightAnchor, to: widthHeight)
                .set(\.widthAnchor, to: widthHeight)
        }
    }

    func show(loading: Bool) {
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        borderLayer.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: .pixel))
    }
}

@available(iOSApplicationExtension 10.0, *)
extension AX {
    static let dictationViewController: DictationViewController = .init()

    public static var dictationInputAccessoryView: UIView {
        dictationViewController.view.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 60))
        return dictationViewController.view
    }

    public static var dictationDelegate: DictationDelegate? {
        get {
            return dictationViewController.dictationView.delegate
        }
        set {
            dictationViewController.dictationView.delegate = newValue
        }
    }
}
