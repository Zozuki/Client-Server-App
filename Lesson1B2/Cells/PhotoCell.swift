//
//  PhotoCell.swift
//  Lesson1B2
//
//  Created by user on 09.04.2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    var isLiked = false
    
    
    override func layoutSubviews() {
        self.heartButton.backgroundColor = .white
        self.likeLabel.backgroundColor = .white
    }
    
    func imageTapped() {
        UIView.animate(withDuration: 1, animations: {
            self.photoView.layer.cornerRadius = 200
        })
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        if !isLiked {
            UIView.animate(withDuration: 0.7, animations: { [weak self] in
                guard let self = self else {return}
                self.likeLabel.text = "1"
                self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.heartButton.tintColor = UIColor.systemRed
                self.isLiked = true
                
                let anime = CASpringAnimation(keyPath: "transform.scale")
                anime.fromValue = 0.85
                anime.toValue = 1
                anime.stiffness = 200
                anime.mass = 1
                anime.duration = 1
                anime.fillMode = CAMediaTimingFillMode.backwards
                
                self.heartButton.layer.add(anime, forKey: nil)
            })
        } else {
            UIView.animate(withDuration: 0.7, animations: { [weak self] in
                guard let self = self else {return}
                self.likeLabel.text = "0"
                self.heartButton.tintColor = UIColor.systemGray
                self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.isLiked = false
                
                let anime = CASpringAnimation(keyPath: "transform.scale")
                anime.fromValue = 0.85
                anime.toValue = 1
                anime.stiffness = 200
                anime.mass = 1
                anime.duration = 1
                anime.fillMode = CAMediaTimingFillMode.backwards
                
                self.heartButton.layer.add(anime, forKey: nil)
            })
        }
    }
}
