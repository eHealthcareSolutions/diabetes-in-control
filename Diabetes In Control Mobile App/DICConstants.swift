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
    static let pagesInCache = 5
    static let fontName = "OpenSans"
    static let DFP_AD_UNIT_ID = "/6913/ehs.pro.hiper.dicapp"
    
    struct Flurry {
        static let API_KEY = "2MR79YG32X2GPSYHNHHR"
        static let ARTICLE_READ_EVENT = "Article_Read"
        static let CATEGORY_VIEWED_EVENT = "Category_Viewed"
    }
    
    struct AppInstallAd {
        static let templateIDs = ["10086656"]
        
        static let imageKey = "Image"
        static let titleKey = "Title"
        static let bodyKey = "Subtitle"
        static let ctaKey = "CTALabel"
        
        static let ctaBorderColor = UIColor(red: 0.0, green: 0.29, blue: 0.50, alpha: 1.0)
        static let ctaBorderWidth: CGFloat = 1.0
    }
    
    struct Buttons {
        static let margin: CGFloat = 8
        static let height: CGFloat = 30
    }
    
    struct ScrollView {
        static let selectedColor = UIColor(red: 1.0, green: 1.0, blue: 0.66, alpha: 1.0)
        static let unselectedColor = UIColor.whiteColor()
        static let horizMargin: CGFloat = 50
    }
    
    struct ColNumThresholds {
        static let two : CGFloat = 567 // iphone 5 width
        static let three : CGFloat = 1023 // ipad 3 width
    }
    
    struct Tile {
        static let horizMargin : CGFloat = 20
        static let vertMargin : CGFloat = 20
        
        static let heightPercentagePortrait : CGFloat = 0.3
        static let heightPercentageLandscape : CGFloat = 0.5
    }
    
    struct MenuVC {
        static let widthProportion : CGFloat = 2/3
        static let animTime : NSTimeInterval = 0.25
        
        static let overlayColor = UIColor(white: 0.0, alpha: 0.5)
        
        static let swipeThreshold : CGFloat = 1/3
        
        static let hideDelay : NSTimeInterval = 2.0
        static let hideTime : NSTimeInterval = 1.0
    }
    
    struct URLConvenience {
        static let baseUrl = "http://ec2-184-73-33-13.compute-1.amazonaws.com/html/diabetesincontrol-dev.com/articles"
        static let articlesUrl = "http://ec2-184-73-33-13.compute-1.amazonaws.com/html/diabetesincontrol-dev.com/articles"
        static let feed = "/feed/"
        static let feedSingleArticle = "feed/?withoutcomments=1"
        static let paged = "?paged="
        
        static let favoritesURL = "favorites.archive"
        static let cacheURL = "cache.archive"
        
        // these must be parallel arrays and not dictionaries because dictionaries aren't ordered
        static let categories = ["Favorites", "Home", "Case Study", "Clinical Gems", "Did You Know", "Disasters Averted", "Exclusive Interviews", "Facts", "Feature", "Homerun Slides", "How It Works", "Items for the Week", "Newsflash", "Press Releases", "Product of the Week", "Studies", "Videos"]
        static let categoryUrls = ["", "", "/case-study", "/clinical-gems","/did-you-know", "/practicum", "/exclusive", "/facts", "/feature", "/homerun-slides", "/how-glp-1-works", "/diabetes-news", "/newsflash", "/press-releases", "/product-of-the-week", "/this-weeks-study", "/videos"]
    }
    
    // shadow constants
    struct CellShadow {
        static let offset = CGSize(width: 0, height: 2)
        static let opacity = Float(0.3)
        static let radius = CGFloat(1.5)
        static let masksToBounds = false
    }
    
}

