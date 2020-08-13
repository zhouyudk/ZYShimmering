# ZYShimmer
使View具有闪烁流光的效果。

## 效果
![](https://note.youdao.com/yws/api/personal/file/WEB20b99517dc89b69ba20b44117ee6446a?method=download&shareKey=09988516ae62f1eebaf7ae221f62020a)

## 安装

###  CocoaPods

1. 在 `Podfile` 中添加 `pod 'ZYShimmer'`
2. 执行 `pod install` 或 `pod update`
3. 导入 import ZYShimmer

## 使用
```swift
let shimmerView = ZYShimmerView(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width-20, height: 100))
shimmerView.shimmering = true
shimmerView.shimmeringBeginFadeDuration = 1
shimmerView.shimmeringBeginTime = CACurrentMediaTime()+2
shimmerView.shimmeringOpacity = 0.5
shimmerView.shimmeringAnimationOpacity = 1
self.view.addSubview(shimmerView)
        
let label = UILabel(frame: shimmerView.bounds)
label.attributedText = NSAttributedString(string: "ZYShimmer", attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 50)])
label.textAlignment = .center
shimmerView.contentView = label
```
### 参数
```swift
public var contentView: UIView = UIView() // 需要闪烁的view，包括其子类  
public var shimmering: Bool // 是否闪烁，默认false
public var shimmeringPauseDuration: TimeInterval // 闪烁间隔时间，默认0.4s
public var shimmeringAnimationOpacity: CGFloat // 闪烁区域透明，默认0.5
public var shimmeringOpacity: CGFloat // 闪烁时content透明度，默认1
public var shimmeringSpeed: CGFloat // 闪烁移动速度，默认230
public var shimmeringHighlightLength: CGFloat // 闪烁区域范围[0,1],默认1
public var shimmeringDirection: ZYShimmerDirection // 闪烁方向，默认向右
public var shimmeringFadeTime: TimeInterval // 闪烁过渡结束的时间点CoreAnimation CACurrentMediaTime
public var shimmeringBeginFadeDuration: TimeInterval // 开始闪烁前的过渡时间长度，默认0.1
public var shimmeringEndFadeDuration: TimeInterval // 结束闪烁后的过渡时间长度，默认0.3
public var shimmeringBeginTime: TimeInterval  // 闪烁开始的时间点CoreAnimation CACurrentMediaTime
```

	 
## Swift版本

	Swift 5.0


## Requirements

	iOS 9.0+
	
## 参考

[facebook/Shimmer](https://github.com/facebook/Shimmer)
