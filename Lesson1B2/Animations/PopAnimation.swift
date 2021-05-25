//
//  PopAnimation.swift
//  Lesson1B2
//
//  Created by user on 09.05.2021.
//

import UIKit

class PopAnimation: NSObject {

}

extension PopAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceVC = transitionContext.viewController(forKey: .from),
              let destinationVC = transitionContext.viewController(forKey: .to) else {return}
        
        let containerViewFrame = transitionContext.containerView.frame
        
        transitionContext.containerView.addSubview(destinationVC.view)
        
        let anime = CABasicAnimation(keyPath: "transform.rotation.z")
        anime.fromValue = 0
        anime.toValue = -1.5
        anime.duration = 0.8
        anime.fillMode = CAMediaTimingFillMode.backwards
        
        let anime2 = CABasicAnimation(keyPath: "transform.rotation.z")
        anime2.fromValue = 1.5
        anime2.toValue = 0
        anime2.duration = 0.8
        anime2.fillMode = CAMediaTimingFillMode.backwards
        
    
        destinationVC.view.frame = CGRect(x: -containerViewFrame.height / 1.5 , y: -containerViewFrame.height / 1.5, width: containerViewFrame.width, height: containerViewFrame.height)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            destinationVC.view.layer.add(anime2, forKey: nil)
            destinationVC.view.frame = CGRect(x: 0, y: 0, width: containerViewFrame.width, height: containerViewFrame.height)
            
            sourceVC.view.frame = CGRect(x: containerViewFrame.height / 1.5, y: -containerViewFrame.height / 1.5, width: containerViewFrame.width, height: containerViewFrame.height)
            sourceVC.view.layer.add(anime, forKey: nil)
        },
        completion: { finished in
           
            transitionContext.completeTransition(finished)
            
        })
    }
    
    
}
