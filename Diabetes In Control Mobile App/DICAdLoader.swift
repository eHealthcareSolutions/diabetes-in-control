//
//  DICAdReceiver.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 8/6/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class DICAdLoader : NSObject, GADNativeCustomTemplateAdLoaderDelegate {
    
    var adLoader : GADAdLoader?
    var installAds = [GADNativeCustomTemplateAd]()
    
    var delegate : DICAdLoaderDelegate
    
    init(delegate : DICAdLoaderDelegate, rootViewController : UIViewController) {
        self.delegate = delegate
        super.init()
        
        // initialize ad loader
        adLoader = GADAdLoader(adUnitID: DICConstants.DFP_AD_UNIT_ID, rootViewController: rootViewController, adTypes: [kGADAdLoaderAdTypeNativeCustomTemplate], options: nil)
        adLoader!.delegate = self
        
        requestNewAppInstallAd()
    }
    
    func requestNewAppInstallAd() {
        let dfpRequest = DFPRequest()
        dfpRequest.testDevices = ["9244bad7e136df0ba11c188b406b09fa"]
        adLoader!.loadRequest(dfpRequest)
    }
    
    func nativeCustomTemplateIDsForAdLoader(adLoader: GADAdLoader!) -> [AnyObject]! {
        return DICConstants.AppInstallAd.templateIDs
    }
    
    @objc func adLoader(adLoader: GADAdLoader!, didFailToReceiveAdWithError error: GADRequestError!) {
        println(error)
    }
    
    func adLoader(adLoader: GADAdLoader!, didReceiveNativeCustomTemplateAd nativeCustomTemplateAd: GADNativeCustomTemplateAd!) {
        println("received ad")
        installAds.append(nativeCustomTemplateAd)
        if installAds.count < 4 { // get more
            requestNewAppInstallAd()
        } else { // pass to delegate
            delegate.didReceiveInstallAds(installAds)
        }
    }
    
}

protocol DICAdLoaderDelegate {
    
    func didReceiveInstallAds(installAds : [GADNativeCustomTemplateAd])
    
}