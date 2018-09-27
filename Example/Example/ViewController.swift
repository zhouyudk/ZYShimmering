//
//  ViewController.swift
//  Example
//
//  Created by yu zhou on 27/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit
import ZYShimmering

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

