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
    var descr : String
    
    init(title : String, link : String, descr : String) {
        self.title = title
        self.link = link
        self.descr = descr
        super.init()
    }
    
    // toString function, don't confuse this with descr, the article description
    override var description : String {
        return "title : \(title) link : \(link) descr : \(descr)\n"
    }
    
}
