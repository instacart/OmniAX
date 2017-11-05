//
//  AXCompatible+UIFont.swift
//  OmniAX
//
//  Created by Dan Loman on 11/4/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

extension AXType where Root: UIFont {
    public func dynamicallyScaled(style: UIFontTextStyle = .headline) -> UIFont {
        return root.scaled(style: style)
    }
}

//  Example Usage:
//
//  extension UIFont {
//      static func customFont(size: CGFloat) -> UIFont {
//          return UIFont(name: "yourCustomFontName", size: size)!.ax.dynamicallyScaled()
//      }
//  }
//
//  struct Example {
//      let font: UIFont = .customFont(size: 14)
//  }
//
