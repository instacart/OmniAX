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
        let icon: UIImage = .literal(#imageLiteral(resourceName: "IconMicrophone"))
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

    private lazy var loadingLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        layer.strokeEnd = 0
        return layer
    }()

    private static let buttonWidthHeight: CGFloat = 50

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        addSubview(dictateButton)

        layer.addSublayer(borderLayer)
        layer.addSublayer(loadingLayer)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        dictateButton.constrain() {
            let widthHeight = DictationView.buttonWidthHeight

            $0.pin(\.centerXAnchor)
                .pin(\.centerYAnchor, to: self)
                .set(\.heightAnchor)
                .set(\.widthAnchor, to: widthHeight)
        }
    }

    func show(loading: Bool) {
        if loading {
            let start = CABasicAnimation(keyPath: "strokeStart")
            start.toValue = 1
            start.duration = 1
            start.beginTime = 0.25
            start.fillMode = kCAFillModeForwards
            start.timingFunction = .init(name: kCAMediaTimingFunctionEaseInEaseOut)

            let end = CABasicAnimation(keyPath: "strokeEnd")
            end.toValue = 1
            end.duration = 1
            end.fillMode = kCAFillModeForwards

            let group = CAAnimationGroup()
            group.animations = [start, end]
            group.duration = 1.5

            group.repeatCount = .infinity

            loadingLayer.add(group, forKey: nil)
        } else {
            loadingLayer.removeAllAnimations()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        borderLayer.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: .pixel))

        // Loading layer layout
        let twoPi: CGFloat = 2 * .pi
        let startAngle: CGFloat = -0.25 * twoPi
        loadingLayer.path = UIBezierPath(arcCenter: center, radius: dictateButton.frame.size.height / 2, startAngle: startAngle, endAngle: startAngle + twoPi, clockwise: true).cgPath
    }
}

@available(iOS 10.0, *)
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
