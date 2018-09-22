//
//  LoadingLayer.swift
//  OmniAX
//
//  Created by Dan Loman on 11/5/17.
//  Copyright © 2017 Dan Loman. All rights reserved.
//

import Foundation

final class LoadingLayer: CAShapeLayer {
    private lazy var loadingAnimation: CAAnimationGroup = {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 1
        start.duration = 1
        start.beginTime = 0.25
        start.fillMode = .forwards
        start.timingFunction = .init(name: .easeInEaseOut)
        
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1
        end.duration = 1
        end.fillMode = .forwards
        
        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = 1.5
        
        group.repeatCount = .infinity
        
        return group
    }()
    
    override init() {
        super.init()
        
        strokeColor = UIColor.black.cgColor
        fillColor = UIColor.clear.cgColor
        lineWidth = 2
        strokeEnd = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(loading: Bool) {
        if loading {
            add(loadingAnimation, forKey: nil)
        } else {
            removeAllAnimations()
        }
    }
}
