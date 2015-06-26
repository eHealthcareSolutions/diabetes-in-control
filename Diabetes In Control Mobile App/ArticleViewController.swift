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
    
    var article : DICArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = article.title
        
        // update labels to reflect the article we're supposed to show
        // article field should be set by now
        let contentAsAttributedString = NSAttributedString(data: article.content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil, error: nil)!
        mainArticleLabel.attributedText = contentAsAttributedString
    }
    
}
