//
//  ArticleViewController.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/24/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var articleWebView: UIWebView!
    
    var article : DICArticle!
    var isFavorite : Bool = false
    var favorites : DICFavoritesList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = article.title
        
        articleWebView.loadHTMLString(article.content, baseURL: nil)
        articleWebView.delegate = self
        articleWebView.scrollView.delegate = self
        articleWebView.scrollView.directionalLockEnabled = false // only allow vertical scrolling
        articleWebView.scrollView.showsHorizontalScrollIndicator = false
        
        favorites = DICFavoritesList.sharedInstance() // set favorites button accordingly
        if favorites.findFavoriteWithTitle(article.title) {
            favoriteButton.image = UIImage(named: "Favorite Selected")
            isFavorite = true
        }
        
        // show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func touchUpFavoriteButton(sender: UIBarButtonItem) {
        isFavorite = !isFavorite
        
        if isFavorite {
            sender.image = UIImage(named: "Favorite Selected")
            favorites.addFavorite(article)
        }
        else {
            sender.image = UIImage(named: "Favorite")
            favorites.removeFavorite(article)
        }
    }

}

//MARK: UIWebViewDelegate
extension ArticleViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {

            // check if it's a link to another article on DIC
            if var urlString = request.URL?.absoluteString {
                if urlString.hasPrefix(DICConstants.URLConvenience.articlesUrl) {
                    //open like we would any other article
                    urlString += DICConstants.URLConvenience.feedSingleArticle
                    
                    let urlRequest = NSURLRequest(URL: NSURL(string: urlString)!)
                    DICClient.sharedInstance().getArticlesFromURLRequest(urlRequest) { articles in
                        dispatch_async(dispatch_get_main_queue()) {
                            if articles.count > 0 {
                                // create an article view controller from storyboard, give it the article to show, then push it to the nav controller
                                let articleVC = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleViewController") as! ArticleViewController
                                let articleToShow = articles[0] // articles array should only have one article in it
                                articleVC.article = articleToShow
                                self.navigationController?.pushViewController(articleVC, animated: true)
                            }
                        }
                    }
                } else { // just open in safari
                    UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
                }
            }
            return false // we already handled the link
        }
        
        return true
    }
    
}

//MARK: UIScrollViewDelegate
extension ArticleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // disable horiz scrolling
        if scrollView.contentOffset.x != 0 {
            var offset = scrollView.contentOffset
            offset.x = 0
            scrollView.contentOffset = offset
        }
    }
    
}