//
//  Autolayout.swift
//  OmniAX
//
//  Created by Dan Loman on 10/26/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import UIKit

final class Constrainer {
    var hasConstraints: Bool {
        return !constraints.isEmpty
    }

    private let view: UIView
    private var constraints: [NSLayoutConstraint] = []
    private var pendingConstants: [PartialKeyPath<UIView>] = []
    private var pendingPins: [PartialKeyPath<UIView>] = []

    init(view: UIView) {
        self.view = view
    }

    func activate() {
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraints)
    }

    private func append(constraint: NSLayoutConstraint) {
        // TODO: check if constraint exists
        constraints.append(constraint)
    }

    @discardableResult
    func pin(_ path: KeyPath<UIView, NSLayoutYAxisAnchor>, to: UIView? = nil) -> Constrainer {
        if let to = to {
            append(constraint: view[keyPath: path].constraint(equalTo: to[keyPath: path]))
            setPendingPins(to: to)
        } else {
            pendingPins.append(path)
        }
        return self
    }

    @discardableResult
    func pin(_ path: KeyPath<UIView, NSLayoutXAxisAnchor>, to: UIView? = nil) -> Constrainer {
        if let to = to {
            append(constraint: view[keyPath: path].constraint(equalTo: to[keyPath: path]))
            setPendingPins(to: to)
        } else {
            pendingPins.append(path)
        }
        return self
    }

    @discardableResult
    func pin(_ path: KeyPath<UIView, NSLayoutDimension>, to: UIView? = nil) -> Constrainer {
        if let to = to {
            append(constraint: view[keyPath: path].constraint(equalTo: to[keyPath: path]))
            setPendingPins(to: to)
        } else {
            pendingPins.append(path)
        }
        return self
    }

    @discardableResult
    func set(_ path: KeyPath<UIView, NSLayoutDimension>, to: CGFloat? = nil) -> Constrainer {
        if let to = to {
            append(constraint: view[keyPath: path].constraint(equalToConstant: to))
            setPendingConstants(to: to)
        } else {
            pendingConstants.append(path)
        }
        return self
    }

    private func setPendingPins(to: UIView) {
        for pending in pendingPins {
            createNewConstraint(path: pending, to: to)
        }
        pendingPins = []
    }

    private func setPendingConstants(to: CGFloat) {
        for pending in pendingConstants {
            if let p = pending as? KeyPath<UIView, NSLayoutDimension> {
                append(constraint: view[keyPath: p].constraint(equalToConstant: to))
            }
        }
        pendingConstants = []
    }

    private func createNewConstraint(path: PartialKeyPath<UIView>, to: UIView) {
        var constraint: NSLayoutConstraint? = nil
        if let p = path as? KeyPath<UIView, NSLayoutYAxisAnchor> {
            constraint = view[keyPath: p].constraint(equalTo: to[keyPath: p])
        } else if let p = path as? KeyPath<UIView, NSLayoutXAxisAnchor> {
            constraint = view[keyPath: p].constraint(equalTo: to[keyPath: p])
        } else if let p = path as? KeyPath<UIView, NSLayoutDimension> {
            constraint = view[keyPath: p].constraint(equalTo: to[keyPath: p])
        }

        if let constraint = constraint {
            append(constraint: constraint)
        }
    }
}

extension UIView {
    func constrain(_ setup: ((Constrainer) -> Void)? = nil) {
        let constrainer = Constrainer(view: self)
        setup?(constrainer)

        if constrainer.hasConstraints {
            constrainer.activate()
        }
    }
}
