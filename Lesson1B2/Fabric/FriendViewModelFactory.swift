//
//  FriendListViewModel.swift
//  Lesson1B2
//
//  Created by user on 19.08.2021.
//

import UIKit

class FriendsViewModelFactory {
    func constructViewModel(from friends: [Friend]) -> [FriendsViewModel] {
        return friends.compactMap { getViewModel(from: $0) }
    }
    
    private func getViewModel(from frined: Friend) -> FriendsViewModel {
        let friendName = frined.firstName
        let friendLastName = frined.lastName
        
        let data = (try? Data(contentsOf: URL(string: frined.photo200_Orig)!))!
        let friendPhoto = UIImage(data: data)
        let id = frined.id
        return FriendsViewModel(firstName: friendName, lastName: friendLastName, photo: (friendPhoto ?? UIImage(named: "noAvatar"))!, id: id)
        
    }
}
