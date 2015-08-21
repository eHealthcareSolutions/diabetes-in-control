//
//  ViewController.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/16/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var topicScrollView: TopicScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var adLoader : DICAdLoader!
    
    var menuVC : MenuViewController?
    var grayView : UIView!
    
    var collectionViewData : [NSObject]!
    var articleToShow : DICArticle? // holds the article that was just clicked on so we can give it to the article view controller
    var noArticlesLeft = false // at the bottom of infinite scroll
    
    var favorites = DICFavoritesList.sharedInstance()

    var page = 1
    var category : String = DICConstants.URLConvenience.categories[1] // current category
    
    var loadingNewArticles = false
    var isSegueing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewData = [NSObject]()
        
        // get articles from main feed
        loadNewArticles()
        
        // create gray view for graying out screen
        grayView = UIView(frame: CGRectMake(view.frame.minX, view.frame.minY, max(view.frame.size.width, view.frame.size.height), max(view.frame.size.width, view.frame.size.height)))
        grayView.backgroundColor = DICConstants.MenuVC.overlayColor
        grayView.userInteractionEnabled = true
        let gestureRec = UITapGestureRecognizer(target: self, action: "grayViewTouchUpInside:")
        grayView.addGestureRecognizer(gestureRec)
        
        //set margins for tiles in collectionview
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsetsMake(DICConstants.Tile.vertMargin, DICConstants.Tile.horizMargin, DICConstants.Tile.vertMargin, DICConstants.Tile.horizMargin)
        flowLayout.minimumLineSpacing = DICConstants.Tile.vertMargin
        
        // add refresh control to collectionview
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
        topicScrollView.topicDelegate = self
        topicScrollView.setButtons(DICConstants.URLConvenience.categories)
        
        adLoader = DICAdLoader(delegate: self, rootViewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        // if we're in the favorites, things may have changed when we finish viewing an article. so we have to get favorites again
        if category == "Favorites" {
            collectionViewData = []
            articlesDidFinishLoading(DICFavoritesList.sharedInstance().articles)
        }
        collectionView.reloadData()
        
        // hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // no longer segueing
        isSegueing = false
        
        // update cell size to get correct number of columns
        updateCellSize()
        
        // end article read event 
        Flurry.endTimedEvent(DICConstants.Flurry.ARTICLE_READ_EVENT, withParameters: nil)
        
        // log category viewed event
        let params = ["Category": category]
        Flurry.logEvent(DICConstants.Flurry.ARTICLE_READ_EVENT, withParameters: params, timed: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        topicScrollView.update()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateCellSize()
        headerView.update()
        topicScrollView.update()
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
        let percent = UIApplication.sharedApplication().statusBarOrientation == .Portrait ? DICConstants.Tile.heightPercentagePortrait : DICConstants.Tile.heightPercentageLandscape
        let cellHeight = screenHeight * percent
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.minimumLineSpacing = DICConstants.Tile.vertMargin
    }
    
    // loads new articles to display in collection view
    func loadNewArticles() {
        if loadingNewArticles { // already loading, do nothing
            return
        }
        // otherwise start loading articles
        loadingNewArticles = true
        DICClient.sharedInstance().getArticleFeed(category, page: page) { articles in
            self.articlesDidFinishLoading(articles)
        }
    }
    
    // function to be called when articles are finished loading
    func articlesDidFinishLoading(articles : [DICArticle]) {
        // update UI on main thread
        dispatch_async(dispatch_get_main_queue()) {
            if articles.count == 0 { // no articles left to display
                self.noArticlesLeft = true
            }
            self.collectionViewData = self.collectionViewData + articles as [NSObject]
            self.collectionView.reloadData() // display new articles
            self.loadingNewArticles = false // done loading
        }
    }
    
    // simulate touching current topic button
    func refresh(sender: AnyObject) {
        topicScrollView.tapCurrentButton()
        refreshControl.endRefreshing()
    }
    
    @IBAction func menuButtonTouchUpInside(sender: UIButton) {
        // gray out screen
        view.addSubview(grayView)
        
        // if we already have a menu vc destroy it
        menuVC?.removeFromParentViewController()
        
        menuVC = storyboard?.instantiateViewControllerWithIdentifier("menuViewController") as? MenuViewController
        menuVC!.delegate = self
        addChildViewController(menuVC!)
        view.addSubview(menuVC!.view)
        view.bringSubviewToFront(menuVC!.view)
        menuVC!.didMoveToParentViewController(self)
    }
    
    @IBAction func favoritesTouchUpInside(sender: UIButton) {
        topicScrollView.tapFavorites() // simulate favorite button press
    }

    func grayViewTouchUpInside(sender: UITapGestureRecognizer) {
        menuVC!.hide()
    }
    
}

// MARK: DICAdLoaderDelegate 
extension MainViewController: DICAdLoaderDelegate {
    
    func didReceiveInstallAds(installAds: [GADNativeCustomTemplateAd]) {
        collectionViewData.append(installAds)
        collectionView.reloadData()
    }
    
}

// MARK: TopicScrollViewDelegate
extension MainViewController: TopicScrollViewDelegate {
    
    func buttonPressed(named : String) {
        // end previous category viewed event
        Flurry.endTimedEvent(DICConstants.Flurry.CATEGORY_VIEWED_EVENT, withParameters: nil)
        
        category = named
        page = 1
        
        loadingNewArticles = false
        noArticlesLeft = false
        // clear current articles and show activity indicator
        collectionViewData = []
        collectionView.reloadData()
        
        // log category viewed event
        let params = ["Category": category]
        Flurry.logEvent(DICConstants.Flurry.ARTICLE_READ_EVENT, withParameters: params, timed: true)
        
        // if category is favorites, get favorites, otherwise loadnewarticles
        if category == "Favorites" {
            articlesDidFinishLoading(DICFavoritesList.sharedInstance().articles)
        }
        else {
            // get feed for selected category
            loadNewArticles()
        }
        
    }
    
}

// MARK: MenuViewControllerDelegate 
extension MainViewController: MenuViewControllerDelegate {
    
    func hideMe(sender: MenuViewController) {
        grayView.removeFromSuperview()
    }
    
    func showMe(sender: MenuViewController) {
        view.insertSubview(grayView, belowSubview: sender.view)
    }
    
    func destroyMe(sender: MenuViewController) {
        sender.view.removeFromSuperview()
        sender.removeFromParentViewController()
    }
    
    func showFavorites() {
        topicScrollView.tapFavorites() // simulate favorite button press
    }
    
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row >= collectionViewData.count {
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
                page += 1
                loadNewArticles()
                return self.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            }

        }

        // get new cell and populate it with data
        let data = collectionViewData[indexPath.row]
        
        if let article = data as? DICArticle { // article cell
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
        } else if let installAds = data as? [GADNativeCustomTemplateAd] { // app install ads
            // record impressions
            for installAd in installAds {
                installAd.recordImpression()
            }
            
            let installAdCell = collectionView.dequeueReusableCellWithReuseIdentifier("adInstallCell", forIndexPath: indexPath) as! AppInstallAdCell
            installAdCell.ads = installAds
            installAdCell.delegate = self
            return installAdCell
        }
        
        // should never get here
        return collectionView.dequeueReusableCellWithReuseIdentifier("notARealCell", forIndexPath: indexPath) as! UICollectionViewCell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1 // for now, we only have one section
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count + 1 // so we can show the activity indicator
    }
    
}

// MARK: AppInstallAdCellDelegate
extension MainViewController: AppInstallAdCellDelegate {
    
    func appInstallAdCellTapped(forAd: GADNativeCustomTemplateAd) {
        forAd.performClickOnAssetWithKey(DICConstants.AppInstallAd.ctaKey, customClickHandler: nil)
    }
    
}

// MARK: UICollectionViewDelegate
//handles transitions to the article view controller
extension MainViewController: ArticleViewCellDelegate {
    
    func articleViewCellTapped(cell : ArticleViewCell, tappedFavorite : Bool) {
        let indexPath = collectionView.indexPathForCell(cell)
        let article = collectionViewData[indexPath!.row] as! DICArticle
        
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
            
            // log flurry event
            let articleParams = ["Title": article.title, /*"Author": article.author,*/ "Category": article.category]
            Flurry.logEvent(DICConstants.Flurry.ARTICLE_READ_EVENT, withParameters: articleParams, timed: true)
            
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

// MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headerView.didScroll(scrollView.contentOffset.y)
    }
    
}
