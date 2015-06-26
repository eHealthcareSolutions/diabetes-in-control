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
    
    var articles = [DICArticle]()
    
    // these will fill up as we read each article element
    var title = ""
    var link = ""
    var category = ""
    var descr = ""
    var content = ""
    
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
        parser.abortParsing()
        delegate?.articlesDidFinishLoading(articles)
        abortAndReset()
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        //println(parseError)
        println("Error parsing XML")
    }
    
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
    
    // used to determine what element is currently being raad
    enum CurrentlyReading {
        case Title, Link, Category, Descr, Content, None
    }
    
}

protocol DICXMLParserDelegate {
    func articlesDidFinishLoading([DICArticle])
}
