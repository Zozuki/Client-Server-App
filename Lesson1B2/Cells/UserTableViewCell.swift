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
        self.avatarView.backgroundColor = .white
        self.titleLabel.backgroundColor = .white
        self.avatar.backgroundColor = .white
    }

    let insets: CGFloat = 10
    
    
    override func layoutSubviews() {
        titleLabelFrame()
        avatarFrame()
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.bounds.width - insets * 2
        
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let rect = (text as NSString).boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        let size = rect.size
        
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    func titleLabelFrame() {
        let labelSize = self.getLabelSize(text: titleLabel.text!, font: titleLabel.font)
        
        let x = ceil(bounds.minX + insets * 10 )
        
        let y = (bounds.height - labelSize.height) / 2
        
        let origin = CGPoint(x: ceil(x), y: ceil(y))
        
        titleLabel.frame = CGRect(origin: origin, size: labelSize)
    }
    
    func avatarFrame() {
        let iconSideSize: CGFloat = 55
        
        let iconSIze = CGSize(width: iconSideSize, height: iconSideSize)
        
        let origin = CGPoint(x: ceil(bounds.minX + iconSideSize / 2), y: ceil(bounds.midY - iconSideSize / 2))
        
        avatarView.frame = CGRect(origin: origin, size: iconSIze)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(text: String?, image: UIImage?) {
        avatar.image = image
        titleLabel.text = text
        titleLabelFrame()
        avatarFrame()
    }
}
