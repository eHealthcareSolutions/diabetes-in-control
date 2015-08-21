//
//  HeaderView.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/16/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class HeaderView : UIView {
    
    @IBOutlet weak var yConstraint : NSLayoutConstraint!
    @IBOutlet weak var logoSpaceView : UIView!
    @IBOutlet weak var logoView : UIView!
    @IBOutlet weak var logoTextView : UIView!
    
    var yVal : CGFloat = 0 {
        didSet {
            yVal = min(yVal, 0) // never move header down
            let minY = -logoSpaceView.frame.height + DICConstants.Buttons.height + 2 * DICConstants.Buttons.margin
            yConstraint.constant = max(yVal, minY)
            
            // set opacity of logo
            let alpha = min(1.0, 1.0 - yConstraint.constant/minY)
            logoView.alpha = alpha
            logoTextView.alpha = alpha
        }
    }
    
    func didScroll(offset : CGFloat) {
        yVal = -offset
    }
    
    func update() {
        let y = yVal
        yVal = y
    }
}