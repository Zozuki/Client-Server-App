//
//  NewsTableViewController.swift
//  Lesson1B2
//
//  Created by user on 22.04.2021.
//

import UIKit

class NewsTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({$0.section}).max() else { return }
        print(maxSection, newsPhotos.count)
        
        if maxSection + 1  >  newsPhotos.count - 1 {
            if !self.isInfinityScrollDataLoading {
                self.isInfinityScrollDataLoading = true
                service.getUserPostNews(nextFrom: nextFrom, completion: { [unowned self] photoItem, group, profile, nextFrom   in
                    
                    let indexSet = IndexSet(integersIn: self.newsPhotos.count ..< self.newsPhotos.count + photoItem.count)
                    self.buildNews(photoItems: photoItem, groups: group, profile: profile)
                    
                    self.tableView.insertSections(indexSet, with: .none)
                    self.nextFrom = nextFrom
                    
                    
                    self.isInfinityScrollDataLoading = false
                })
                
            }
        }
        
    }
    
    var isInfinityScrollDataLoading = false
    
    var nextFrom = String()
    
    var key = 0
   
    var newsTextHeight = CGFloat()
    let service = VKService()
    
    var newsText = [String]()
    var newsPhotos = [UIImage?]()
    var newsGroup = [NewsGroup]()
    
    var indexPath = [IndexPath]()
    var textCell = UITableViewCell()
    var numOfSect = 0
    
    func buildNews(photoItems: [NewsPostItem], groups: [NewsPostGroup], profile: [NewsPostProfile]) {
        numOfSect += 5
        for group in groups {
            let data = try? Data(contentsOf: URL(string: (group.photo200))!)
            let image = UIImage(data: data!)
            let group = NewsGroup(name: group.name, image: image)
            newsGroup.append(group)
        }
        
        for image in photoItems {     
            newsText.append(image.text)
            guard let attch = image.attachments else { newsPhotos.append(nil);  return }
            guard let firstAttch = attch.first else { newsPhotos.append(nil);  return   }
            guard let firstAttchPhoto = firstAttch.photo else { newsPhotos.append(nil);  return   }
            let firstAttchPhotoSizes = firstAttchPhoto.sizes[4] 
            guard let url = URL(string: (firstAttchPhotoSizes.url)) else { newsPhotos.append(nil);  return   }
            guard let data = try? Data(contentsOf: url) else { newsPhotos.append(nil);  return    }
            guard  let image = UIImage(data: data) else { newsPhotos.append(nil);  return   }
            newsPhotos.append(image)
        }
    }
    
    @objc private func onRefreshRteggered(_ sender: UIRefreshControl) {
        service.getUserPostNews(nextFrom: nextFrom, completion: { [unowned self] photoItem, group, profile, nextFrom   in
            self.nextFrom = nextFrom
            self.buildNews(photoItems: photoItem, groups: group, profile: profile)
            sender.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefreshRteggered), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновляем новости")
        refreshControl.tintColor = #colorLiteral(red: 0.3713435531, green: 0.7478653193, blue: 0.9012342691, alpha: 1)
        tableView.refreshControl = refreshControl
        
        service.getUserPostNews(nextFrom: "", completion: { [unowned self] photoItem, group, profile, nextFrom   in
            self.buildNews(photoItems: photoItem, groups: group, profile: profile)
            self.nextFrom = nextFrom
            self.tableView.reloadData()
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibFile1 = UINib(nibName: "NewsSourceCell", bundle: nil)
        tableView.register(nibFile1, forCellReuseIdentifier: "NewsSourceCell")
        let nibFile2 = UINib(nibName: "NewsTextCell", bundle: nil)
        tableView.register(nibFile2, forCellReuseIdentifier: "NewsTextCell")
        
        let nibFile4 = UINib(nibName: "NewsLikesSharingCell", bundle: nil)
        tableView.register(nibFile4, forCellReuseIdentifier: "NewsLikesSharingCell")
        self.tableView.register(NewsImageTableViewCell.self, forCellReuseIdentifier: "NewsImageTableViewCell")
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numOfSect
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let newsSourceCell = tableView.dequeueReusableCell(withIdentifier: "NewsSourceCell", for: indexPath) as! NewsSourceCell
            
            newsSourceCell.configure(sorsName: newsGroup.randomElement()?.name, sorsImage: newsGroup.randomElement()?.image)
           
            return newsSourceCell
        case 1:
            let newsTextCell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell

            newsTextCell.configure(newText: newsText[indexPath.section])
            newsTextCell.showMoreLessButton.addTarget(self, action: #selector(resizeTextCell), for: .touchUpInside)
            
                self.indexPath = [indexPath]
            
            return newsTextCell

        case 2:
            let newsImageCell = tableView.dequeueReusableCell(withIdentifier: "NewsImageTableViewCell", for: indexPath) as! NewsImageTableViewCell
            newsImageCell.configure(newImage: newsPhotos[indexPath.section])
            return newsImageCell
        case 3:
            let newsLikesSharingCell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesSharingCell", for: indexPath) as! NewsLikesSharingCell
            return newsLikesSharingCell
        default:
            let newsLikesSharingCell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesSharingCell", for: indexPath) as! NewsLikesSharingCell
            return newsLikesSharingCell
        }

    }
    
    @objc func resizeTextCell() {
        tableView.reloadRows(at: indexPath, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return self.tableView.rowHeight
        case 1:
//            let label = UILabel()
            
            let newsText = newsText[indexPath.section]
//            label.text = newsText
//            return getLabelSize(label:  label, text:  label.text!, font: label.font).height
//
            if newsText.isEmpty  {
                return 0
            } else {
                return self.tableView.rowHeight
            }
        case 2:
            
            guard let currentImage = newsPhotos[indexPath.section] else {return 0}
            let imageRatio = currentImage.getImageRatio()
            return tableView.frame.width / imageRatio
        case 3:

            return self.tableView.rowHeight
        default:
            return 0
        }

    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
