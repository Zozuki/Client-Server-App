//
//  NewsSourceCell.swift
//  Lesson1B2
//
//  Created by user on 14.07.2021.
//

import UIKit

class NewsSourceCell: UITableViewCell  {
    
    @IBOutlet weak var newsSourceVeiw: UIView!
    
    @IBOutlet weak var newsSourceImage: UIImageView!
    
    @IBOutlet weak var newsSourceName: UILabel!
    
    
    func clearCell() {
        newsSourceImage.image = nil
        newsSourceName.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsSourceImage.layer.cornerRadius = 25
        newsSourceVeiw.layer.cornerRadius = 25
        self.newsSourceVeiw.layer.shadowRadius = 2
        self.newsSourceVeiw.layer.shadowColor = UIColor.black.cgColor
        self.newsSourceVeiw.layer.shadowOpacity = 0.7
        self.newsSourceVeiw.layer.shadowOffset = CGSize(width: -4, height: 1.5)
        clearCell()
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    func configure(sorsName: String?, sorsImage: UIImage?) {
        newsSourceName.text = sorsName
        newsSourceImage.image = sorsImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
