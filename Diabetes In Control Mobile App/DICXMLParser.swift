//
//  DICXMLParser.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICXMLParser: NSObject, NSXMLParserDelegate {

    var articles = [DICArticle]()
    
    // these will fill up as we read each article element
    var title = ""
    var link = ""
    var descr = ""
    
    var currentlyReading = CurrentlyReading.None
    
    //will call this delegate when we finish loading the articles
    var delegate : DICXMLParserDelegate
    
    init(delegate : DICXMLParserDelegate)
    {
        self.delegate = delegate
    }
    
    // updates currentlyReading to reflect what element we are currently reading
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        switch (elementName) {
        case "title":
            currentlyReading = .Title
            title = ""
        case "link":
            currentlyReading = .Link
            link = ""
        case "description":
            currentlyReading = .Descr
            descr = ""
        default:
            currentlyReading = .None
        }
    }
    
    // if we just got done reading the last element, create a new DICArticle and add to array
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentlyReading == .Descr {
            let article = DICArticle(title: title, link: link, descr: descr)
            articles.append(article)
            println("loaded \(article)")
        }
    }
    
    // adds characters to whichever element we are currently reading
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if let string = string {
            switch (currentlyReading) {
            case .Title:
                title += string
            case .Link:
                link += string
            case .Descr:
                descr += string
            default:
                break
            }
        }
    }
    
    // callback to the delegate with our articles
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate.articlesDidFinishLoading(articles)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        println(parseError)
    }
    
    // used to determine what element is currently being raad
    enum CurrentlyReading {
        case Title, Link, Descr, None
    }
    
}

protocol DICXMLParserDelegate {
    func articlesDidFinishLoading([DICArticle])
}
