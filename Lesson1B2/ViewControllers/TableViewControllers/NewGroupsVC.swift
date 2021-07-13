//
//  NewGroupsVC.swift
//  Lesson1B2
//
//  Created by user on 10.04.2021.
//

import UIKit

class NewGroupsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibFile = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "Friend")
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.allGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as? UserTableViewCell

        return cell!
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Photo")
            as? PhotoVC {
           
            vc.title = DataStorage.shared.allGroups[indexPath.row].name
            let photos = [UIImage]()
            vc.photos = photos
            navigationController?.pushViewController(vc, animated: true)

        }
        
    }
   
    private func add(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
    
        let action = UIContextualAction(style: .normal, title: "Add") { [weak self] (_, _, _) in
            guard let self = self else {return}
            DataStorage.shared.myGroups.append(DataStorage.shared.allGroups[indexPath.row])
            DataStorage.shared.allGroups.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        action.backgroundColor = #colorLiteral(red: 0.02979851887, green: 0.9596107602, blue: 0.3591127694, alpha: 1)
        return action
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = self.add(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [add])
        
        return swipe
    }
    
   
    

    
}
