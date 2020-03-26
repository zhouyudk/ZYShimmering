//
//  ZYShimmerLayer.swift
//  ZYShimmer
//
//  Created by yu zhou on 25/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

// animations keys
fileprivate let kZYShimmerSlideAnimationKey = "slide"
fileprivate let kZYFadeAnimationKey = "fade"
fileprivate let kZYEndFadeAnimationKey = "fade-end"

fileprivate func fade_animation(layer: CALayer,opacity: CGFloat,duration: TimeInterval) -> CABasicAnimation {
    let anim = CABasicAnimation(keyPath: "opacity")
    anim.fromValue = (layer.presentation() ?? layer).opacity
    anim.toValue = Float(opacity)
    anim.duration = duration
    anim.fillMode = CAMediaTimingFillMode.both
    anim.isRemovedOnCompletion = false
    return anim
}

fileprivate func shimmer_slide_animation(duration: TimeInterval,direction: ZYShimmerDirection) -> CABasicAnimation {
    let anim = CABasicAnimation(keyPath: "position")
    anim.toValue = CGPoint.zero
    anim.duration = duration
    anim.repeatCount = MAXFLOAT
    if direction == .left || direction == .up {
        anim.speed = -fabsf(anim.speed)
    }
    return anim
}

fileprivate func shimmer_slide_repeat(a: CAAnimation, duration:TimeInterval,direction: ZYShimmerDirection) -> CAAnimation {
    let anim = a.copy() as! CAAnimation
    anim.repeatCount = MAXFLOAT
    anim.duration = duration
    anim.speed = (direction == .right || direction == .down) ? fabsf(anim.speed) : -fabsf(anim.speed)
    return anim
}

fileprivate func shimmer_slide_finish(a: CAAnimation) -> CAAnimation {
    let anim = a.copy() as! CAAnimation
    anim.repeatCount = 0
    return anim
}

class ZYShimmerMaskLayer: CAGradientLayer {
    var fadeLayer:CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    override init() {
        super.init()
        self.addSublayer(fadeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSublayer(fadeLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let r = self.bounds
        fadeLayer.bounds = r
        fadeLayer.position = CGPoint(x: r.midX, y: r.midY)
    }
}

class ZYShimmerLayer: CALayer {
    var maskLayer: ZYShimmerMaskLayer?
    var contentLayer: CALayer? {
        didSet{
            //重置mask
            self.maskLayer = nil
            self.sublayers = contentLayer == nil ? nil : [ contentLayer! ]
            self.updateShimmering()
        }
    }
    
    var shimmering: Bool {
        didSet{
            if oldValue != shimmering {
                self.updateShimmering()
            }
        }
    }
    var shimmeringPauseDuration: TimeInterval {
        didSet{
            if oldValue != shimmeringPauseDuration {
                self.updateShimmering()
            }
        }
    }
    var shimmeringAnimationOpacity: CGFloat {
        didSet{
            if oldValue != shimmeringAnimationOpacity {
                self.updateShimmering()
            }
        }
    }
    var shimmeringOpacity: CGFloat {
        didSet{
            if oldValue != shimmeringOpacity {
                self.updateShimmering()
            }
        }
    }
    var shimmeringSpeed: CGFloat {
        didSet{
            if oldValue != shimmeringSpeed {
                self.updateShimmering()
            }
        }
    }
    var shimmeringHighlightLength: CGFloat {
        didSet{
            if oldValue != shimmeringHighlightLength {
                self.updateShimmering()
            }
        }
    }
    var shimmeringDirection: ZYShimmerDirection {
        didSet{
            if oldValue != shimmeringDirection {
                self.updateShimmering()
            }
        }
    }
    var shimmeringFadeTime: TimeInterval {
        didSet{
            if oldValue != shimmeringFadeTime {
                self.updateShimmering()
            }
        }
    }
    var shimmeringBeginFadeDuration: TimeInterval {
        didSet{
            if oldValue != shimmeringBeginFadeDuration {
                self.updateShimmering()
            }
        }
    }
    var shimmeringEndFadeDuration: TimeInterval {
        didSet{
            if oldValue != shimmeringEndFadeDuration {
                self.updateShimmering()
            }
        }
    }
    var shimmeringBeginTime: TimeInterval {
        didSet{
            if shimmeringBeginTime != oldValue {
                self.updateShimmering()
            }
        }
    }
    
    override var bounds: CGRect {
        willSet{
            super.bounds = newValue
            if bounds != newValue {
                self.updateShimmering()
            }
        }
    }
    
    override init() {
        shimmering = false
        shimmeringPauseDuration = 0.4
        shimmeringSpeed = 230.0
        shimmeringHighlightLength = 1.0
        shimmeringAnimationOpacity = 0.5
        shimmeringOpacity = 1.0
        shimmeringDirection = .right
        shimmeringBeginFadeDuration = 0.1
        shimmeringEndFadeDuration = 0.3
        shimmeringBeginTime = TimeInterval(CGFloat.greatestFiniteMagnitude)
        shimmeringFadeTime = 1
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        shimmering = false
        shimmeringPauseDuration = 0.4
        shimmeringSpeed = 230.0
        shimmeringHighlightLength = 1.0
        shimmeringAnimationOpacity = 0.5
        shimmeringOpacity = 1.0
        shimmeringDirection = .right
        shimmeringBeginFadeDuration = 0.1
        shimmeringEndFadeDuration = 0.3
        shimmeringBeginTime = TimeInterval(CGFloat.greatestFiniteMagnitude)
        shimmeringFadeTime = 1
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let r = self.bounds
        contentLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        contentLayer?.bounds = r
        contentLayer?.position = CGPoint(x: r.midX, y: r.maxY)
        if maskLayer != nil {
            self.updateMaskLayout()
        }
    }
    
    func clearMask() {
        guard maskLayer != nil  else { return }
        let disableActions = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        self.maskLayer = nil
        contentLayer?.mask = nil
        CATransaction.setDisableActions(disableActions)
    }
    
    func createMaskIfNeeded() {
        if shimmering && maskLayer == nil {
            maskLayer = ZYShimmerMaskLayer()
            maskLayer?.delegate = self
            contentLayer?.mask = maskLayer
            self.updateMaskColors()
            self.updateMaskLayout()
        }
    }
    
    func updateMaskColors() {
        guard maskLayer != nil else { return }
        //颜色不重要，只有透明度会生效
        let maskedColor = UIColor.white.withAlphaComponent(shimmeringOpacity).cgColor
        let unmaskedColor = UIColor.white.withAlphaComponent(shimmeringAnimationOpacity).cgColor
        maskLayer?.colors = [maskedColor,unmaskedColor,maskedColor]
    }
    func updateMaskLayout() {
        var length: CGFloat = 0.0
        switch shimmeringDirection {
        case .up,.down:
            length = contentLayer?.bounds.height ?? 0
        case .left,.right:
            length = contentLayer?.bounds.width ?? 0
        }
        guard length != 0 else { return }
        
        let extraDistance = length + shimmeringSpeed * CGFloat(shimmeringPauseDuration)
        
        let fullShimmerLength = length*3 + extraDistance
        let traveDistance = length*2 + extraDistance
        
        let highlightOutsideLength: Double = Double((1 - shimmeringHighlightLength) / 2)
        maskLayer?.locations = [NSNumber(floatLiteral: highlightOutsideLength),0.5,NSNumber(floatLiteral: 1-highlightOutsideLength)]
        
        let startPoint = (length + extraDistance) / fullShimmerLength
        let endPoint = traveDistance / fullShimmerLength
        
        maskLayer?.anchorPoint = CGPoint.zero
        switch shimmeringDirection {
        case .down,.up:
            maskLayer?.startPoint = CGPoint(x: 0, y: startPoint)
            maskLayer?.endPoint = CGPoint(x: 0, y: endPoint)
            maskLayer?.position = CGPoint(x: 0, y: -traveDistance)
            maskLayer?.bounds = CGRect(x: 0, y: 0, width: contentLayer?.bounds.width ?? 0, height: fullShimmerLength)
        case .right,.left:
            maskLayer?.startPoint = CGPoint(x: startPoint, y: 0)
            maskLayer?.endPoint = CGPoint(x: endPoint, y: 0)
            maskLayer?.position = CGPoint(x: -traveDistance, y: 0)
            maskLayer?.bounds = CGRect(x: 0, y: 0, width: fullShimmerLength, height: contentLayer?.bounds.height ?? 0)
        }
    }
    
    func updateShimmering() {
        self.createMaskIfNeeded()
        
        guard shimmering || maskLayer != nil else { return }
        
        self.layoutIfNeeded()
        
        let disableActions = CATransaction.disableActions()
        if !shimmering {
            guard disableActions == false else { return }
            var slideEndTime: TimeInterval = 0
            if let slideAnimation = maskLayer?.animation(forKey: kZYShimmerSlideAnimationKey) {
                let now = CACurrentMediaTime()
                let slideTotalDuration = now - slideAnimation.beginTime
                let slideTimeOffset = fmod(slideTotalDuration, slideAnimation.duration)
                let finishAnim = shimmer_slide_finish(a: slideAnimation)
                
                finishAnim.beginTime = now - slideTimeOffset
                
                slideEndTime = finishAnim.beginTime + slideAnimation.duration
                maskLayer?.add(finishAnim, forKey: kZYShimmerSlideAnimationKey)
            }
            
            let fadeInAnimation = fade_animation(layer: maskLayer!.fadeLayer, opacity: 1, duration: shimmeringEndFadeDuration)
            fadeInAnimation.delegate = self
            fadeInAnimation.beginTime = slideEndTime
            fadeInAnimation.setValue(true, forKey: kZYFadeAnimationKey)
            maskLayer?.fadeLayer.add(fadeInAnimation, forKey: kZYFadeAnimationKey)
            
            shimmeringFadeTime = slideEndTime
        } else {
            var fadeOutAnimation: CABasicAnimation? = nil
            if shimmeringBeginFadeDuration > 0 && !disableActions {
                fadeOutAnimation = fade_animation(layer: maskLayer!.fadeLayer, opacity: 0, duration: shimmeringBeginFadeDuration)
                maskLayer?.fadeLayer.add(fadeOutAnimation!, forKey: kZYFadeAnimationKey)
            } else {
                let innerDisableActions = CATransaction.disableActions()
                CATransaction.setDisableActions(true)
                
                maskLayer?.fadeLayer.opacity = 0
                maskLayer?.fadeLayer.removeAllAnimations()
                
                CATransaction.setDisableActions(innerDisableActions)
            }
            
            
            
            var length: CGFloat = 0
            if shimmeringDirection == .up || shimmeringDirection == .down {
                length = contentLayer?.bounds.height ?? 0
            }else {
                length = contentLayer?.bounds.width ?? 0
            }
            
            let animationDuration = length / shimmeringSpeed + CGFloat(shimmeringPauseDuration)
            
            var slideAnim = maskLayer?.animation(forKey: kZYShimmerSlideAnimationKey)
            guard slideAnim == nil else {
                maskLayer?.add(shimmer_slide_repeat(a: slideAnim!, duration: TimeInterval(animationDuration), direction: shimmeringDirection), forKey: kZYShimmerSlideAnimationKey)
                return
            }
            slideAnim = shimmer_slide_animation(duration: TimeInterval(animationDuration), direction: shimmeringDirection)
            slideAnim?.fillMode = CAMediaTimingFillMode.forwards
            slideAnim?.isRemovedOnCompletion = false
            if shimmeringBeginTime == TimeInterval(CGFloat.greatestFiniteMagnitude) {
                shimmeringBeginTime = CACurrentMediaTime() + (fadeOutAnimation?.duration ?? 0)!
            }
            slideAnim?.beginTime = shimmeringBeginTime
            maskLayer?.add(slideAnim!, forKey: kZYShimmerSlideAnimationKey)
        }
    }
}

extension ZYShimmerLayer: CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return nil
    }
}

extension ZYShimmerLayer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let key = anim.value(forKey: kZYEndFadeAnimationKey) as? Bool  else { return }
        if flag && key {
            maskLayer?.fadeLayer.removeAnimation(forKey: kZYFadeAnimationKey)
            self.clearMask()
        }
    }
}
