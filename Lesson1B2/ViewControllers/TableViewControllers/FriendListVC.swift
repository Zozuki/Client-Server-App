//
//  TableViewController.swift
//  Lesson1B2
//
//  Created by user on 09.04.2021.
//

import UIKit
import RealmSwift

class FriendListVC: UITableViewController {
    
    var friends = [FriendItem]()
    var sortUsers = [String]()
    var userDict = [String: [String]]()
    var usersLetters = [String]()
    let service = VKService()
    let interactiveTransition = InteractiveTransitionClass()
    
    
    func fillUserArray(friends: [FriendItem]) {
        for user in friends {
            let data = (try? Data(contentsOf: URL(string: user.photo200_Orig)!))!
            let image = UIImage(data: data)
            let friend = User(name: "\(user.firstName) \(user.lastName)", age: 0, avatar: image, photos: nil, id: user.id)
            DataStorage.shared.myFriendsArray.append(friend)
        }
        
    }
    
    func sortingUsers() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibFile = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "Friend")
        self.navigationController?.delegate = self
        loadFriendsFromRealm()
        tableView.reloadData()
        service.getFriendList() { [weak self]  in
            DispatchQueue.main.async {
                self?.loadFriendsFromRealm()
            }
        }
        friendsFillFunc()
    }
    
    func loadFriendsFromRealm()  {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            let friendsArray = realm.objects(FriendItem.self)
            friends =  Array(friendsArray)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func friendsFillFunc() {
        fillUserArray(friends: friends)
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
                    let image = user.avatar
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
