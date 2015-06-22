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
            titleLabel.text = title
        }
    }
    
    var descr = "Descr" {
        didSet {
            let descrWithoutHTML = descr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
            descrLabel.text = descrWithoutHTML
        }
    }
    
}