//
//  DICFavoritesList.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/1/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//
// stores all articles that have been favorited

import Foundation

class DICFavoritesList : NSObject {
    
    var articles = [DICArticle]()
    
    override init() {
        super.init()
        
        let dataFilePath = getDataFilePath()
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(dataFilePath) {
            // if archive exists, get favorites, otherwise we have no favorites
            articles = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath) as! [DICArticle]
        }
    }
    
    func addFavorite(article : DICArticle) {
        articles += [article]
        saveData()
    }
    
    func removeFavorite(article : DICArticle) {
        if let index = find(articles, article) {
            articles.removeAtIndex(index)
            saveData()
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
    
    func saveData() {
        NSKeyedArchiver.archiveRootObject(articles, toFile: getDataFilePath())
    }
    
    func getDataFilePath() -> String {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        var dataFilePath = docsDir.stringByAppendingPathComponent(DICConstants.URLConvenience.favoritesURL)
        return dataFilePath
    }
    
    class func sharedInstance() -> DICFavoritesList {
        
        struct Singleton {
            static var sharedInstance = DICFavoritesList()
        }
        
        return Singleton.sharedInstance
    }
    
}
    