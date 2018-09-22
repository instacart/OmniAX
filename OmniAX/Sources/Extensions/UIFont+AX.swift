//
//  UIFont+AX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/23/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension UIFont {
    func scaled(style: UIFont.TextStyle = .headline) -> UIFont {
        let size = fontDescriptor.fontAttributes[.size] as? CGFloat ?? pointSize

        let attributes: [UIFontDescriptor.AttributeName: Any] = [
            .size: scaled(fontSize: size, style: .headline)
        ]

        return UIFont(descriptor: fontDescriptor.addingAttributes(attributes), size: 0)
    }

    // Default to headline style to prevent massive sizes from making unoptimized apps unusable
    private func scaled(fontSize: CGFloat, style: UIFont.TextStyle = .headline) -> CGFloat {
        let systemSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize

        guard systemSize != style.defaultSize else {
            return fontSize
        }

        return ceil((systemSize / style.defaultSize) * fontSize)
    }
 }

private extension UIFont.TextStyle {
    var defaultSize: CGFloat {
        switch self {
        case .body:
            return 17
        case .callout:
            return 16
        case .caption1:
            return 12
        case .caption2:
            return 10
        case .footnote:
            return 13
        case .headline:
            return 17
        case .largeTitle:
            return 34
        case .subheadline:
            return 15
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        default:
            return 17
        }
    }
}
