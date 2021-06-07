//
//  AvatarDetailVC.swift
//  Lesson1B2
//
//  Created by user on 14.04.2021.
//

import UIKit

class AvatarDetailVC: UIViewController {

    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var allPhotoButton: UIButton!
    
    
    var isLiked = false
    var avatar = UIImage()
    let interactiveTransition = InteractiveTransitionClass()
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.image = avatar
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        interactiveTransition.viewController = self
        fullView.addGestureRecognizer(recognizer)
    }
    
    @objc func tappedView() {
        let anime = CASpringAnimation(keyPath: "transform.scale")
        anime.fromValue = 0.85
        anime.toValue = 1
        anime.stiffness = 200
        anime.mass = 1
        anime.duration = 1
        anime.fillMode = CAMediaTimingFillMode.backwards
        avatarView.layer.add(anime, forKey: nil)
    }
    
    @IBAction func allPhotoButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Photo")
            as? PhotoVC {
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
