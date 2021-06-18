//
//  FriendinfoVC.swift
//  Lesson1B2
//
//  Created by user on 09.04.2021.
//

import UIKit
import RealmSwift


class PhotoVC: UICollectionViewController {

//    var photoItems = [PhotoItem]()
    var photos = [UIImage]()
    let interactiveTransition = InteractiveTransitionClass()
    let service = VKService()
    var id = Int()
    var token: NotificationToken?
    var photosArray: Results<PhotoItem>!
    
    
    func fillPhotoAlbum() {
        if photosArray.count != 0 {
            photos.removeAll()
            for photo in photosArray {
                print(photo.id)
                guard let data = try? Data(contentsOf: URL(string: (photo.sizes[4].url))!) else { return }
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
        service.getPhotosAlbum(id: id)
        pairCollectionAndRealm()
        fillPhotoAlbum()
    }
    
    func pairCollectionAndRealm() {
        guard let realm = try? Realm() else { return }
               
        photosArray = realm.objects(PhotoItem.self).filter("ownerID == %@", id)
        print(photosArray.count)
       token = photosArray.observe { [weak self] (changes: RealmCollectionChange) in
           guard let collectionView = self?.collectionView else { return }
           switch changes {
           case .initial:
               collectionView.reloadData()
           case .update(_, let deletions, let insertions, let modifications):
               collectionView.performBatchUpdates({
                self?.fillPhotoAlbum()
                   collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                   collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                   collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
               }, completion: nil)
           case .error(let error):
               fatalError("\(error)")
           }
       }

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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CustomGallery")
            as? CustomGalleryVC {
            vc.photos = photos 
            navigationController?.pushViewController(vc, animated: true)
        }
    }

   

}
