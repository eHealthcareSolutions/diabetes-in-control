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
    
    // buttons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnPopular: UIButton!
    @IBOutlet var btnCategories: [UIButton]!
    
    var articles = [DICArticle]()
    var loadingNewArticles = false
    var noArticlesLeft = false // at the bottom of infinite scroll
    var category : String = "" // current category
    var articleToShow: DICArticle? // holds the article that was just clicked on so we can give it to the article view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get articles from main feed
        loadNewArticles()
        
        // update button names to reflect those in DICConstants
        // add padding so buttons aren't squished together
        let padding = "\t"
        let categories = DICClient.Constants.categories
        for i in 0..<categories.count{
            btnCategories[i].setTitle(padding + categories[i] + padding, forState: .Normal)
        }
        // more padding
        btnHome.setTitle(padding + btnHome.titleForState(.Normal)! + padding, forState: .Normal)
        btnFavorites.setTitle(padding + btnFavorites.titleForState(.Normal)! + padding, forState: .Normal)
        btnPopular.setTitle(padding + btnPopular.titleForState(.Normal)! + padding, forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        // if we're in the favorites, things may have changed when we finish viewing an article. so we have to get favorites again
        if category == "Favorites" {
            articles = []
            articlesDidFinishLoading(DICFavoritesList.sharedInstance().articles)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // update buttons with correct font size
        let btnFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
        let btnFont = UIFont(name: DICClient.Constants.fontName, size: btnFontSize)
        for i in 0..<btnCategories.count {
            btnCategories[i].titleLabel!.font = btnFont
        }
        btnHome.titleLabel!.font = btnFont
        btnFavorites.titleLabel!.font = btnFont
        btnPopular.titleLabel!.font = btnFont
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // loads new articles to display in collection view
    func loadNewArticles(category : String = "", page : Int = 1) {
        self.category = category
        if loadingNewArticles { // already loading
            return
        }
        // otherwise start loading articles
        loadingNewArticles = true
        DICClient.sharedInstance().getArticleFeed(category: category, page: page) { articles in
            self.articlesDidFinishLoading(articles)
        }
    }

    // called when a button is pressed
    @IBAction func touchUpInside(sender: UIButton) {
        loadingNewArticles = false
        noArticlesLeft = false
        // clear current articles and show activity indicator
        articles = []
        collectionView.reloadData()
        
        //get category, remove padding
        category = sender.titleForState(UIControlState.Normal)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        // if category is favorites, get favorites, otherwise loadnewarticles
        if category == "Favorites" {
            articlesDidFinishLoading(DICFavoritesList.sharedInstance().articles)
        }
        else {
            // get feed for selected category
            loadNewArticles(category: category)
        }
    }
    
    // function to be called when articles are finished loading
    func articlesDidFinishLoading(articles : [DICArticle]) {
        // update UI on main thread
        dispatch_async(dispatch_get_main_queue()) {
            if articles.count == 0 { // no articles left to display
                self.noArticlesLeft = true
            }
            self.articles += articles
            self.collectionView.reloadData()
            self.loadingNewArticles = false
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row >= articles.count {
            if category == "Favorites" { // don't want to load new articles in favorites
                noArticlesLeft = true
            }
            
            if !loadingNewArticles && !noArticlesLeft { //start loading new articles
                var pageToLoad = articles.count / DICClient.Constants.articlesPerPage + 1
                loadNewArticles(category: self.category, page : pageToLoad)
            }
            else if noArticlesLeft { //say that
                // using an article cell for now, that may change
                var articleCell = collectionView.dequeueReusableCellWithReuseIdentifier("articleViewCell", forIndexPath: indexPath) as! ArticleViewCell
                articleCell.title = "No more articles to display!"
                articleCell.descr = "Select another category to view more articles."
                
                addDropShadow(articleCell)
                return articleCell
            }
            
            //display loading indicator
            var loadingCell = collectionView.dequeueReusableCellWithReuseIdentifier("loadingCell", forIndexPath: indexPath) as! UICollectionViewCell
            
            addDropShadow(loadingCell)
            return loadingCell
        }

        // otherwise, show articles normally
        var articleCell = collectionView.dequeueReusableCellWithReuseIdentifier("articleViewCell", forIndexPath: indexPath) as! ArticleViewCell
        
        let article = articles[indexPath.row]
        articleCell.title = article.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        articleCell.descr = article.descrWithoutHTML
        
        addDropShadow(articleCell)
        return articleCell
    }
    
    func addDropShadow(view : UIView) {
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 // for now
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count + 1 // so we can show the activity indicator
    }
    
}

// MARK: UICollectionViewDelegate
//handles transitions to the article view controller
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if articles.count != 0 && indexPath.row < articles.count { //if we're not currently loading
            articleToShow = articles[indexPath.row]
            performSegueWithIdentifier("showArticleViewController", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleVC = segue.destinationViewController as? ArticleViewController
        if articleToShow != nil {
            articleVC?.article = articleToShow
        }
    }
    
}

