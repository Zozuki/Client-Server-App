//
//  VKService.swift
//  Lesson1B2
//
//  Created by user on 26.05.2021.
//

import UIKit
import Alamofire

class VKService {

    let baseUrl = "https://api.vk.com"
     
    func getFriendList() {
        
        let path = "/method/friends.get"
    
        let parameters: Parameters = [
            "user_id" : Session.instance.userID,
            "order" : "hints",
            "count" : "3",
            "offset" : "0",
            "fields" : "nickname",
            "name_case" : "nom",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         
         AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            print("\n______________________Друзья_________________________\n")
            print(repsonse.value as Any)
         }
     }
    
    
    func getPhotosAlbum() {
        
        let path = "/method/photos.get"
    
        let parameters: Parameters = [
            "owner_id" : Session.instance.userID,
            "album_id" : "profile",
            "rev" : "0",
            "extended" : "1",
            "count" : "3",
            "feed_type" : "photo",
            "photo_sizes" : "0",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         
         AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            print("\n_____________Фотографии из основного альбома______________\n")
            print(repsonse.value as Any)
         }
    }
    
    
    func getGroupsList() {
        
        let path = "/method/groups.get"
    
        let parameters: Parameters = [
            "user_id" : Session.instance.userID,
            "count" : "3",
            "extended" : "1",
            "fields" : "members_count",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         
         AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            print("\n______________________Группы______________________\n")
            print(repsonse.value as Any)
         }
    }
    
    
    func getSearchGroup(groupID: String) {
        let path = "/method/groups.getById"
    
        let parameters: Parameters = [
            "group_id" : groupID,
            "fields" : "members_count",
            "count" : "1",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         
         AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            print("\n____________________Искомая группа_____________________\n")
            print(repsonse.value as Any)
         }
    }

}
