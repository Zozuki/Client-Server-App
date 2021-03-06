//
//  CustomGalleryVC.swift
//  Lesson1B2
//
//  Created by user on 02.05.2021.
//

import UIKit

class CustomGalleryVC: UIViewController {

  
    var photoImageView = UIImageView()
    var photos = [UIImage]()
    var interactiveAnimator: UIViewPropertyAnimator!
    var suppImageView = UIImageView()
    var index = 0
    private var isLeftSwipe = false
    private var isRightSwipe = false
    private var chooseFlag = false
    var isSupImageFirst = false
    var isLeftSwipePerform = false
    var isRightSwipePerform = false
  
    var isLastPhoto = false
    let anime2 = CASpringAnimation(keyPath: "transform.scale")
    let y: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
        
 
        anime2.fromValue = 1
        anime2.toValue = 0.7
        anime2.stiffness = 50
        anime2.mass = 1
        anime2.duration = 1
        anime2.fillMode = CAMediaTimingFillMode.backwards

        firstSetImage()
        
    }
    
    func firstSetImage() {
        photoImageView.frame = UIScreen.main.bounds
        photoImageView.image = photos[0]
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.transform = CGAffineTransform(translationX: 0, y: y)
        self.view.addSubview(photoImageView)
        if photos.count > 1 {
            suppImageView.frame = UIScreen.main.bounds
            suppImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: y)
            suppImageView.image = photos[1]

            suppImageView.contentMode = .scaleAspectFit
            self.view.addSubview(suppImageView)
        }
       
    }
    
    func setImage() {
        if isLeftSwipePerform {
            if isSupImageFirst {
                photoImageView.image = photos[index]
//                suppImageView.layer.add(anime2, forKey: nil)
            } else {
                suppImageView.image = photos[index]
//                photoImageView.layer.add(anime2, forKey: nil)
            }
        }
        if isRightSwipePerform {
            if isSupImageFirst {
                photoImageView.image = photos[index]
//                suppImageView.layer.add(anime2, forKey: nil)
            } else {
                suppImageView.image = photos[index]
//                photoImageView.layer.add(anime2, forKey: nil)
            }
        }
    }
    
    
    
    func performImageViewForRightSwipe() {
        isRightSwipePerform = true
        if index > photos.count - 1 {
            index = photos.count - 1
        }
        index -= 1
        if index >= 0 {
            print(index)
            setImage()
            if isSupImageFirst {
                photoImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
            } else {
                suppImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: y)
            }
        }
    }
    
    func performImageViewForLeftSwipe() {
        isLeftSwipePerform = true
        if index < 0 {
            index = 0
        }
        index += 1
        if index <= photos.count - 1  {
            setImage()
            if isSupImageFirst {
                photoImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            } else {
                suppImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: y)
            }
        }
    }
    
    func leftSwipe() {
        if index < photos.count {
            if isSupImageFirst {
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.suppImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: self.y)
                    self.photoImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                })
                isSupImageFirst = false
                
                interactiveAnimator.pauseAnimation()
            } else {

                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.photoImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    self.suppImageView.transform = CGAffineTransform(translationX: 0, y: self.y)
                    
                })
                isSupImageFirst = true
                interactiveAnimator.pauseAnimation()
            }
        }
    }
    
    func rightSwipe() {
        print(index, photos.count )
        if index >= 0 {
            if isSupImageFirst {
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.suppImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: self.y)
                    self.photoImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                })
                isSupImageFirst = false
                
                interactiveAnimator.pauseAnimation()
            } else {
                
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.photoImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                    self.suppImageView.transform = CGAffineTransform(translationX: 0, y: self.y)
                    
                })
                isSupImageFirst = true
                interactiveAnimator.pauseAnimation()
            }
        }
    }
    
    func goBack() {
        if isLeftSwipePerform {
            index -= 1
            if isSupImageFirst {
               
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.photoImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                    self.suppImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                })
                interactiveAnimator.pauseAnimation()

            } else {
                
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.photoImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.suppImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                })
                
                interactiveAnimator.pauseAnimation()
            }
        }
        
        if isRightSwipePerform {
            index += 1
            if isSupImageFirst {
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.photoImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                    self.suppImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                })
                interactiveAnimator.pauseAnimation()

            } else {
                
                interactiveAnimator?.startAnimation()
                interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                    self.photoImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.suppImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                })
                
                interactiveAnimator.pauseAnimation()
            }
        }
        
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        if let animator = interactiveAnimator,
           animator.isRunning {
            return
        }
        
        
        switch recognizer.state {
        case .began:
           
               
            interactiveAnimator?.startAnimation()
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {})
            
            interactiveAnimator.pauseAnimation()

            
            
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            
            interactiveAnimator.fractionComplete = translation.x / -UIScreen.main.bounds.width
            
            if translation.x < 0 {
                if !isLeftSwipePerform {
                    performImageViewForLeftSwipe()
                }
                if index <= photos.count - 1 {
                    if isSupImageFirst {
                        
                        interactiveAnimator?.startAnimation()
                        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                            self.photoImageView.transform = CGAffineTransform(translationX: self.suppImageView.frame.maxX, y: 0)
                            self.suppImageView.transform = CGAffineTransform(translationX: translation.x, y: self.y)

                        })
                        
                        interactiveAnimator.pauseAnimation()
                    } else {
                        interactiveAnimator?.startAnimation()
                        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                            self.photoImageView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                            self.suppImageView.transform = CGAffineTransform(translationX: self.photoImageView.frame.maxX , y: self.y)
                        })
                        interactiveAnimator.pauseAnimation()
                    }
                }
            }
            
            if translation.x > 0 {
                if !isRightSwipePerform {
                    if index >= 0 {
                        performImageViewForRightSwipe()
                    }
               
                }
                if index >= 0 {
                    print("???????????? ???????????? ????????????")
                    if isSupImageFirst {
                        print("?????????? ???????????? ???????? ?????? ?????? ????????????")
                        interactiveAnimator?.startAnimation()
                        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                            self.photoImageView.transform = CGAffineTransform(translationX: self.suppImageView.frame.minX - self.photoImageView.frame.width, y: 0)
                            self.suppImageView.transform = CGAffineTransform(translationX: translation.x, y: self.y)

                        })
                        
                        interactiveAnimator.pauseAnimation()
                    } else {
                        print("?????????? ???????????? ???????? ?????? ?????? ????????????")
                        interactiveAnimator?.startAnimation()
                        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                            self.photoImageView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                            self.suppImageView.transform = CGAffineTransform(translationX: self.photoImageView.frame.minX -  self.suppImageView.frame.width, y: self.y)
                        })
                        interactiveAnimator.pauseAnimation()
                    }
                }
            }
        
        case .ended:
            let translation = recognizer.translation(in: self.view)
            print(translation.x)
            interactiveAnimator.fractionComplete = translation.x / -UIScreen.main.bounds.width
            if translation.x < 0 {
                print("LL \(index)")
                if index <= photos.count - 1 {
                    if -translation.x < UIScreen.main.bounds.width/1.3 {
                        goBack()
                    } else {
                        print(index)
                        leftSwipe()
                    }
                }
            }
            
            if translation.x > 0 {
                print("LL \(index)")
                if index >= 0 {
                    if translation.x < UIScreen.main.bounds.width/1.3 {
                        print("?????????? ???????????? ???? ??????")
                        goBack()
                    } else {
                        print("?????????? ???????????? ??????")
                        rightSwipe()

                    }
                }
            }
            isLeftSwipePerform = false
            isRightSwipePerform = false
            interactiveAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
    }
    
}
