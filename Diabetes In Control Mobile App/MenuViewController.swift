//
//  MenuViewController.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/21/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var tabImageView: UIImageView!
    
    let cells = [["backToArticles", "manageFavorites", "myAccount"], ["settings"]]
    var initialPanX : CGFloat = 0
    var menuGoingLeft = true
    
    var delegate : MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set correct frame, animate from left
        view.frame = CGRectMake(-DICConstants.MenuVC.widthProportion * parentViewController!.view.frame.size.width, 0, DICConstants.MenuVC.widthProportion * parentViewController!.view.frame.size.width, parentViewController!.view.frame.size.height)
        UIView.animateWithDuration(DICConstants.MenuVC.animTime) {
            self.view.frame.origin = CGPointMake(0, 0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // add gesture recognizer to the tab view
        tabView.userInteractionEnabled = true
        let gestRec = UIPanGestureRecognizer(target: self, action: "tabViewPanned:")
        tabView.addGestureRecognizer(gestRec)
    }
    
    func tabViewPanned(sender: UIPanGestureRecognizer) {
        // if disappearing, set alpha back to 1
        view.alpha = 1.0
        
        if sender.state == UIGestureRecognizerState.Began {
            initialPanX = sender.translationInView(tabView).x
        } else if sender.state == UIGestureRecognizerState.Changed {
            var xTranslation = sender.translationInView(tabView).x - initialPanX
            if !menuGoingLeft {
                xTranslation -= view.frame.size.width
            }
            xTranslation = min(xTranslation, 0)
            animateToX(xTranslation)
        } else if sender.state == UIGestureRecognizerState.Ended {
            if menuGoingLeft {
                if view.frame.origin.x < -DICConstants.MenuVC.swipeThreshold * view.frame.size.width { // put back
                    hide()
                } else { // keep displaying
                    show()
                }
            } else {
                if view.frame.origin.x < -(1-DICConstants.MenuVC.swipeThreshold) * view.frame.size.width { // display
                    hide()
                } else { // put back
                    show()
                }
            }
        }
    }
    
    func animateToX(x : CGFloat) {
        UIView.animateWithDuration(0.1) {
            self.view.frame.origin = CGPointMake(x, 0)
        }
    }
    
    func hide() {
        animateToX(-view.frame.size.width + tabView.frame.width)
        delegate?.hideMe(self)
        menuGoingLeft = false
        tabImageView.image = UIImage(named: "Menu Tab Right")
        
        UIView.animateWithDuration(DICConstants.MenuVC.hideTime, delay: DICConstants.MenuVC.hideDelay, options: UIViewAnimationOptions.AllowUserInteraction, animations: {self.view.alpha = 0.1}, completion: {_ in if self.view.alpha < 1 {self.delegate?.destroyMe(self)}})
    }
    
    func show() {
        animateToX(0)
        menuGoingLeft = true
        delegate?.showMe(self)
        tabImageView.image = UIImage(named: "Menu Tab Left")
    }
    
}

// MARK: UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        switch cell.reuseIdentifier! {
        case "backToArticles":
            hide()
        case "manageFavorites":
            hide()
            delegate?.showFavorites()
        case "myAccount":
            break
        case "settings":
            break
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK: UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cells[indexPath.section][indexPath.row]) as! UITableViewCell
        
        // add separator if it's the last menu item before settings
        if indexPath.section == 1 {
            let separator = UIImageView(image: UIImage(named: "Separator"))
            cell.addSubview(separator)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
}

protocol MenuViewControllerDelegate {
    func hideMe(sender: MenuViewController)
    func showMe(sender: MenuViewController)
    func destroyMe(sender: MenuViewController)
    func showFavorites()
}