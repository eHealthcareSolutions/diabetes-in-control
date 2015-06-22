//
//  ViewController.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/16/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topicScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Database stub lol
    var articles = [DICArticle]()
    
    var headlines = ["Man accidentally served detergent instead of water, dies","Russia declares war on the US","Parents abort child because \"its nose was too big, man! just look at that thing!\""]
    var text = ["This restaurant needs to clean up its act","Also declares war on rest of world. Putin is Russian to world domination","Will we see a downtrend in Jewish births?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DICClient.sharedInstance().getArticleFeed(articlesDidFinishLoading)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function to be called when articles are finished loading
    func articlesDidFinishLoading(articles : [DICArticle]) {
        // skip the first article because it is the site title
        self.articles = Array(articles[1..<articles.count])
        
        // reload collectionview on the main thread
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if articles.count == 0 {
            //display loading indicator
            var loadingCell = collectionView.dequeueReusableCellWithReuseIdentifier("loadingCell", forIndexPath: indexPath) as! UICollectionViewCell
            return loadingCell
        }
        
        // otherwise, show articles normally
        var articleCell = collectionView.dequeueReusableCellWithReuseIdentifier("articleViewCell", forIndexPath: indexPath) as! ArticleViewCell
        
        let article = articles[indexPath.row]
        articleCell.title = article.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        //we don't want html in our description
        let descrWithoutHTML = article.descr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                                            .stringByReplacingOccurrencesOfString("&#160;", withString: " ", options: .RegularExpressionSearch, range: nil)
                                            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        articleCell.descr = descrWithoutHTML
        
        return articleCell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 // for now
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if articles.count == 0 {
            return 1 // so we can display a loading indicator
        }
        return articles.count
    }
    
}

// MARK: UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    
    
}

