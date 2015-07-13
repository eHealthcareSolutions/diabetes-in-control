//
//  ViewController.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/16/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var dicLogo: UIImageView!
    @IBOutlet weak var topicScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // buttons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnFavorites: UIButton!
    @IBOutlet weak var btnPopular: UIButton!
    @IBOutlet var btnCategories: [UIButton]!

    var currentlySelectedBtn: UIButton!
    
    var tileHorizMargin : CGFloat = 10
    var tileVertMargin : CGFloat = 20
    
    var articles = [DICArticle]()
    var loadingNewArticles = false
    var isSegueing = false
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
        let categories = DICConstants.URLConvenience.categories
        for i in 0..<categories.count{
            btnCategories[i].setTitle(padding + categories[i] + padding, forState: .Normal)
        }
        // more padding
        btnHome.setTitle(padding + btnHome.titleForState(.Normal)! + padding, forState: .Normal)
        btnFavorites.setTitle(padding + btnFavorites.titleForState(.Normal)! + padding, forState: .Normal)
        btnPopular.setTitle(padding + btnPopular.titleForState(.Normal)! + padding, forState: .Normal)
        
        //set margins for tiles in collectionview
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsetsMake(tileVertMargin, tileHorizMargin, tileVertMargin, tileHorizMargin)
        
        // set currently selected button color
        currentlySelectedBtn = btnHome
        selectButton(btnHome)
        
        //let f = ScrollViewFactory(topicScrollView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // if we're in the favorites, things may have changed when we finish viewing an article. so we have to get favorites again
        if category == "Favorites" {
            articles = []
            articlesDidFinishLoading(DICFavoritesList.sharedInstance().articles)
        }
        collectionView.reloadData()
        
        // no longer segueing
        isSegueing = false
    }
    
    override func viewDidAppear(animated: Bool) {
        // update buttons with correct font size
        let btnFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
        let btnFont = UIFont(name: DICConstants.fontName, size: btnFontSize)
        for i in 0..<btnCategories.count {
            btnCategories[i].titleLabel!.font = btnFont
        }
        btnHome.titleLabel!.font = btnFont
        btnFavorites.titleLabel!.font = btnFont
        btnPopular.titleLabel!.font = btnFont
    }
    
    // change logo to the correct one for the given orientation
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == UIInterfaceOrientation.Portrait {
            dicLogo.image = UIImage(named: "DICLogo_KO_Portrait")
        } else {
            dicLogo.image = UIImage(named: "DICLogo_KO_Landscape")
        }
    }
    
    // loads new articles to display in collection view
    func loadNewArticles(category : String = "", page : Int = 1) {
        self.category = category
        if loadingNewArticles { // already loading, do nothing
            return
        }
        // otherwise start loading articles
        loadingNewArticles = true
        DICClient.sharedInstance().getArticleFeed(category: category, page: page) { articles in
            self.articlesDidFinishLoading(articles)
        }
    }

    // called when a button is pressed, load new articles for the selected category
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
        
        selectButton(sender)
    }
    
    func selectButton(btn: UIButton) {
        // scroll so selected button is in center
        let margin = (topicScrollView.frame.width - btn.frame.width) / 2
        // don't care about height
        let visibleRect = CGRect(x: btn.frame.origin.x - margin, y: 1, width: topicScrollView.frame.width, height: 1)
        topicScrollView.scrollRectToVisible(visibleRect, animated: true)
        
        // unhighlight previous button
        currentlySelectedBtn.setTitleColor(DICConstants.unselectedTopicFontColor, forState: .Normal)
        
        // highlight selected category
        btn.setTitleColor(DICConstants.selectedTopicFontColor, forState: .Normal)
        
        currentlySelectedBtn = btn
    }
    
    // function to be called when articles are finished loading
    func articlesDidFinishLoading(articles : [DICArticle]) {
        // update UI on main thread
        dispatch_async(dispatch_get_main_queue()) {
            if articles.count == 0 { // no articles left to display
                self.noArticlesLeft = true
            }
            self.articles += articles
            self.collectionView.reloadData() // display new articles
            self.loadingNewArticles = false // done loading
        }
    }
    
    // simulate touching button to the left of the currently selected button
    @IBAction func leftArrowTouchUpInside(sender: UIButton) {
        let btn = currentlySelectedBtn
        if btn == btnHome {
            // do nothing, can't go left further
            return
        } else if btn == btnFavorites {
            touchUpInside(btnHome)
        } else if btn == btnPopular {
            touchUpInside(btnFavorites)
        } else if btn == btnCategories[0] {
            touchUpInside(btnPopular)
        } else {
            let index = find(btnCategories, btn)
            touchUpInside(btnCategories[index!-1])
        }
    }
    
    // simulate touching button to the right of the currently selected button
    @IBAction func rightArrowTouchUpInside(sender: UIButton) {
        let btn = currentlySelectedBtn
        if btn == btnCategories[btnCategories.count-1] {
            // do nothing, can't go right further
            return
        } else if btn == btnHome {
            touchUpInside(btnFavorites)
        } else if btn == btnFavorites {
            touchUpInside(btnPopular)
        } else if btn == btnPopular {
            touchUpInside(btnCategories[0])
        } else {
            let index = find(btnCategories, btn)
            touchUpInside((btnCategories[index!+1]))
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
                var pageToLoad = articles.count / DICConstants.articlesPerPage + 1 // next page
                loadNewArticles(category: self.category, page : pageToLoad)
            }
            else if noArticlesLeft { // notify user
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

        // otherwise, show articles normally by getting new cell and populating it with data
        var articleCell = collectionView.dequeueReusableCellWithReuseIdentifier("articleViewCell", forIndexPath: indexPath) as! ArticleViewCell
        
        let article = articles[indexPath.row]
        articleCell.title = article.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        articleCell.descr = article.descrWithoutHTML
        
        addDropShadow(articleCell)
        return articleCell
    }
    
    // add drop shadow to given view
    func addDropShadow(view : UIView) {
        let CS = DICConstants.CellShadow.self
        view.layer.shadowOffset = CS.offset
        view.layer.shadowOpacity = CS.opacity
        view.layer.shadowRadius = CS.radius
        view.layer.masksToBounds = CS.masksToBounds
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 // for now, we only have one section
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count + 1 // so we can show the activity indicator
    }
    
}

// MARK: UICollectionViewDelegate
//handles transitions to the article view controller
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !isSegueing { // only segue if we are not segueing already
            self.isSegueing = true
            
            // set selected color
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ArticleViewCell
            cell?.setSelected()
            
            if articles.count != 0 && indexPath.row < articles.count { // if we're not currently loading
                // get article to show and segue to it
                articleToShow = articles[indexPath.row]
                performSegueWithIdentifier("showArticleViewController", sender: self)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        // set unselected color
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ArticleViewCell
        cell?.setUnselected()
    }
    
    // provides article to show to the article view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleVC = segue.destinationViewController as? ArticleViewController
        if articleToShow != nil {
            articleVC?.article = articleToShow
        }
    }
    
}

