//
//  FriendsAdapter.swift
//  Lesson1B2
//
//  Created by user on 19.08.2021.
//

import Foundation
import RealmSwift

class FriendsAdapter {
    private let service = VKService()
    private var realmNotificationToken: NotificationToken?
    
    func getFriends(completion: @escaping ([Friend]) -> Void) {
        guard let realm = try? Realm() else { return  }
        let realmFriends = realm.objects(FriendItem.self)
        
        let token = realmFriends.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial:
                break
            case .update(let realmFriends,_,_,_):
                var friends: [Friend] = []
                realmFriends.forEach { realmFriend in
                    friends.append(self.getFriend(from: realmFriend))
                }
                completion(friends)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        realmNotificationToken = token
        service.getFriendList()
    }
    
    private func getFriend(from realmFriend: FriendItem) -> Friend {
        Friend(canAccessClosed: realmFriend.canAccessClosed, id: realmFriend.id, photo200_Orig: realmFriend.photo200_Orig, lastName: realmFriend.lastName, trackCode: realmFriend.trackCode, isClosed: realmFriend.isClosed, firstName: realmFriend.firstName)
    }
}
