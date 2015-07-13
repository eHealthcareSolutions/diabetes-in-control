//
//  DICXMLParser.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICXMLParser: NSObject, NSXMLParserDelegate {

    var parser : NSXMLParser?
    
    // add articles to this array as they are parsed
    var articles = [DICArticle]()
    
    // these will fill up as we read each article element
    var title = ""
    var link = ""
    var category = ""
    var descr = ""
    var content = ""
    
    // used to determine what element is currently being raad
    enum CurrentlyReading {
        case Title, Link, Category, Descr, Content, None
    }
    
    // stores the element we are currently reading
    var currentlyReading = CurrentlyReading.None
    
    //will call this delegate when we finish loading the articles
    var delegate : DICXMLParserDelegate?
    
    // updates currentlyReading to reflect what element we are currently reading
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        switch (elementName) {
        case "title":
            currentlyReading = .Title
            title = ""
        case "link":
            currentlyReading = .Link
            link = ""
        case "category":
            currentlyReading = .Category
            category = ""
        case "description":
            currentlyReading = .Descr
            descr = ""
        case "content:encoded":
            currentlyReading = .Content
            content = ""
        default:
            currentlyReading = .None
        }
    }
    
    // if we just got done reading the last element, create a new DICArticle and add to array
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentlyReading == .Content {
            let article = DICArticle(title: title, link: link, category: category, descr: descr, content: content)
            articles.append(article)
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
            case .Category:
                category += string
            case .Descr:
                descr += string
            case .Content:
                content += string
            default:
                break
            }
        }
    }
    
    // callback to the delegate with our articles
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.articlesDidFinishLoading(articles)
        abortAndReset()
    }
    
    // error handler
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        //println(parseError)
        println("Error parsing XML")
    }
    
    // stop parsing and return to original, ready-to-parse state
    func abortAndReset() {
        parser?.abortParsing()
        
        articles = [DICArticle]()
        title = ""
        link = ""
        category = ""
        descr = ""
        content = ""
        
        currentlyReading = .None
    }
    
}

// objects that use DICXMLParser must implement this protocol and provide a completion handler
protocol DICXMLParserDelegate {
    func articlesDidFinishLoading([DICArticle])
}
