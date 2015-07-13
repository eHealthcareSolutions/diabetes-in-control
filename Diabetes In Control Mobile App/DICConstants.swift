//
//  DICConstants.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation
import UIKit

struct DICConstants {
        
    static let articlesPerPage = 5
    static let fontName = "OpenSans"
    
    static let selectedTopicFontColor = UIColor(red: 1.0, green: 1.0, blue: 0.66, alpha: 1.0)
    static let unselectedTopicFontColor = UIColor.whiteColor()
    
    struct URLConvenience {
        static let baseUrl = "http://ec2-184-73-33-13.compute-1.amazonaws.com/html/diabetesincontrol-dev.com/category/articles"
        static let articlesUrl = "http://ec2-184-73-33-13.compute-1.amazonaws.com/html/diabetesincontrol-dev.com/articles"
        static let favoritesURL = "favorites.archive"
        static let feed = "/feed/"
        static let feedSingleArticle = "feed/?withoutcomments=1"
        static let paged = "?paged="
        
        // these must be parallel arrays and not dictionaries because dictionaries aren't ordered
        static let categories = ["Case Study", "Clinical Gems", "Did You Know", "Disasters Averted", "Exclusive Interviews", "Facts", "Feature", "Homerun Slides", "How It Works", "Items for the Week", "Newsflash", "Press Releases", "Product of the Week", "Studies", "Videos"]
        static let categoryUrls = ["/case-study", "/clinical-gems","/did-you-know", "/practicum", "/exclusive", "/facts", "/feature", "/homerun-slides", "/how-glp-1-works", "/diabetes-news", "/newsflash", "/press-releases", "/product-of-the-week", "/this-weeks-study", "/videos"]
    }
    
    // shadow constants
    struct CellShadow {
        static let offset = CGSize(width: 0, height: 2)
        static let opacity = Float(1.0)
        static let radius = CGFloat(2.0)
        static let masksToBounds = false
    }
    
}

