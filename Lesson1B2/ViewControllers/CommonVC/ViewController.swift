//
//  ViewController.swift
//  Lesson1B2
//
//  Created by user on 02.04.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var authButton: UIButton!
    
    @IBOutlet weak var cloudView: CloudView!
    
    var isAuth = false
    let tabBarSegue = "fromLogToTabBar"
    
    
    
    @IBOutlet weak var loadView1: UIView!
    
    @IBOutlet weak var loadView2: UIView!
    
    @IBOutlet weak var loadView3: UIView!
    
    
    let loadCloud = CloudView()
    let loadView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // для удобства
        login.text = "Nick"
        password.text = "None"
        password.isSecureTextEntry = true
       
       
        loadView.frame = authButton.frame
        loadView.backgroundColor = #colorLiteral(red: 0.229189992, green: 0.5978928804, blue: 0.861818254, alpha: 1)
        
        cloudView.backgroundColor = UIColor.clear
        
        
        
        cloudView.alpha = 0
    }

    
    func showAlert(text: String) {
        let ac = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Oк", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func auth(_ sender: Any) {
        
        guard let loginTxt = login.text,
              let passwordTxt = password.text else {return}
        
              
        if loginTxt.trimmingCharacters(in: .whitespacesAndNewlines) == "Nick" ,passwordTxt.trimmingCharacters(in: .whitespacesAndNewlines) == "None" {
         
            login.isEnabled = false
            password.isEnabled = false
            isAuth = true
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.cloudView.alpha = 1
                self.cloudView.start()
            }, completion: { [weak self] _ in
                guard let self = self else {return}
                UIView.animate(withDuration: 1, delay: 2, animations: {
                    self.cloudView.alpha = 0
                }, completion: {  _ in
                    self.performSegue(withIdentifier: self.tabBarSegue, sender: nil)
                })
            })
//            self.performSegue(withIdentifier: self.tabBarSegue, sender: nil)
        } else {
            if !isAuth {
                showAlert(text: "Неверный логин или пароль")
                return
            }
        }
    }
    
    
}

