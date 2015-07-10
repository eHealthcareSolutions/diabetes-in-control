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
    
    var title = "Title" {
        didSet {
            // set correct font
            let titleFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
            let titleFont = UIFont(name: DICConstants.fontName, size: titleFontSize)
            titleLabel.font = titleFont
            
            titleLabel.text = title
        }
    }
    
    var descr = "Descr" {
        didSet {
            // set correct font
            let descrFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).pointSize
            let descrFont = UIFont(name: DICConstants.fontName, size: descrFontSize)
            descrLabel.font = descrFont
            
            descrLabel.text = descr
        }
    }
    
    override func prepareForReuse() {
        self.backgroundColor = DICConstants.cellUnselectedColor
    }
}