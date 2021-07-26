//
//  TableViewController.swift
//  Lesson1B2
//
//  Created by user on 09.04.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import FirebaseAuth

class FriendListVC: UITableViewController {
    
    var resultFriends: Results<FriendItem>!
    var sortUsers = [String]()
    var userDict = [String: [String]]()
    var usersLetters = [String]()
    let service = VKService()
    let interactiveTransition = InteractiveTransitionClass()
    var token: NotificationToken?
    var sectionsAndRowsDict = [Int: [Int]]()
    let queue = OperationQueue()

    private var photoService: PhotoService?
    
    func fillUserArray() {
        DataStorage.shared.myFriendsArray.removeAll()
        for user in resultFriends {
            let data = (try? Data(contentsOf: URL(string: user.photo200_Orig)!))!
           
            let image = UIImage(data: data)
            
            let friend = User(name: "\(user.firstName) \(user.lastName)", age: 0, avatar: image, photoURL: URL(string: user.photo200_Orig)!, id: user.id)
            DataStorage.shared.myFriendsArray.append(friend)
        }
        
    }
    
    func sortingUsers() {
        sortUsers.removeAll()
        usersLetters.removeAll()
        var sortedFriendsArray = [User]()
        for user in DataStorage.shared.myFriendsArray {
            usersLetters.append(String(user.name.first!))
            sortUsers.append(user.name)
        }
        
        let unique = Array(Set(usersLetters))
        usersLetters = unique
        sortUsers = sortUsers.sorted(by: <)
        usersLetters = usersLetters.sorted(by: <)
    
        for sortUser in sortUsers  {
            for user in DataStorage.shared.myFriendsArray {
                if user.name == sortUser {
                    sortedFriendsArray.append(user)
                }
            }
        }
        DataStorage.shared.myFriendsArray = sortedFriendsArray
    }
    
    func createUsersDict() {
        userDict.removeAll()
        for user in sortUsers {
            // берем первую букву пользователя и наполняем словарь
            let firstLetterIndex = user.index(user.startIndex, offsetBy: 1)
            let userKey = String(user[ ..<firstLetterIndex])
            if var userValues = userDict[userKey] {
                userValues.append(user)
                userDict[userKey] = userValues
            } else {
                userDict[userKey] = [user]
            }
        }
    }
    
    func fillDictSectionsRows() {
        var section = -1
        var row = -1
        var rows = [Int]()
        
        let keyArr = userDict.keys.sorted(by: <)
        for key in keyArr {
            section += 1
            row = -1
            rows.removeAll()
            for _ in userDict[key]! {
                row += 1
                rows.append(row)
                sectionsAndRowsDict[section] = rows
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibFile = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "Friend")
        self.navigationController?.delegate = self
        
        let getDataOp = GetDataOperation()
        queue.addOperation(getDataOp)

        let parseDataOp = ParseDataOperation()
        parseDataOp.addDependency(getDataOp)
        queue.addOperation(parseDataOp)

        let saveDataOp = SaveDataToRealmOperation()
        saveDataOp.addDependency(parseDataOp)
        queue.addOperation(saveDataOp)
        
        let reloadTableOp = ReloadTableViewOperation(viewController: self)
        reloadTableOp.addDependency(saveDataOp) // Добавляем зависимость от ParseDataOperation

        // Порядок исполнения операций
        // GetDataOperation -> ParseDataOperation -> SaveDataToRealmOperation -> ReloadTableViewOperation
        

        OperationQueue.main.addOperation(reloadTableOp)
        
        self.photoService = PhotoService(container: PhotoService.Table(tableView: self.tableView))

    }
    
    func pairTableAndRealm() {
        let realm = try! Realm()
        print(realm.configuration.fileURL as Any)
        token = resultFriends.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            guard let rowSectionDict = self?.sectionsAndRowsDict else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                self?.friendsFillFunc()
                self?.fillDictSectionsRows()
                for section in rowSectionDict.keys.sorted(by: <) {
                    for row in rowSectionDict[section]! {
                        tableView.insertRows(at: insertions.map({ _ in IndexPath(row: row, section: section) }),
                                             with: .automatic)
                        tableView.deleteRows(at: deletions.map({ _ in IndexPath(row: row, section: section)}),
                                             with: .automatic)
                        tableView.reloadRows(at: modifications.map({ _ in IndexPath(row: row, section: section) }),
                                             with: .automatic)
                    }
                }
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    
    func friendsFillFunc() {
       
        fillUserArray()
        sortingUsers()
        createUsersDict()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return usersLetters.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return usersLetters[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        view.letter.text = usersLetters[section]
        view.sizeToFit()
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userKey = usersLetters[section]
        guard let userValues = userDict[userKey] else { return 0 }
        
        return userValues.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return usersLetters
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = usersLetters.firstIndex(of: title) else {return -1}
        return index
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as? UserTableViewCell
        
        let userKey = usersLetters[indexPath.section]
        if let userValues = userDict[userKey] {
            
            for user in DataStorage.shared.myFriendsArray {
                if user.name == userValues[indexPath.row] {
                    let image = photoService?.getPhoto(at: indexPath, url: user.photoURL)
                    
                    cell?.configure(text: userValues[indexPath.row], image: image ?? UIImage(named: "noAvatar"))
                }
            }
        }
        return cell!
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AvatarDetail")
            as? AvatarDetailVC {
            let userKey = usersLetters[indexPath.section]
            if let userValues = userDict[userKey] {
                for user in DataStorage.shared.myFriendsArray {
                    if user.name == userValues[indexPath.row] {
                        vc.id = user.id
                        vc.userName = user.name
                        UIView.animate(withDuration: 0.4, animations: {
                            cell?.avatarView.frame.origin.x += 250
                            cell?.avatarView.alpha = 0
                            cell?.titleLabel.alpha = 0
                            cell?.avatarView.layer.cornerRadius = 1
                            cell?.avatar.layer.cornerRadius = 1
                            cell?.backgroundColor = #colorLiteral(red: 0.589868784, green: 0.7395157218, blue: 1, alpha: 1)
                            
                        }, completion: {[weak self]_ in
                            guard let self = self else {return}
                            let image = user.avatar
                            vc.title = userValues[indexPath.row]
                            vc.avatar = image ?? UIImage(named: "noAvatar")!
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            UIView.animate(withDuration: 0.15, delay: 1, animations: {
                                cell?.avatarView.frame.origin.x -= 250
                                cell?.avatarView.alpha = 1
                                cell?.titleLabel.alpha = 1
                                cell?.avatarView.layer.cornerRadius = 28
                                cell?.avatar.layer.cornerRadius = 28
                                cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            })
                        })
                    }
                }
            }
        }
    }

    
}

extension FriendListVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
//            self.interactiveTransition.viewController = toVC
            return PushAnimation()
        }
        
        if operation == .pop {
//            if navigationController.viewControllers.first != toVC {
//                self.interactiveTransition.viewController = toVC
//            }
            
            return PopAnimation()
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isStarted ? interactiveTransition : nil
    }
}
