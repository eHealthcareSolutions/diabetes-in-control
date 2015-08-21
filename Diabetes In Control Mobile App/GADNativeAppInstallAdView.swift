//
//  GADNativeAppInstallAdView.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 8/6/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GADNativeAppInstallAdView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!

    var ad : GADNativeCustomTemplateAd! {
        didSet {
            let keys = DICConstants.AppInstallAd.self
            
            iconImageView.image = ad.imageForKey(keys.imageKey).image
            titleLabel.text = ad.stringForKey(keys.titleKey)
            bodyLabel.text = ad.stringForKey(keys.bodyKey)
            ctaButton.setTitle(ad.stringForKey(keys.ctaKey), forState: .Normal)
        }
    }
    
    override func awakeFromNib() {
        ctaButton.layer.borderColor = DICConstants.AppInstallAd.ctaBorderColor.CGColor
        ctaButton.layer.borderWidth = DICConstants.AppInstallAd.ctaBorderWidth
    }
    
}
