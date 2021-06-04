//
//  Friend.swift
//  Lesson1B2
//
//  Created by user on 29.05.2021.
//

import Foundation

class Friends: Codable {
    let response: FriendResponse

    init(response: FriendResponse) {
        self.response = response
    }
}

// MARK: - Response
class FriendResponse: Codable {
    let count: Int
    let items: [FriendItem]

    init(count: Int, items: [FriendItem]) {
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class FriendItem: Codable {
    let canAccessClosed: Bool
    let id: Int
    let photo200_Orig: String
    let lastName, trackCode: String
    let isClosed: Bool
    let firstName: String

    enum CodingKeys: String, CodingKey {
        case canAccessClosed = "can_access_closed"
        case id
        case photo200_Orig = "photo_200_orig"
        case lastName = "last_name"
        case trackCode = "track_code"
        case isClosed = "is_closed"
        case firstName = "first_name"
    }

    init(canAccessClosed: Bool, id: Int, photo200_Orig: String, lastName: String, trackCode: String, isClosed: Bool, firstName: String) {
        self.canAccessClosed = canAccessClosed
        self.id = id
        self.photo200_Orig = photo200_Orig
        self.lastName = lastName
        self.trackCode = trackCode
        self.isClosed = isClosed
        self.firstName = firstName
    }
}

