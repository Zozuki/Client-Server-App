//
//  NewsTextCell.swift
//  Lesson1B2
//
//  Created by user on 14.07.2021.
//

import UIKit

class NewsTextCell: UITableViewCell {
    
    @IBOutlet weak var NewsText: UILabel!
    
    
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
