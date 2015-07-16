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
    
    // creates button with given name, adds to scrollview, adds constraints, returns button
    func addButtonNamed(name: String) -> UIButton {
        let newButton = UIButton()
        newButton.setTitleColor(DICConstants.ScrollView.unselectedColor, forState: .Normal)
        newButton.setTitle(name, forState: .Normal)
        newButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        scrollView.addSubview(newButton)
        
        let horizConstr: NSLayoutConstraint
        if lastButton == nil { // attach to left of scrollView
            horizConstr = NSLayoutConstraint(item: newButton, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: DICConstants.ScrollView.horizMargin)
        } else { // attach to previous button
            horizConstr = NSLayoutConstraint(item: newButton, attribute: .Leading, relatedBy: .Equal, toItem: lastButton, attribute: .Trailing, multiplier: 1, constant: DICConstants.ScrollView.horizMargin)
        }
        let vertConstr = NSLayoutConstraint(item: newButton, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 0.95, constant: 0)
        
        scrollView.addConstraint(horizConstr)
        scrollView.addConstraint(vertConstr)
        
        lastButton = newButton
        return newButton
    }
    
    // attach last button to end of scrollview
    func finish() {
        let horizConstr = NSLayoutConstraint(item: lastButton!, attribute: .Trailing, relatedBy: .Equal, toItem: scrollView, attribute: .Trailing, multiplier: 1, constant: -DICConstants.ScrollView.horizMargin)
        scrollView.addConstraint(horizConstr)
    }
    
}
