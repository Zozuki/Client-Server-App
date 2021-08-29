//
//  AlbumsListVC.swift
//  Lesson1B2
//
//  Created by user on 08.08.2021.
//

import Foundation
import AsyncDisplayKit

class AlbumsListTableVC: ASDKViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    private let vkService: VKService
    private let vkServiceCachingProxy: VKServiceCachingProxy
    private var items: [Item] = []
    var id = Int()
    
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(onRefreshTriggered(_:)), for: .valueChanged)
        return control
    }()
    
    
    init(vkService: VKService) {
        self.vkService = vkService
        self.vkServiceCachingProxy = VKServiceCachingProxy(base: vkService)
        super.init(node: ASTableNode())
        self.node.delegate = self
        self.node.dataSource = self
        self.node.allowsSelection = false
        self.node.view.refreshControl = self.refreshControl
        self.node.allowsSelection = true
        self.getData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    @objc func onRefreshTriggered(_ control: UIRefreshControl) {
        self.getData()
    }
    
    private func getData() {
        vkServiceCachingProxy.getAlbumsList(id: id) { [unowned self] items in
            self.items = items
            self.refreshControl.endRefreshing()
            self.node.reloadData()
        }
    }
    
    
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
//    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let item = self.items[indexPath.row]
//
//        return { AlbumListTableCell(resource: item) }
//
//    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let item = self.items[indexPath.row]

        return AlbumListTableCell(resource: item)
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 305, height: 355)
        let photoVC = PhotoVC(collectionViewLayout:  layout)
        photoVC.modalPresentationStyle = .fullScreen
        photoVC.id = id
        photoVC.photoAlbumID = items[indexPath.row].id
        photoVC.viewDidLayoutSubviews()
        navigationController?.pushViewController(photoVC, animated: true)
//
//        let vc = storyboard?.instantiateViewController(identifier: "Photo")
//            as! PhotoVC
//        vc.id = id
//        vc.photoAlbumID = items[indexPath.row].id
//        navigationController?.pushViewController(vc, animated: true)
        
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Photo")
//            as? PhotoVC {
//            vc.id = id
//            vc.photoAlbumID = items[indexPath.row].id
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
}



