//
//  NewsTableViewController.swift
//  Lesson1B2
//
//  Created by user on 22.04.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {

    
    func fillTheNews() {
        let new1 = News(source: DataStorage.shared.myGroups[4], text: "Новая модель Nike", image: UIImage(named: "Nike"))
        let new2 = News(source: DataStorage.shared.myGroups[5], text: "", image: UIImage(named: "MisbhvNew2"))
        let new3 = News(source: DataStorage.shared.myGroups[3], text: "", image: UIImage(named: "smokeNew"))
        let new4 = News(source: DataStorage.shared.myGroups[0], text: "ВКР достала", image: UIImage(named: "СашаГ"))
        let new5 = News(source: DataStorage.shared.myGroups[4], text: "Арт-группа Instigators и художник Николай Кошелев запустили NFT-акцию «Экспортировано из музея» В основу акции легли работы с выставки Николая Кошелева в Третьяковской галерее. Художник переработал два произведения и создал восемь NFT. Instigators разместили токены на Rarible. 21 апреля пользователь платформы купил один из лотов за 1,01 WETH ($2480). На момент публикации за NFT предлагают от 0,003 WETH ($7) до 0,5 WETH ($1230). Торги продлятся до 25 апреля. Вырученные средства пойдут на новые проекты арт-группы и художника.«Потенциал блокчейна колоссален и может изменить привычный ход вещей на арт-рынке. Наша акция позволяет приобрести работы, экспортированные из физической реальности музейного пространства в цифровой мир», — комментирует основатель Instigators Денис Давыдов.", image: UIImage(named:"theMarketNew"))
        let new6 = News(source: DataStorage.shared.myGroups[1], text: "", image: UIImage(named: "Никита"))
        DataStorage.shared.news.append(contentsOf: [new5, new2, new4, new6, new1, new3])
//        DataStorage.shared.news.append(contentsOf: [new5])
    }
    
    var key = 0
    var viewing = [Int:Int]()
    var liked = [Int:Bool]()
    var views = 0
    var newsTextHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillTheNews()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibFile1 = UINib(nibName: "NewsSourceCell", bundle: nil)
        tableView.register(nibFile1, forCellReuseIdentifier: "NewsSourceCell")
        let nibFile2 = UINib(nibName: "NewsTextCell", bundle: nil)
        tableView.register(nibFile2, forCellReuseIdentifier: "NewsTextCell")
        let nibFile3 = UINib(nibName: "NewsImageCell", bundle: nil)
        tableView.register(nibFile3, forCellReuseIdentifier: "NewsImageCell")
        let nibFile4 = UINib(nibName: "NewsLikesSharingCell", bundle: nil)
        tableView.register(nibFile4, forCellReuseIdentifier: "NewsLikesSharingCell")
        self.tableView.register(NewsImageTableViewCell.self, forCellReuseIdentifier: "NewsImageTableViewCell")
        
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return DataStorage.shared.news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        switch indexPath.row {
        case 0:
            let newsSourceCell = tableView.dequeueReusableCell(withIdentifier: "NewsSourceCell", for: indexPath) as! NewsSourceCell
            newsSourceCell.configure(sorsName: DataStorage.shared.news[indexPath.section].source.name, sorsImage: DataStorage.shared.news[indexPath.section].source.image)
            return newsSourceCell
        case 1:
            let newsTextCell = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell", for: indexPath) as! NewsTextCell
            newsTextCell.configure(newText: DataStorage.shared.news[indexPath.section].text)
            return newsTextCell
        case 2:
            let newsImageCell = tableView.dequeueReusableCell(withIdentifier: "NewsImageTableViewCell", for: indexPath) as! NewsImageTableViewCell
            newsImageCell.configure(newImage: DataStorage.shared.news[indexPath.section].image)
            return newsImageCell
        case 3:
            let newsLikesSharingCell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesSharingCell", for: indexPath) as! NewsLikesSharingCell
            return newsLikesSharingCell
        default:
            let newsLikesSharingCell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesSharingCell", for: indexPath) as! NewsLikesSharingCell
            return newsLikesSharingCell
        }

    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:

            return self.tableView.rowHeight
        case 1:
            let newsText = DataStorage.shared.news[indexPath.section].text
            if newsText != "" {
                return self.tableView.rowHeight
            } else {
                return 0
            }
        case 2:
            
            guard let currentImage =  DataStorage.shared.news[indexPath.section].image else { return 0 }
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
