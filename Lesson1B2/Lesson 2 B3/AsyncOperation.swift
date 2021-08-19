//
//  AsyncOperation.swift
//  Lesson1B2
//
//  Created by user on 18.07.2021.
//

import Foundation
import Alamofire
import RealmSwift

class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        /// Маленький хелпер, который возвращает состояния для KVO
        /// - Returns: `isReady` или `isExecuting` или `isFinished`
        fileprivate var keyPath: String {
            return "is" + self.rawValue.capitalized
        }
    }
    
    private var state: State = State.ready {
        // Уведомляем систему KVO, о том что у нас изменились состояния в операции
        
        // Вызывается в момент установки значений
        willSet {
            self.willChangeValue(forKey: self.state.keyPath)
            self.willChangeValue(forKey: newValue.keyPath)
        }
        
        // Вызывается после установки значений
        didSet {
            self.didChangeValue(forKey: self.state.keyPath)
            self.didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && self.state == .ready
    }
    
    override var isExecuting: Bool {
        return self.state == .executing
    }
    
    override var isFinished: Bool {
        return self.state == .finished
    }
    
    override func start() {
        if self.isCancelled {
            self.state = .finished
        } else {
            self.main()
            self.state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
    
    /// Set operation as finished
    /// - Tag: finished
    func finished() {
        self.state = .finished
    }
}

class GetDataOperation: AsyncOperation {
    let baseUrl = "https://api.vk.com"
    
    private var requestToken: DataRequest?
    
    private(set) var data: Data?
    
    override func cancel() {
        // Останавливаем запрос из сети, если операция отменена
        self.requestToken?.cancel()
        super.cancel()
    }

    override func main() {
        
        let path = "/method/friends.get"

        let parameters: Parameters = [
            "access_token" : Session.instance.token,
            "user_id" : Session.instance.userID,
            "order" : "hints",
            "count" : "20",
            "offset" : "0",
            "fields" : "photo_200_orig",
            "name_case" : "nom",
            "v" : "5.131",
            
            "lang" : "en"
         ]

        let url = baseUrl+path
       
        self.requestToken = AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            self.data = data
            self.finished()
            
         }
        
        // Делаем запрос
        self.requestToken?.resume()
    }
    
}

class ParseDataOperation: Operation {
    
    private(set) var friends: [FriendItem]?
    
    override func main() {
        // Если нет зависимости GetDataOperation, то нужно закочнить исполнение
        guard let operation = self.dependencies.first as? GetDataOperation,
              let data = operation.data
        else {
            return
        }
        
        let friends = try? JSONDecoder().decode(Friends.self, from: data)
        self.friends = friends?.response.items ?? []
        
    }
}

class SaveDataToRealmOperation: Operation {
    
    override func main() {
        // Если нет зависимости GetDataOperation, то нужно закочнить исполнение
        guard let operation = self.dependencies.first as? ParseDataOperation,
              let resultFriends = operation.friends
        else {
            return
        }
        
        saveFriendsData(resultFriends)
    }
    
    func saveFriendsData(_ friends: [FriendItem]) {
        do {
            // получаем доступ к хранилищу
            let realm = try Realm()
            // все старые  данные для текущего списка друзей
            let oldFriends = realm.objects(FriendItem.self)
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(oldFriends)
            // кладем все объекты класса друзья в хранилище
            realm.add(friends)
            // завершаем изменение хранилища
            try realm.commitWrite()

        } catch {
            print(error)
        }
    }
}

class ReloadTableViewOperation: Operation {
    
    unowned let viewController: FriendListVC
    let realm = try! Realm()
    
    private let friendsAdapter = FriendsAdapter()
    
    init(viewController: FriendListVC) {
        self.viewController = viewController
        super.init()
    }
    
    override func main() {
        guard (self.dependencies.first as? SaveDataToRealmOperation) != nil else { return }
        
        friendsAdapter.getFriends {  friends in
            self.viewController.friends = friends
            self.viewController.friendsFillFunc()
            self.viewController.fillDictSectionsRows()
            self.viewController.tableView.reloadData()
            
        }
        
        
    }
    
}


