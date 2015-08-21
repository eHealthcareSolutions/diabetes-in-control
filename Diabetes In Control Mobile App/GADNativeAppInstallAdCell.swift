//
//  GADNativeAppInstallAdVIew.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 8/6/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GADNativeAppInstallAdCell: UIView {

    var adView : GADNativeAppInstallAdView!
    
    var ad : GADNativeCustomTemplateAd! {
        didSet {
            adView.ad = ad
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        adView = NSBundle.mainBundle().loadNibNamed("GADNativeAppInstallAdView", owner: self, options: nil)[0] as! GADNativeAppInstallAdView
        addSubview(adView)
        
        let topConstraint = NSLayoutConstraint(item: adView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: adView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: adView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: adView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0)
        
        adView.setTranslatesAutoresizingMaskIntoConstraints(false)
        adView.superview!.addConstraints([topConstraint, bottomConstraint, trailingConstraint, leadingConstraint])
    }

}
