//
//  DICConstants.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

extension DICClient {
    
    struct Constants {
        static let baseUrl = "http://ec2-184-73-33-13.compute-1.amazonaws.com/html/diabetesincontrol-dev.com/category/articles"
        static let feed = "/feed/"
        static let paged = "?paged="
        
        // these must be parallel arrays and not dictionaries because dictionaries aren't ordered
        static let categories = ["Case Study", "Clinical Gems", "Did You Know", "Disasters Averted", "Exclusive Interviews", "Facts", "Feature", "Homerun Slides", "How It Works", "Items for the Week", "Newsflash", "Press Releases", "Product of the Week", "Studies", "Videos"]
        static let categoryUrls = ["/case-study", "/clinical-gems","/did-you-know", "/practicum", "/exclusive", "/facts", "/feature", "/homerun-slides", "/how-glp-1-works", "/diabetes-news", "/newsflash", "/press-releases", "/product-of-the-week", "/this-weeks-study", "/videos"]
        
        static let articlesPerPage = 5
    }
    
}
