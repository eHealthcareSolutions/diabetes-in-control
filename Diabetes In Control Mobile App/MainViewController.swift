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
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var topicButtons = [UIButton]()
    var currentlySelectedBtn: UIButton!
    
    var articles = [DICArticle]()
    var articleToShow: DICArticle? // holds the article that was just clicked on so we can give it to the article view controller
    var noArticlesLeft = false // at the bottom of infinite scroll
    
    var favorites = DICFavoritesList.sharedInstance()

    var category : String = "" // current category
    
    var loadingNewArticles = false
    var isSegueing = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get articles from main feed
        loadNewArticles()
        
        //set margins for tiles in collectionview
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsetsMake(DICConstants.Tile.vertMargin, DICConstants.Tile.horizMargin, DICConstants.Tile.vertMargin, DICConstants.Tile.horizMargin)
        flowLayout.minimumLineSpacing = DICConstants.Tile.vertMargin
        
        // add refresh control to collectionview
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
        
        // add buttons to scrollview
        let scrollViewFactory = ScrollViewFactory(scrollView: topicScrollView)
        
        let categories = DICConstants.URLConvenience.categories
        for i in 0..<categories.count {
            let button = scrollViewFactory.addButtonNamed(categories[i])
            topicButtons.append(button)
            
            // add listener
            button.addTarget(self, action: "topicTouchUpInside:", forControlEvents: .TouchUpInside)
        }
        scrollViewFactory.finish()
        
        // set currently selected button
        currentlySelectedBtn = topicButtons[1] // home button
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
        
        // update cell size to get correct number of columns
        updateCellSize()
    }
    
    override func viewDidAppear(animated: Bool) {
        // update buttons with correct font size
        let btnFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
        let btnFont = UIFont(name: DICConstants.fontName, size: btnFontSize)
        for i in 0..<topicButtons.count {
            topicButtons[i].titleLabel!.font = btnFont
        }
        
        selectButton(currentlySelectedBtn)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateCellSize()
    }
    
    func updateCellSize() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // calc width
        var cellWidth : CGFloat
        if screenWidth > DICConstants.ColNumThresholds.three {
            // update cell width so that there are 3 columns
            cellWidth = (screenWidth - DICConstants.Tile.horizMargin * 4) / 3
        } else if screenWidth > DICConstants.ColNumThresholds.two {
            // update cell width so that there are 2 columns
            cellWidth = (screenWidth - DICConstants.Tile.horizMargin  * 3) / 2
        } else {
            // update cell width so that there is 1 column
            cellWidth = screenWidth - DICConstants.Tile.horizMargin  * 2
        }
        
        // calc height
        let cellHeight = screenHeight * DICConstants.Tile.heightPercentage
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.minimumLineSpacing = DICConstants.Tile.vertMargin
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
    func topicTouchUpInside(sender: UIButton) {
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
        currentlySelectedBtn.setTitleColor(DICConstants.ScrollView.unselectedColor, forState: .Normal)
        
        // highlight selected category
        btn.setTitleColor(DICConstants.ScrollView.selectedColor, forState: .Normal)
        
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
        
        // if we're in the home category, set the newest article
        
    }
    
    // simulate touching button to the left of the currently selected button
    @IBAction func leftArrowTouchUpInside(sender: UIButton) {
        let index = find(topicButtons, currentlySelectedBtn)
        if index! > 0 { // can safely move left
            topicTouchUpInside(topicButtons[index!-1])
        }
    }
    
    // simulate touching button to the right of the currently selected button
    @IBAction func rightArrowTouchUpInside(sender: UIButton) {
        let index = find(topicButtons, currentlySelectedBtn)
        if index! < topicButtons.count-1 { // can safely move left
            topicTouchUpInside(topicButtons[index!+1])
        }
    }
    
    // simulate touching current topic button
    func refresh(sender: AnyObject) {
        topicTouchUpInside(currentlySelectedBtn)
        refreshControl.endRefreshing()
    }
    
    @IBAction func favoritesTouchUpInside(sender: UIButton) {
        topicTouchUpInside(topicButtons[0]) // simulate favorite button press
    }
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row >= articles.count {
            if loadingNewArticles { // loading indicator
                var loadingCell = collectionView.dequeueReusableCellWithReuseIdentifier("loadingCell", forIndexPath: indexPath) as! UICollectionViewCell
                return loadingCell
            }
            else if category == "Favorites" { // don't want to load new articles in favorites
                noArticlesLeft = true
            }
                
            if noArticlesLeft { // notify user
                var noMoreArticlesCell = collectionView.dequeueReusableCellWithReuseIdentifier("noMoreArticlesViewCell", forIndexPath: indexPath) as! UICollectionViewCell
                noMoreArticlesCell.addDropShadow()
                return noMoreArticlesCell
            }
            else { //start loading new articles
                var pageToLoad = articles.count / DICConstants.articlesPerPage + 1 // next page
                loadNewArticles(category: self.category, page : pageToLoad)
                return self.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            }

        }

        // otherwise, show articles normally by getting new cell and populating it with data
        let article = articles[indexPath.row]
        
        var articleCell : ArticleViewCell!
        if article.image == nil { // normal cell
            articleCell = collectionView.dequeueReusableCellWithReuseIdentifier("articleViewCell", forIndexPath: indexPath) as! ArticleViewCell
        } else { // image cell
            articleCell = collectionView.dequeueReusableCellWithReuseIdentifier("articleViewCellWithImage", forIndexPath: indexPath) as! ArticleViewCellWithImage
            (articleCell as! ArticleViewCellWithImage).image = article.image
        }
        
        // set info
        articleCell.title = article.title
        articleCell.descr = article.descrWithoutHTML
        articleCell.isFavorite = favorites.findFavoriteWithTitle(article.title)
        
        // set tap delegate
        if (articleCell.delegate == nil) {
            articleCell.delegate = self
        }
        
        return articleCell
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
extension MainViewController: ArticleViewCellDelegate {
    
    func articleViewCellTapped(cell : ArticleViewCell, tappedFavorite : Bool) {
        let indexPath = collectionView.indexPathForCell(cell)
        let article = articles[indexPath!.row]
        
        if tappedFavorite { // don't segue, just change favorite status
            if cell.isFavorite { // remove from favorites
                cell.isFavorite = false
                favorites.removeFavorite(article)
            }
            else { // add to favorites
                cell.isFavorite = true
                favorites.addFavorite(article)
            }
        } else if !isSegueing { // only segue if we are not segueing already
            self.isSegueing = true
            
            // get article to show and segue to it
            articleToShow = article
            performSegueWithIdentifier("showArticleViewController", sender: self)
        }
    }
    
    // provides article to show to the article view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleVC = segue.destinationViewController as? ArticleViewController
        if articleToShow != nil {
            articleVC?.article = articleToShow
        }
    }
    
}

