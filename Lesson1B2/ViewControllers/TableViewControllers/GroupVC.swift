//
//  GroupVC.swift
//  Lesson1B2
//
//  Created by user on 10.04.2021.
//

import UIKit
import RealmSwift


class GroupVC: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var loupeButtonView: UIView!
    @IBOutlet weak var loupeButtonConstarint: NSLayoutConstraint!
    @IBOutlet weak var loupeButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var trailingTxtSearchBarConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtSearchBar: UITextField!
    
    var resultGroups: Results<GroupItem>!
    var filteredGroups = [Group]()
    let service = VKService()
    var token: NotificationToken?
    

    
    func fillGroups() {
        DataStorage.shared.myGroups.removeAll()
        for groupItem in resultGroups {
            let data = (try? Data(contentsOf: URL(string: groupItem.photo200)!))!
            let image = UIImage(data: data)
            let group = Group(name: groupItem.name, image: image)
            DataStorage.shared.myGroups.append(group)
        }
        filteredGroups = DataStorage.shared.myGroups
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearchBar.delegate = self
        txtSearchBar.isEnabled = false
        let nibFile = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "Friend")
        getData()
    }
    
    func getData() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        service.getGroupData()
            .get { [unowned self] groups in
                service.saveGroupsData(groups)
                let realm = try! Realm()
                self.resultGroups = realm.objects(GroupItem.self)
                self.pairTableAndRealm()
                self.fillGroups()
                self.tableView.reloadData()
            }
            .done(on: .main) { groups in
        
            }
            .catch { error in
                self.showError(error)
            }
            .finally {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
    
    }
    
    private func showError(_ error: Error) {
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }
    
    func pairTableAndRealm() {
        let realm = try! Realm()
        
        print(realm.configuration.fileURL as Any)
        token = resultGroups.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                self?.fillGroups()
                self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                                    with: .automatic)
                self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                                    with: .automatic)
                self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                    with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as? UserTableViewCell
        cell?.configure(text: DataStorage.shared.myGroups[indexPath.row].name, image: DataStorage.shared.myGroups[indexPath.row].image ?? UIImage(named: "noAvatar"))
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AvatarDetail")
            as? AvatarDetailVC {
            vc.title = DataStorage.shared.myGroups[indexPath.row].name
            var photos = [UIImage]()
            photos.append((DataStorage.shared.myGroups[indexPath.row].image ?? UIImage(named: "noAvatar"))!)
            vc.avatar = DataStorage.shared.myGroups[indexPath.row].image ?? UIImage(named: "noAvatar")!
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
  
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            DataStorage.shared.allGroups.append(DataStorage.shared.myGroups[indexPath.row])
            filteredGroups.remove(at: indexPath.row)
            DataStorage.shared.myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            tableView.endUpdates()
        }
    }
    
    //MARK: Txt Search bar config
    
    @IBAction func loupeButtonTapped(_ sender: Any) {
        self.txtSearchBar.isEnabled = true
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.txtSearchBar.isEnabled = true
            self.trailingTxtSearchBarConstraint.constant = 70
            self.loupeButtonConstarint.constant = 4
        }, completion: {_ in
            self.txtSearchBar.isEnabled = true
        })
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        txtSearchBar.text = ""
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.trailingTxtSearchBarConstraint.constant = 0
            self.loupeButtonConstarint.constant = 200
        }, completion: {_ in
            self.txtSearchBar.isEnabled = false
        })
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        trailingTxtSearchBarConstraint.constant = 70
        if txtSearchBar.text?.count != 0 {
            DataStorage.shared.myGroups.removeAll()
            for str in filteredGroups {
                let range = str.name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    DataStorage.shared.myGroups.append(str)
                }
            }
        } else {
            DataStorage.shared.myGroups.removeAll()
            DataStorage.shared.myGroups = filteredGroups
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        txtSearchBar.resignFirstResponder()
        txtSearchBar.text = ""
        trailingTxtSearchBarConstraint.constant = 0
        DataStorage.shared.myGroups.removeAll()
        DataStorage.shared.myGroups = filteredGroups
        tableView.reloadData()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtSearchBar.text?.count != 0 {
            DataStorage.shared.myGroups.removeAll()
            for str in filteredGroups {
                let range = str.name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    DataStorage.shared.myGroups.append(str)
                }
            }
        } else {
            DataStorage.shared.myGroups.removeAll()
            DataStorage.shared.myGroups = filteredGroups
            tableView.reloadData()
        }
        tableView.reloadData()
        return true
    }
    

}
