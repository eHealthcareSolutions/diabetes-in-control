//
//  TopicButtonFactory.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/13/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class ScrollViewFactory {
    
    let scrollView: UIScrollView
    var lastButton: UIButton? = nil
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func addBtnNamed(name: String) {
        let newButton = UIButton()
        newButton.setTitleColor(DICConstants.unselectedTopicFontColor, forState: .Normal)
        newButton.setTitle(name, forState: .Normal)
        
        scrollView.addSubview(newButton)
        
        let horizConstr: NSLayoutConstraint
        if lastButton == nil { // attach to left of scrollView
            horizConstr = NSLayoutConstraint(item: newButton, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: 0)
        } else { // attach to previous button
            horizConstr = NSLayoutConstraint(item: newButton, attribute: .Leading, relatedBy: .Equal, toItem: lastButton, attribute: .Trailing, multiplier: 1, constant: 0)
        }
        let vertConstr = NSLayoutConstraint(item: newButton, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        scrollView.addConstraint(horizConstr)
        scrollView.addConstraint(vertConstr)
        
        lastButton = newButton
    }
    
    // attach last button to end of scrollview
    func finish() {
        let horizConstr = NSLayoutConstraint(item: lastButton!, attribute: .Trailing, relatedBy: .Equal, toItem: scrollView, attribute: .Trailing, multiplier: 1, constant: 0)
        scrollView.addConstraint(horizConstr)
    }
    
}
