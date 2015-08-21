//
//  DICArchiver.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 7/16/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import Foundation

class DICArchiver {
    
    let dataFilePath : String
    let fileManager : NSFileManager
    
    init(archiveName : String) {
        // get filepath
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        dataFilePath = docsDir.stringByAppendingPathComponent(archiveName)
        
        // set filemanager
        fileManager = NSFileManager()
    }
    
    func archive(obj : AnyObject) {
        NSKeyedArchiver.archiveRootObject(obj, toFile: dataFilePath)
    }

    // returns object unless it doesn't exist, then it returns nil
    func unarchive() -> AnyObject? {
        if fileManager.fileExistsAtPath(dataFilePath) {
            // if archive exists, get object
            let obj: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath)
            return obj
        }
        // otherwise there is no archive
        return nil
    }
    
}