//
//  DICArticleCache.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/20/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICArticleCache {
    
    let archiver = DICArchiver(archiveName: DICConstants.URLConvenience.cacheURL)
    var cache : [[[DICArticle]]]
    // first dimension is parallel to DICConstants.categories
    // second dimension, index is page number
    // third dimension is an array of DICArticle, size DICConstants.articlesPerPage
    
    init() {
        if let unarchived = archiver.unarchive() as? [[[DICArticle]]] { // successfully unarchived
            cache = unarchived
        } else { // make new cache 
            cache = [[[DICArticle]]](count: DICConstants.URLConvenience.categories.count, repeatedValue: [[DICArticle]](count: DICConstants.pagesInCache, repeatedValue: [DICArticle]()))
        }
    }
    
    func cacheArticles(articles : [DICArticle], category : String, page : Int) {
        let index = find(DICConstants.URLConvenience.categories, category)!
        if page < DICConstants.pagesInCache {
            cache[index][page] = articles
            // clear next pages in cache since those must have changed
            for (var i = page+1; i < DICConstants.pagesInCache; i++) {
                cache[index][i] = [DICArticle]()
            }
            archiver.archive(cache)
        }
    }
    
    func getCache(category : String, page : Int) -> [DICArticle] {
        let index = find(DICConstants.URLConvenience.categories, category)!
        return cache[index][page]
    }
    
    // singleton
    class func sharedInstance() -> DICArticleCache {
        struct Singleton {
            static var sharedInstance = DICArticleCache()
        }
        
        return Singleton.sharedInstance
    }
    
}