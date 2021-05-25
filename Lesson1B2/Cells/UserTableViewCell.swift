//
//  UserTableViewCell.swift
//  Lesson1B2
//
//  Created by user on 13.04.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatar.layer.cornerRadius = 28
        self.avatarView.layer.cornerRadius = 28
        self.avatarView.layer.shadowRadius = 2
        self.avatarView.layer.shadowColor = UIColor.black.cgColor
        self.avatarView.layer.shadowOpacity = 0.7
        self.avatarView.layer.shadowOffset = CGSize(width: -4, height: 1.5)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(text: String?, image: UIImage?) {
        avatar.image = image
        titleLabel.text = text
    }
}
