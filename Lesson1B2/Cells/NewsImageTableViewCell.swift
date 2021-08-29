//  NewsImageTableViewCell.swift
//  Lesson1B2
//
//  Created by user on 15.07.2021.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {

    var mainImageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageViewHeight = NSLayoutConstraint()
    var imageRatioWidth = CGFloat()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        let aspectRatioConstraint = NSLayoutConstraint(item: self.mainImageView, attribute: .height,relatedBy: .equal,toItem: self.mainImageView,attribute: .width, multiplier: (2.0 / 1.0),constant: 0)
        self.mainImageView.addConstraint(aspectRatioConstraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure( newImage: UIImage?) {
        if let newImage = newImage {
            imageView?.image = newImage
        }
    }

}
