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

    weak var delegate: AXDictationDelegate?

    private lazy var borderLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        return layer
    }()

    private lazy var loadingLayer: LoadingLayer = {
        return LoadingLayer()
    }()

    private static let buttonWidthHeight: CGFloat = 50

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = .white
        
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
        loadingLayer.show(loading: loading)
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
