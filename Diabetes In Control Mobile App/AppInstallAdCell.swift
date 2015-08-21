//
//  AppInstallAdCell.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 8/6/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AppInstallAdCell: UICollectionViewCell {
    
    @IBOutlet weak var installAdCell0: GADNativeAppInstallAdCell!
    @IBOutlet weak var installAdCell1: GADNativeAppInstallAdCell!
    @IBOutlet weak var installAdCell2: GADNativeAppInstallAdCell!
    @IBOutlet weak var installAdCell3: GADNativeAppInstallAdCell!
    
    var installAdCells : [GADNativeAppInstallAdCell] = []
    
    var delegate : AppInstallAdCellDelegate?
    
    var ads : [GADNativeCustomTemplateAd]! {
        didSet {
            for (var i = 0; i < ads.count; i++) {
                installAdCells[i].ad = ads[i]
            }
        }
    }
    
    override func awakeFromNib() {
        installAdCells = [installAdCell0, installAdCell1, installAdCell2, installAdCell3]
        
        // add touch recognizer
        var touch = UITapGestureRecognizer(target: self, action:"handleTap:")
        self.addGestureRecognizer(touch)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        /* find which cell was tapped
           0  |  1
           2  |  3
        */
        let touchLocation = recognizer.locationInView(self)
        var index = 0
        if touchLocation.x >= bounds.width/2 {
            index += 1
        }
        if touchLocation.y >= bounds.height/2 {
            index += 2
        }
        
        delegate?.appInstallAdCellTapped(ads[index])
    }
    
}

protocol AppInstallAdCellDelegate {
    
    func appInstallAdCellTapped(forAd : GADNativeCustomTemplateAd)
    
}