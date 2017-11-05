//
//  UIView+AX.swift
//  OmniAX
//
//  Created by Dan Loman on 10/26/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit

extension UIView {
    class func _init<View: UIView>(setup: ((View) -> Void)? = nil) -> View {
        let view = View.init(frame: .zero)
        setup?(view)

        return view
    }
}
