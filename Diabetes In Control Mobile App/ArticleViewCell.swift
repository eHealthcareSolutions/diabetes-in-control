//
//  ArticleViewCell.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/17/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class ArticleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var readMoreLabel: UILabel!

    let cellSelectedTextColor = UIColor(red: 0, green: 0.56, blue: 0.84, alpha: 1.0)
    let cellUnselectedTextColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.0)
    let readMoreBorderColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.0)
    
    override func awakeFromNib() {
        // set border
        readMoreLabel.layer.borderWidth = 0.5
        readMoreLabel.layer.borderColor = readMoreBorderColor.CGColor
    }
    
    var title = "Title" { // update title label to given title
        didSet {
            // set correct font
            let titleFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
            let titleFont = UIFont(name: DICConstants.fontName, size: titleFontSize)
            titleLabel.font = titleFont
            
            titleLabel.text = title
        }
    }
    
    var descr = "Descr" { // update descr label to given descr
        didSet {
            // set correct font
            let descrFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).pointSize
            let descrFont = UIFont(name: DICConstants.fontName, size: descrFontSize)
            descrLabel.font = descrFont
            
            descrLabel.text = descr
        }
    }
    
    func setSelected() {
        readMoreLabel.textColor = cellSelectedTextColor
    }
    
    func setUnselected() {
        readMoreLabel.textColor = cellUnselectedTextColor
    }
    
    // reset cell to reusable state (deselect)
    override func prepareForReuse() {
        setUnselected()
    }
}