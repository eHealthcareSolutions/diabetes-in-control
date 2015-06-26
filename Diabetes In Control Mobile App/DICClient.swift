//
//  DICClient.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/22/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICClient: NSObject {

    var session: NSURLSession
    var dicXMLParser : DICXMLParser
    var task : NSURLSessionTask?
    
    // closure to call when the articles are loaded
    var articlesLoadedCompletionHandler: ([DICArticle] -> ())?
    
    override init() {
        session = NSURLSession.sharedSession()
        dicXMLParser = DICXMLParser()
        
        super.init()
        dicXMLParser.delegate = self
    }
    
    func getArticleFeed(category : String = "", page : Int = 1, completionHandler : ([DICArticle] -> ())?) {
        // if we are already parsing, cancel it to start parsing new request
        task?.cancel()
        dicXMLParser.abortAndReset()
        
        articlesLoadedCompletionHandler = completionHandler
        
        // create url request from feed url (DICConstants.swift)
        var url : NSURL?
        if category == "" { //want main article feed
            url = NSURL(string: Constants.baseUrl + Constants.feed + Constants.paged + String(page))
        } else {
            var categoryUrl = "" // if we can't find the category url, just get main feed
            if let categoryIndex = find(Constants.categories,category) {
                categoryUrl = Constants.categoryUrls[categoryIndex]
            }
            url = NSURL(string: Constants.baseUrl + categoryUrl + Constants.feed + Constants.paged + String(page))
        }
        println("Page=\(page)")
        let request = NSURLRequest(URL: url!)
        
        task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println(error)
            }
            else {
                // begin parsing xml with DICXMLParser
                var xmlParser = NSXMLParser(data: data)
                xmlParser.delegate = self.dicXMLParser
                xmlParser.parse()
                if xmlParser.parserError?.code == 1 { //internal error, must retry
                    self.getArticleFeed(category: category, page: page, completionHandler: completionHandler)
                }
            }
        }
        
        task!.resume()
    }
    
    class func sharedInstance() -> DICClient {
        
        struct Singleton {
            static var sharedInstance = DICClient()
        }
        
        return Singleton.sharedInstance
    }
    
}

// MARK: DICXMLParserDelegate
extension DICClient: DICXMLParserDelegate {
    func articlesDidFinishLoading(articles : [DICArticle]) {
        if (articlesLoadedCompletionHandler != nil) {
            articlesLoadedCompletionHandler!(articles)
        }
    }
}
