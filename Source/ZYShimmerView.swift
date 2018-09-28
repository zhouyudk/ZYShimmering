//
//  ZYShimmerView.swift
//  ZYShimmer
//
//  Created by yu zhou on 25/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

public enum ZYShimmerDirection: Int {
    case right,left,up,down
}
public class ZYShimmerView: UIView {
    
    /// 需要闪烁的view，包括其子类
    public var contentView: UIView = UIView() {
        didSet{
            if oldValue != contentView {
                oldValue.removeFromSuperview()
                self.addSubview(contentView)
                if let layer = self.layer as? ZYShimmerLayer {
                    layer.contentLayer = contentView.layer
                }
            }
        }
    }
    
    /// 是否闪烁，默认false
    public var shimmering: Bool {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmering ?? false
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmering = newValue
        }
    }
    
    /// 闪烁间隔时间，默认0.4s
    public var shimmeringPauseDuration: TimeInterval {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringPauseDuration ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringPauseDuration = newValue
        }
    }
    
    /// 闪烁区域透明，默认0.5
    public var shimmeringAnimationOpacity: CGFloat {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringAnimationOpacity ?? 1
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringAnimationOpacity = newValue
        }
    }
    
    /// 闪烁时content透明度，默认1
    public var shimmeringOpacity: CGFloat {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringOpacity ?? 1
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringOpacity = newValue
        }
    }
    
    /// 闪烁移动速度，默认230
    public var shimmeringSpeed: CGFloat {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringSpeed ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringSpeed = newValue
        }
    }
    
    /// 闪烁区域范围[0,1],默认1
    public var shimmeringHighlightLength: CGFloat {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringHighlightLength ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringHighlightLength = newValue > 0 ? (newValue > 1 ? 1 : newValue) : 0
        }
    }
    
    /// 闪烁方向，默认向右
    public var shimmeringDirection: ZYShimmerDirection {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringDirection ?? .right
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringDirection = newValue
        }
    }
    
    /// 闪烁过渡结束的时间点CoreAnimation CACurrentMediaTime
    public var shimmeringFadeTime: TimeInterval {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringFadeTime ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringFadeTime = newValue
        }
    }
    
    /// 开始闪烁前的过渡时间长度，默认0.1
    public var shimmeringBeginFadeDuration: TimeInterval {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringBeginFadeDuration ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringBeginFadeDuration = newValue
        }
    }
    /// 结束闪烁后的过渡时间长度，默认0.3
    public var shimmeringEndFadeDuration: TimeInterval {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringEndFadeDuration ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringEndFadeDuration = newValue
        }
    }

    /// 闪烁开始的时间点CoreAnimation CACurrentMediaTime
    public var shimmeringBeginTime: TimeInterval {
        get{
            return (self.layer as? ZYShimmerLayer)?.shimmeringBeginTime ?? 0
        }
        set{
            (self.layer as? ZYShimmerLayer)?.shimmeringBeginTime = newValue
        }
    }
    
    
    public override class var layerClass: AnyClass {
        return ZYShimmerLayer.classForCoder()
    }
    
    public override func layoutSubviews() {
        contentView.bounds = self.bounds
        contentView.center = self.center
    }
    
}
