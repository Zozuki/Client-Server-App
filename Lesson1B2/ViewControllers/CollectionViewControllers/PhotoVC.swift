//
//  FriendinfoVC.swift
//  Lesson1B2
//
//  Created by user on 09.04.2021.
//

import UIKit



class PhotoVC: UICollectionViewController {

    var photoItems = [PhotoItem]()
    var photos = [UIImage]()
    let interactiveTransition = InteractiveTransitionClass()
    let service = VKService()
    var id = Int()
    
    func fillPhotoAlbum() {
        if photoItems.count != 0 {
            for photo in photoItems{
                let data = (try? Data(contentsOf: URL(string: photo.sizes[4].url)!))!
                guard let image = UIImage(data: data) else { return }
                photos.append(image)
            }
        } else {
            photos.append(UIImage(named: "noAvatar")!)
        }
         
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        interactiveTransition.viewController = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        service.getPhotosAlbum(id: id) { [weak self] photos in
            self?.photoItems = photos
            self?.fillPhotoAlbum()
            self?.collectionView.reloadData()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2, animations: {
            
        })
    }
    

    @objc func reload() {
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            fatalError("Unable to dequeue PhotoCell.")
        }
        cell.photoView.image = photos[indexPath.row] 
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let pi = CGFloat.pi
        let rotation = CATransform3DMakeRotation((90.0*pi)/180, 0, 0.5, 0.5)
        cell.contentView.alpha = 0.05;
        cell.contentView.layer.transform = rotation
        cell.contentView.layer.anchorPoint = CGPoint(x: 0, y: 0.1);
        cell.layer.anchorPoint = CGPoint(x: 0.7, y: 0)
        
        UIView.animate(withDuration: 0.7, animations: {
            cell.contentView.layer.transform = CATransform3DIdentity
            cell.contentView.alpha = 1
            cell.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            cell.contentView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        })
        
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
//            fatalError("Unable to dequeue PhotoCell.")
//        }
//
//        UIView.animate(withDuration: 2, animations: {
//            print("anime \(String(describing: cell.photoView.layer.cornerRadius))")
//            cell.imageTapped()
//            print("anime \(String(describing: cell.photoView.layer.cornerRadius))")
//        })
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CustomGallery")
            as? CustomGalleryVC {
            vc.photos = photos ?? [UIImage(named: "noAvatar")!]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

   

}
