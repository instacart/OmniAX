//
//  UIImage+AX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/27/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension UIImage {
    static func imageFromLiteral(_ wrapped: WrappedImage) -> UIImage {
        return wrapped.image
    }

    func with(color: UIColor) -> UIImage {
        var alpha: CGFloat = 0
        if color == UIColor.white {
            alpha = 1
        } else {
            color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        }

        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return self
        }

        draw(in: rect, blendMode: .normal, alpha: alpha)

        context.setFillColor(color.cgColor)
        context.setBlendMode(.sourceAtop)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image ?? self
    }
}

struct WrappedImage {
    let image: UIImage
}

extension WrappedImage: _ExpressibleByImageLiteral {
    init(imageLiteralResourceName path: String) {
        self.image = UIImage(named: path, in: Bundle(for: DictationView.self), compatibleWith: nil)!
    }
}
