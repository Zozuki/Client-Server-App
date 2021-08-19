//
//  NewsTextCell.swift
//  Lesson1B2
//
//  Created by user on 14.07.2021.
//

import UIKit

class NewsTextCell: UITableViewCell {
    
    @IBOutlet weak var NewsText: UILabel!
    
    @IBOutlet weak var showMoreLessButton: UIButton!
    
    var isTextOpened = false
    
    func clearCell() {
        NewsText.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }
    
    override func prepareForReuse() {
        
        clearCell()
    }
    
    
    
    func configure( newText: String?) {
        
        NewsText.text = newText
        showMoreLessButton.isHidden = true
        let size = getLabelSize(text:  NewsText.text!, font:  NewsText.font)
        
        if size.height > 200  {
            NewsText.numberOfLines = 1
            showMoreLessButton.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showMoreButtonTapped(_ sender: UIButton) {
        if NewsText.numberOfLines > 0 {
            NewsText.numberOfLines = 0
            isTextOpened = true
            titleLabelFrame()
            showMoreLessButton.titleLabel?.text = "Скрыть"
        } else {
            NewsText.numberOfLines = 1
            isTextOpened = false
            titleLabelFrame()
            showMoreLessButton.titleLabel?.text = "Показать"
        }
        
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.bounds.width  * 2
        
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = (text as NSString).boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        let size = rect.size
        
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    func titleLabelFrame() {
        let labelSize = self.getLabelSize(text: NewsText.text!, font: NewsText.font)
        self.frame.size = labelSize
    }
    
}



