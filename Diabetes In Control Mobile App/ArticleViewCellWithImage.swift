//
//  ArticleViewCellWithImage.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/14/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class ArticleViewCellWithImage: ArticleViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage! { // update imageview to given image
        didSet {
            imageView.image = image
        }
    }
    
}
