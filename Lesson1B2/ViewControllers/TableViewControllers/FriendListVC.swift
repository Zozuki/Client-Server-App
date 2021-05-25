//
//  TableViewController.swift
//  Lesson1B2
//
//  Created by user on 09.04.2021.
//

import UIKit

class FriendListVC: UITableViewController {

    func fillUserArray() {
        
        
        var sortedFriendsArray = [User]()
        let photos = [UIImage(named:"Тимофей")!, UIImage(named:"Никита")!, UIImage(named:"СашаР")!,UIImage(named:"Алина")!, UIImage(named: "Коля")!]
       
        let user1 = User(name: "Унтевский Коля", age: 20, avatar: UIImage(named: "Коля")!, photos: photos)
        
        let user2 = User(name: "Попов Тимофей", age: 0, avatar: UIImage(named:"Тимофей")!, photos: photos)
        
        let user3 = User(name: "Головкин Александр", age: 0, avatar: UIImage(named:"СашаГ")!, photos: photos)
        
        let user4 = User(name: "Верзун Никита", age: 0, avatar: UIImage(named:"Никита")!, photos: photos)
        
        let user5 = User(name: "Кантемиров Алибек", age: 0, avatar: UIImage(named:"Алибек")!, photos: photos)
        
        let user6 = User(name: "Рыжков Саша", age: 0, avatar: UIImage(named:"СашаР")!, photos: photos)
        
        let user7 = User(name: "Апурин Артем", age: 0, avatar: nil, photos: photos)
        
        let user8 = User(name: "Кудряшова Алина", age: 0, avatar: UIImage(named:"Алина")!, photos: photos)
        
        let user9 = User(name: "Чумакова Лера", age: 0, avatar: nil, photos: photos)
        
        let user10 = User(name: "Унтевский Егор", age: 0, avatar: nil, photos: photos)
        
        let user11 = User(name: "Щекинов Ваня", age: 0, avatar: nil, photos: photos)
        
        DataStorage.shared.myFriendsArray.append(contentsOf: [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11])
        
        // cортирую по алфавиту
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
    
    var sortUsers = [String]()
    var userDict = [String: [String]]()
    var usersLetters = [String]()
    
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
    
    
    let interactiveTransition = InteractiveTransitionClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibFile = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "Friend")
        
        self.navigationController?.delegate = self
//        interactiveTransition.friendListVC = self
        fillUserArray()
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
                            vc.photos = user.photos
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
