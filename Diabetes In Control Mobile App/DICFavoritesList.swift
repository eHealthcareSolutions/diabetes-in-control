//
//  DICFavoritesList.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/1/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//
// stores all articles that have been favorited

import Foundation

class DICFavoritesList {
    
    var articles : [DICArticle]
    let archiver : DICArchiver
    
    init() {
        archiver = DICArchiver(archiveName: DICConstants.URLConvenience.favoritesURL)
        
        let unarchived = archiver.unarchive() as? [DICArticle]
        // set articles to unarchived if not nil, otherwise create new array
        articles = unarchived == nil ? [DICArticle]() : unarchived!
    }
    
    // adds fav to list, saves data
    func addFavorite(article : DICArticle) {
        if !findFavoriteWithTitle(article.title) { // only add favorite if it's not already one
            articles += [article]
            archiver.archive(articles)
        }
    }
    
    // removes fav from list, saves data
    func removeFavorite(article : DICArticle) {
        if let index = find(articles, article) {
            articles.removeAtIndex(index)
            archiver.archive(articles)
        }
    }
    
    // returns true if article is a favorite, false otherwise
    func findFavoriteWithTitle(title : String) -> Bool {
        for i in 0..<articles.count {
            if articles[i].title == title {
                return true
            }
        }
        return false
    }
    
    // singleton
    class func sharedInstance() -> DICFavoritesList {
        struct Singleton {
            static var sharedInstance = DICFavoritesList()
        }
        
        return Singleton.sharedInstance
    }
    
}
    