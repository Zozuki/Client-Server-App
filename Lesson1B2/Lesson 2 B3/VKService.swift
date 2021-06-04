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
    
    
    func getFriendList(completion: @escaping ([FriendItem]) -> Void) {
        
        let path = "/method/friends.get"
    
        let parameters: Parameters = [
            "access_token" : Session.instance.token,
            "user_id" : Session.instance.userID,
            "order" : "hints",
            "count" : "30",
            "offset" : "1",
            "fields" : "photo_200_orig",
            "name_case" : "nom",
            "v" : "5.131",
            
            "lang" : "en"
         ]

         let url = baseUrl+path
    
        AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            guard let friend = try? JSONDecoder().decode(Friends.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(friend.response.items)
            }
//            Session.instance.friends = friend.response.items
            
         }
     }
    
    
    func getPhotosAlbum(id: Int, completion: @escaping ([PhotoItem]) -> Void) {
        
        let path = "/method/photos.get"
    
        let parameters: Parameters = [
            "owner_id" : "\(id)",
            "album_id" : "profile",
            "rev" : "1",
            "extended" : "1",
            "count" : "5",
            "feed_type" : "photo",
            "photo_sizes" : "0",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         

        AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            guard let photo = try? JSONDecoder().decode(PhotoAlbum.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(photo.response.items)
            }
        }
        
    }
    
    
    func getGroupsList(completion: @escaping ([GroupItem]) -> Void) {
        
        let path = "/method/groups.get"
    
        let parameters: Parameters = [
            "user_id" : Session.instance.userID,
            "count" : "10",
            "extended" : "1",
            "fields" : "members_count",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         
        AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            guard let group = try? JSONDecoder().decode(Groups.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(group.response.items)
            }
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
         
         AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let prettyData = data.prettyJSON! as String
//            print(prettyData)
            let new = prettyData.data(using: .utf8)!
            
            print(new)
            
            guard let group = try? JSONDecoder().decode(Groups.self, from: new) else {
                print("fail______________")
                return
            }
            
        
            
         }
    }

}
