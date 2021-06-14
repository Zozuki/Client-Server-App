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
    }
    
    var key = 0
    var viewing = [Int:Int]()
    var liked = [Int:Bool]()
    var views = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillTheNews()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        for _ in DataStorage.shared.news {
            viewing[key] = 0
            liked[key] = false
            key += 1
        }
        
        let nibFile = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "News")
        
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.news.count
    }

  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "News") as! NewsTableViewCell
        
        views += 1
        if views < 3 {
            viewing[indexPath.row]! += 1
        }
        
        cell.configure(
            
            sorsName: DataStorage.shared.news[indexPath.row].source.name,
            newText: DataStorage.shared.news[indexPath.row].text,
            sorsImage: DataStorage.shared.news[indexPath.row].source.image,
            newImage: DataStorage.shared.news[indexPath.row].image)
        cell.viewingLabel.text = "\(viewing[indexPath.row]!)"
        viewing[indexPath.row]! += 1
//        liked[indexPath.row]! = cell.isLiked
//        cell.isLiked = false
        return cell
        
    }
    

}
