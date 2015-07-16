//
//  ArticleViewCell.swift
//  Diabetes In Control Mobile App
//
//  Created by Connor Watts on 6/17/15.
//  Copyright (c) 2015 Diabetes In Control. All rights reserved.
//

import UIKit

class ArticleViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!

    let cellSelectedTextColor = UIColor(red: 0, green: 0.56, blue: 0.84, alpha: 1.0)
    let cellUnselectedTextColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.0)
    let readMoreBorderColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.0)
    let readMoreKerning = CGFloat(2)
    
    var delegate : ArticleViewCellDelegate!
    
    override func awakeFromNib() {
        // set look of read more label
        readMoreLabel.layer.borderWidth = 0.5
        readMoreLabel.layer.borderColor = readMoreBorderColor.CGColor
        
        // add touch recognizer
        var touch = UITapGestureRecognizer(target: self, action:"handleTap:")
        self.addGestureRecognizer(touch)
        
        // set kerning for read more button
        let attrStr = NSMutableAttributedString(string: readMoreLabel.text!)
        attrStr.addAttribute(NSKernAttributeName, value: readMoreKerning, range: NSMakeRange(0, attrStr.length))
        readMoreLabel.attributedText = attrStr
        
        // set fonts of labels
        let titleFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize
        let titleFont = UIFont(name: DICConstants.fontName, size: titleFontSize)
        titleLabel.font = titleFont
        
        let descrFontSize = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).pointSize
        let descrFont = UIFont(name: DICConstants.fontName, size: descrFontSize)
        descrLabel.font = descrFont
        
        addDropShadow()
    }
    
    var title = "Title" { // update title label to given title
        didSet {
            titleLabel.text = title
        }
    }
    
    var descr = "Descr" { // update descr label to given descr
        didSet {
            descrLabel.text = descr
        }
    }
    
    var isFavorite = false { // determines image of favorites button
        didSet {
            if isFavorite {
                favoriteButton.image = UIImage(named: "Favorite Selected")
            }
            else {
                favoriteButton.image = UIImage(named: "Favorite")
            }
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let favoriteFrame = CGRectMake(favoriteButton.frame.minX - favoriteButton.frame.width, favoriteButton.frame.minY - favoriteButton.frame.height, 3 * favoriteButton.frame.width, 3 * favoriteButton.frame.height)
        if favoriteFrame.contains(recognizer.locationInView(self)) {
            delegate.articleViewCellTapped(self, tappedFavorite: true)
        } else {
            setSelected()
            delegate.articleViewCellTapped(self, tappedFavorite: false)
        }
    }
    
    func setSelected() {
        readMoreLabel.textColor = cellSelectedTextColor
    }
    
    func setUnselected() {
        readMoreLabel.textColor = cellUnselectedTextColor
    }
    
    // reset cell to reusable state (deselect)
    override func prepareForReuse() {
        setUnselected()
        isFavorite = false
    }
}

protocol ArticleViewCellDelegate {
    
    func articleViewCellTapped(cell : ArticleViewCell, tappedFavorite : Bool)
    
}

// MARK: convenience extension to add drop shadow
extension UICollectionViewCell {
    
    func addDropShadow() {
        let CS = DICConstants.CellShadow.self
        layer.shadowOffset = CS.offset
        layer.shadowOpacity = CS.opacity
        layer.shadowRadius = CS.radius
        layer.masksToBounds = CS.masksToBounds
    }
    
}