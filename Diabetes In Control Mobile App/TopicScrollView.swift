//
//  TopicScrollView.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/23/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class TopicScrollView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    var topicButtons = [UIButton]()
    var currentlySelectedBtn: UIButton!
    
    var topicDelegate : TopicScrollViewDelegate?
    
    func setButtons(named: [String]) {
        // add buttons to scrollview
        let scrollViewFactory = ScrollViewFactory(scrollView: scrollView)
        
        for i in 0..<named.count {
            let button = scrollViewFactory.addButtonNamed(named[i])
            topicButtons.append(button)
            
            // add listener
            button.addTarget(self, action: "topicTouchUpInside:", forControlEvents: .TouchUpInside)
        }
        scrollViewFactory.finish()

        // set currently selected button to home button
        currentlySelectedBtn = topicButtons[1]
        selectButton(currentlySelectedBtn)
    }
    
    func topicTouchUpInside(sender: UIButton) {
        topicDelegate?.buttonPressed(sender.titleForState(.Normal)!)
        
        // disable/enable arrow buttons
        leftArrowButton.alpha = 1
        rightArrowButton.alpha = 1
        let index = find(topicButtons, sender)!
        if index == 0 {
            leftArrowButton.alpha = 0
        } else if index == topicButtons.count - 1 {
            rightArrowButton.alpha = 0
        }
        
        selectButton(sender)
    }
    
    func selectButton(btn: UIButton) {
        // scroll so selected button is in center
        let margin = (scrollView.frame.width - btn.frame.width) / 2
        // don't care about height
        let visibleRect = CGRect(x: btn.frame.origin.x - margin, y: 1, width: scrollView.frame.width, height: 1)
        scrollView.scrollRectToVisible(visibleRect, animated: true)
        
        // unhighlight previous button
        currentlySelectedBtn.setTitleColor(DICConstants.ScrollView.unselectedColor, forState: .Normal)
        
        // highlight selected category
        btn.setTitleColor(DICConstants.ScrollView.selectedColor, forState: .Normal)
        
        currentlySelectedBtn = btn
    }
    
    func update() {
        // update buttons with correct font size
        let btnFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
        let btnFont = UIFont(name: DICConstants.fontName, size: btnFontSize)
        for i in 0..<topicButtons.count {
            topicButtons[i].titleLabel!.font = btnFont
        }
        selectButton(currentlySelectedBtn)
        applyGradientToScrollView()
    }
    
    func tapFavorites() {
        topicTouchUpInside(topicButtons[0])
    }
    
    func tapCurrentButton() {
        topicTouchUpInside(currentlySelectedBtn)
    }
    
    // simulate touching button to the left of the currently selected button
    @IBAction func leftArrowTouchUpInside(sender: UIButton) {
        let index = find(topicButtons, currentlySelectedBtn)
        if index! > 0 { // can safely move left
            topicTouchUpInside(topicButtons[index!-1])
        }
    }
    
    // simulate touching button to the right of the currently selected button
    @IBAction func rightArrowTouchUpInside(sender: UIButton) {
        let index = find(topicButtons, currentlySelectedBtn)
        if index! < topicButtons.count-1 { // can safely move left
            topicTouchUpInside(topicButtons[index!+1])
        }
    }
    
    func applyGradientToScrollView() {
        let gradientLayer = CAGradientLayer(layer: scrollViewContainer.layer)
        gradientLayer.frame = scrollViewContainer.bounds
        gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor, UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
        gradientLayer.locations = [0.0, 0.1, 0.9, 1.0]
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        scrollViewContainer.layer.mask = gradientLayer
    }

}

protocol TopicScrollViewDelegate {
    
    func buttonPressed(named : String)
    
}
