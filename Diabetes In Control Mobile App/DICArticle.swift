//
//  DICArticle.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICArticle: NSObject {

    var title : String
    var link : String
    var category : String
    var descr : String
    var descrWithoutHTML : String
    var content : String
    
    init(title : String, link : String, category : String,descr : String, content : String) {
        self.title = title
        self.link = link
        self.category = category
        self.descr = descr
        self.descrWithoutHTML = descr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                                     .stringByReplacingOccurrencesOfString("&#160;", withString: " ", options: .RegularExpressionSearch, range: nil)
                                     .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.content = content
    }
    
    // toString function, don't confuse this with descr, the article description
    override var description : String {
        return "title : \(title) link : \(link) category : \(category) descr : \(descrWithoutHTML) content : \(content)\n"
    }
    
}
