//
//  AuthViewController.swift
//  Lesson1B2
//
//  Created by user on 25.05.2021.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    let service = VKService()

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    

    override func viewWillAppear(_ animated: Bool) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7870483"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        let ID = params["user_id"]
        
        guard let guardToken = token else { return }
        guard let guardID = ID else { return }
        
        Session.instance.token = guardToken
        Session.instance.userID = guardID
        print("Токен получен: \( Session.instance.token)")
//            service.getFriendList()
        
//        service.getGroupsList()
//            service.getPhotosAlbum(id:"")
        // Возвращает информацию о заданном сообществе
//            service.getSearchGroup(groupID: "189089786")
       
  
        decisionHandler(.cancel)
        
        goToFriendList()
    }
    
    
    func goToFriendList() {
        performSegue(withIdentifier: "fromServiceToTabBar", sender: nil)
    }
    
}

