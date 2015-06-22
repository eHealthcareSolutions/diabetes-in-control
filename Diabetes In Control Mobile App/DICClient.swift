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
    var dicXMLParser : DICXMLParser?
    
    // closure to call when the articles are loaded
    var articlesLoadedClosure : ([DICArticle] -> ())?
    
    override init() {
        session = NSURLSession.sharedSession()
        
        super.init()
    }
    
    func getArticleFeed(whenDone : ([DICArticle] -> ())?) {
        articlesLoadedClosure = whenDone
        
        // create url request from feed url (DICConstants.swift)
        let url = NSURL(string: Constants.url)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println(error)
            }
            else {
                // begin parsing xml with DICXMLParser
                self.dicXMLParser = DICXMLParser(delegate: self)
                
                var xmlParser = NSXMLParser(data: data)
                xmlParser.delegate = self.dicXMLParser
                xmlParser.parse()
            }
        }
        
        task.resume()
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
        if (articlesLoadedClosure != nil) {
            articlesLoadedClosure!(articles)
        }
    }
}
