//
//  NewsTableViewCell.swift
//  Lesson1B2
//
//  Created by user on 22.04.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var viewingLabel: UILabel!
    
    var isLiked = false
    
    func clearCell() {
        sourceImage.image = nil
        sourceName.text = nil
        newsText.text = nil
        newsImage.image = nil
        viewingLabel.text = nil
        newsImageTopConstraint.constant = 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        sourceImage.layer.cornerRadius = 25
        sourceView.layer.cornerRadius = 25
        self.sourceView.layer.shadowRadius = 2
        self.sourceView.layer.shadowColor = UIColor.black.cgColor
        self.sourceView.layer.shadowOpacity = 0.7
        self.sourceView.layer.shadowOffset = CGSize(width: -4, height: 1.5)
        clearCell()
    }

    override func prepareForReuse() {
        clearCell()
    }
    
    func configure(sorsName: String?, newText: String?, sorsImage: UIImage?, newImage: UIImage?) {
        sourceName.text = sorsName
        sourceImage.image = sorsImage
//        newsImage.image = newImage
        newsText.text = newText
        if let newImage = newImage {
            newsImage.image = newImage
            if newsImage.image != nil {
                let ratio = newImage.size.width / newImage.size.height
                let newHeight = newsImage.frame.width / ratio
                newsImageTopConstraint.constant = newHeight
                setNeedsLayout()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        if !isLiked {
            likeLabel.text = "1"
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartButton.tintColor = UIColor.systemRed
            isLiked = true
        } else if isLiked {
            likeLabel.text = "0"
            heartButton.tintColor = UIColor.systemGray
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            isLiked = false
        }
    }
    
    
    
    
}
