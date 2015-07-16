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
    
    // given an article category, a page number, and a completion handler, creates an array of articles from 
    // the rss feed for given category/page number. then calls completionHandler with articles as argument
    func getArticleFeed(category : String = "", page : Int = 1, completionHandler : ([DICArticle] -> ())?) {
        // create url request from feed url (DICConstants.swift)
        var url : NSURL?
        let UC = DICConstants.URLConvenience.self
        if category == "" { //want main article feed
            url = NSURL(string: UC.baseUrl + UC.feed + UC.paged + String(page))
        } else {
            var categoryUrl = "" // if we can't find the category url, just get main feed
            if let categoryIndex = find(UC.categories,category) {
                categoryUrl = UC.categoryUrls[categoryIndex]
            }
            url = NSURL(string: UC.baseUrl + categoryUrl + UC.feed + UC.paged + String(page))
        }
        let request = NSURLRequest(URL: url!)
        
        getArticlesFromURLRequest(request, completionHandler: completionHandler)
    }
    
    // given a urlrequest for an xml feed of articles, creates articles array from feed and calls 
    // completionHandler with articles as argument
    func getArticlesFromURLRequest(urlRequest : NSURLRequest, completionHandler : ([DICArticle] -> ())?) {
        // if we are already parsing, cancel it to start parsing new request
        task?.cancel()
        dicXMLParser.abortAndReset()
        
        articlesLoadedCompletionHandler = completionHandler
        
        task = session.dataTaskWithRequest(urlRequest) {data, response, downloadError in
            if let error = downloadError {
                println(error)
            }
            else {
                // begin parsing xml with DICXMLParser
                var xmlParser = NSXMLParser(data: data)
                xmlParser.delegate = self.dicXMLParser
                xmlParser.parse()
                if xmlParser.parserError?.code == 1 { //internal error, must retry
                    self.getArticlesFromURLRequest(urlRequest, completionHandler: completionHandler)
                }
            }
        }
        
        task!.resume()
    }
    
    // singleton
    class func sharedInstance() -> DICClient {
        struct Singleton {
            static var sharedInstance = DICClient()
        }
        
        return Singleton.sharedInstance
    }
    
}

// MARK: DICXMLParserDelegate
extension DICClient: DICXMLParserDelegate {
    
    // when xml parsing is done, call the given completion handler
    func articlesDidFinishLoading(articles : [DICArticle]) {
        if (articlesLoadedCompletionHandler != nil) {
            articlesLoadedCompletionHandler!(articles)
        }
    }
    
}
