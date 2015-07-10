//
//  ArticleViewController.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/24/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var mainArticleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    var article : DICArticle!
    var isFavorite : Bool = false
    var favorites : DICFavoritesList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = article.title
        
        // update labels to reflect the article we're supposed to show
        // article field should be set by now
        let font = UIFont(name: DICConstants.fontName, size: 16)
        let contentAsAttributedString = NSMutableAttributedString(data: article.content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil, error: nil)!
       
        println(contentAsAttributedString)
        //contentAsAttributedString.setAttributes([NSFontAttributeName : font!], range: NSMakeRange(0, contentAsAttributedString.length))
        //let fontAttr = contentAsAttributedString.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil)

        mainArticleLabel.attributedText = contentAsAttributedString
        
        favorites = DICFavoritesList.sharedInstance()
        if favorites.findFavoriteWithTitle(article.title) {
            favoriteButton.image = UIImage(named: "Favorite Selected")
            isFavorite = true
        }
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
