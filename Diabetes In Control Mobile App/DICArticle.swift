//
//  DICArticle.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICArticle: NSObject, NSCoding {

    // article data
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
        // remove html tags and encodings, trim whitespace
        self.descrWithoutHTML = descr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                                     .stringByReplacingOccurrencesOfString("&#160;", withString: " ", options: .RegularExpressionSearch, range: nil)
                                     .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.content = content
    }
    
    // init from the cache
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as! String
        link = aDecoder.decodeObjectForKey("link") as! String
        category = aDecoder.decodeObjectForKey("category") as! String
        descr = aDecoder.decodeObjectForKey("descr") as! String
        descrWithoutHTML = aDecoder.decodeObjectForKey("descrWithoutHTML") as! String
        content = aDecoder.decodeObjectForKey("content") as! String
    }
    
    // store in the cache
    func encodeWithCoder(aCoder : NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(category, forKey: "category")
        aCoder.encodeObject(descr, forKey: "descr")
        aCoder.encodeObject(descrWithoutHTML, forKey: "descrWithoutHTML")
        aCoder.encodeObject(content, forKey: "content")
    }
    
    // toString function, don't confuse this with descr, the article description
    override var description : String {
        return "title : \(title) link : \(link) category : \(category) descr : \(descrWithoutHTML) content : \(content)\n"
    }
    
}
