//
//  VKService.swift
//  Lesson1B2
//
//  Created by user on 26.05.2021.
//

import UIKit
import Alamofire
import RealmSwift
import FirebaseFirestore

class VKService {

    let baseUrl = "https://api.vk.com"
   
    func clear() {
        do {
            let realm = try Realm()
            try realm.write{
                realm.deleteAll()
            }
        } catch  {
            print(error)
        }
    }
    
    func getFriendList() {
        
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
    
        AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            guard let friend = try? JSONDecoder().decode(Friends.self, from: data) else { return }
            
            self.saveFriendsData(friend.response.items)
            for user in friend.response.items {
                self.saveFriendsToFirestore([user], friendName: user.firstName)
            }
         }
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

//            let realm = try Realm()
//            print(realm.configuration.fileURL)
//            try realm.write() {
//                realm.add(friends)
//            }
        } catch {
            print(error)
        }
    }
    
    private func saveFriendsToFirestore(_ users: [FriendItem], friendName: String) {
        let database = Firestore.firestore()
        let usersToSend = users
            .map { $0.toFirestore() }
            .reduce([:]) { $0.merging($1) { (current, _) in current } }
        database.collection("users").document(friendName).setData(usersToSend, merge: true) { error in
        if let error = error {
            print(error.localizedDescription)
            } else { print("data saved")}
        }
    }

    func getPhotosAlbum(id: Int) {
        
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
            DispatchQueue.main.async { [weak self] in
                if photo.response.items.count != 0 {
                    self?.savePhotosData(photo.response.items, id: photo.response.items[0].ownerID)
                }
            }
        }
        
    }
    
    func savePhotosData(_ photos: [PhotoItem], id: Int) {
        // обработка исключений при работе с хранилищем
        do {
            let realm = try Realm()
            // все старые  данные для текущего списка друзей
            let oldPhoto = realm.objects(PhotoItem.self).filter("ownerID == %@", id)
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            for photo in oldPhoto {
                realm.delete(photo.sizes)
            }
            realm.delete(oldPhoto)
            // кладем все объекты класса фото в хранилище
            realm.add(photos)
            // завершаем изменение хранилища
            try realm.commitWrite()
            
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
        }
    }
    
    func getGroupsList() {
        
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
            DispatchQueue.main.async { [weak self] in
                self?.saveGroupsData(group.response.items)
            }
        }
    }
    
    
    func saveGroupsData(_ groups: [GroupItem]) {
        do {
            let realm = try Realm()
            // все старые  данные для текущего списка друзей
            let oldGroups = realm.objects(GroupItem.self)
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(oldGroups)
            // кладем все объекты класса друзья в хранилище
            realm.add(groups)
            // завершаем изменение хранилища
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getUserGroup(id: Int, ownerName: String) {
        
        let path = "/method/groups.get"
    
        let parameters: Parameters = [
            "user_id" : "\(id)",
            "count" : "10",
            "extended" : "1",
            "fields" : "members_count",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
         
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] repsonse in
            guard let data = repsonse.value else { return }
            guard let groups = try? JSONDecoder().decode(Groups.self, from: data) else { return }
            print(groups.response.items.count)
            for group in groups.response.items {
                self?.saveGroupsToFirestore([group], groupName: group.name, ownerName: ownerName)
            }
            
         }
    }
    
    private func saveGroupsToFirestore(_ groups: [GroupItem], groupName: String, ownerName: String) {
        let database = Firestore.firestore()
        let groupsToSend = groups
            .map { $0.toFirestore(owner: groupName) }
            .reduce([:]) { $0.merging($1) { (current, _) in current } }
        database.collection("\(ownerName)'s groups").document(groupName).setData(groupsToSend, merge: true) { error in
        if let error = error {
            print(error.localizedDescription)
            } else { print("data saved")}
        }
    }

    
    func getUserPhotosNews(completion: @escaping ([NewsPhotoItem], [NewsPhotoGroup], [NewsPhotoProfile]) -> Void) {
        
        let path = "/method/newsfeed.get"
    
        let getNewsGroup = DispatchGroup()
        
        var newsItem = [NewsPhotoItem]()
        var newsGroup = [NewsPhotoGroup]()
        var newsProfile = [NewsPhotoProfile]()
        
        let parameters: Parameters = [
            "user_id" : Session.instance.userID,
            "filters" : "photo",
            "return_banned" : "0",
            "max_photos" : "1",
            "source_ids" : "groups",
            "count" : "10",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

         let url = baseUrl+path
        DispatchQueue.global().async(group: getNewsGroup) {
            AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
                guard let data = repsonse.value else { return }
                
                guard let news = try? JSONDecoder().decode(NewsPhotoModel.self, from: data) else { return }
               
                newsItem = news.response.items
                newsGroup = news.response.groups
                newsProfile = news.response.profiles
                
                getNewsGroup.notify(queue: .main) {
                  completion(newsItem, newsGroup, newsProfile)
                }
            }
        }
       
    }
    
    
    func getUserPostNews(completion: @escaping ([NewsPostItem], [NewsPostGroup], [NewsPostProfile]) -> Void) {
        
        let path = "/method/newsfeed.get"
        
        let getNewsGroup = DispatchGroup()
        
        var newsItem = [NewsPostItem]()
        var newsGroup = [NewsPostGroup]()
        var newsProfile = [NewsPostProfile]()
        
        let parameters: Parameters = [
            "user_id" : Session.instance.userID,
            "filters" : "post",
            "return_banned" : "0",
            "max_photos" : "1",
            "source_ids" : "groups",
            "count" : "50",
            "v" : "5.131",
            "access_token" : Session.instance.token,
            "lang" : "en"
         ]

        let url = baseUrl+path
        
        DispatchQueue.global().async(group: getNewsGroup) {
            AF.request(url, method: .get, parameters: parameters).responseData { repsonse in
                
                guard let data = repsonse.value else { return }
                
                guard let news = try? JSONDecoder().decode(NewsPostModel.self, from: data) else { return }
                
                newsItem = news.response.items
                newsGroup = news.response.groups
                newsProfile = news.response.profiles
                
                getNewsGroup.notify(queue: .main) {
                    completion(newsItem, newsGroup, newsProfile)
                }
                
            }
        }
    }
    
}
