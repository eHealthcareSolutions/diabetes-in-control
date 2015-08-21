//
//  DICArticle.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation
import UIKit

class DICArticle: NSObject, NSCoding {

    // article data
    var title : String
    var link : String
    var category : String
    var descr : String
    var descrWithoutHTML : String
    var content : String
    var image : UIImage?
    
    init(title : String, link : String, category : String,descr : String, content : String) {
        self.title = title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        self.link = link
        self.category = category
        self.descr = descr
        
        // remove html tags and encodings, trim whitespace
        let encodedString = descr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        let encodedData = encodedString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding]
        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions as [NSObject : AnyObject], documentAttributes: nil, error: nil)
        self.descrWithoutHTML = attributedString!.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        self.content = content
        super.init()
        
        getImage()
    }
    
    // init from the cache
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as! String
        link = aDecoder.decodeObjectForKey("link") as! String
        category = aDecoder.decodeObjectForKey("category") as! String
        descr = aDecoder.decodeObjectForKey("descr") as! String
        descrWithoutHTML = aDecoder.decodeObjectForKey("descrWithoutHTML") as! String
        content = aDecoder.decodeObjectForKey("content") as! String
        image = aDecoder.decodeObjectForKey("image") as? UIImage
    }
    
    // store in the cache
    func encodeWithCoder(aCoder : NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(category, forKey: "category")
        aCoder.encodeObject(descr, forKey: "descr")
        aCoder.encodeObject(descrWithoutHTML, forKey: "descrWithoutHTML")
        aCoder.encodeObject(content, forKey: "content")
        aCoder.encodeObject(image, forKey: "image")
    }
    
    func getImage() {
        let attrStr = NSAttributedString(data: descr.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil, error: nil)!
        // check if it contains an image attachment, if so get the image
        //if let attachment = attrStr.attribute("NSAttachment", atIndex: 0, effectiveRange: nil) as? NSTextAttachment {
        //    self.image = UIImage(data: attachment.fileWrapper!.regularFileContents!)
        //}
    }
    
    // toString function, don't confuse this with descr, the article description
    override var description : String {
        return "title : \(title) link : \(link) category : \(category) descr : \(descrWithoutHTML) content : \(content)\n"
    }
    
}
