// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let group2 = try? newJSONDecoder().decode(Group2.self, from: jsonData)

import Foundation

// MARK: - Group2
class Groups: Codable {
    let response: GroupResponse

    init(response: GroupResponse) {
        self.response = response
    }
}

// MARK: - Response
class GroupResponse: Codable {
    let count: Int
    let items: [GroupItem]

    init(count: Int, items: [GroupItem]) {
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class GroupItem: Codable {
    let id, isClosed, isAdvertiser: Int
    let type: String
    let isMember, membersCount: Int
    let photo50, photo200: String
    let isAdmin: Int
    let photo100: String
    let name, screenName: String

    enum CodingKeys: String, CodingKey {
        case id
        case isClosed = "is_closed"
        case isAdvertiser = "is_advertiser"
        case type
        case isMember = "is_member"
        case membersCount = "members_count"
        case photo50 = "photo_50"
        case photo200 = "photo_200"
        case isAdmin = "is_admin"
        case photo100 = "photo_100"
        case name
        case screenName = "screen_name"
    }

    init(id: Int, isClosed: Int, isAdvertiser: Int, type: String, isMember: Int, membersCount: Int, photo50: String, photo200: String, isAdmin: Int, photo100: String, name: String, screenName: String) {
        self.id = id
        self.isClosed = isClosed
        self.isAdvertiser = isAdvertiser
        self.type = type
        self.isMember = isMember
        self.membersCount = membersCount
        self.photo50 = photo50
        self.photo200 = photo200
        self.isAdmin = isAdmin
        self.photo100 = photo100
        self.name = name
        self.screenName = screenName
    }
}
