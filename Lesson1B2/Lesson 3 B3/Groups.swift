// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let group2 = try? newJSONDecoder().decode(Group2.self, from: jsonData)

import Foundation
import RealmSwift

// MARK: - Group2
class Groups:  Codable {
    var response: GroupResponse

    init(response: GroupResponse) {
        self.response = response
    }
}

// MARK: - Response
class GroupResponse:  Codable {
    var count: Int
    var items: [GroupItem]

    init(count: Int, items: [GroupItem]) {
        
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class GroupItem: Object, Codable {
    @objc dynamic var id: Int = 0, isClosed: Int = 0, isAdvertiser: Int = 0
    @objc dynamic var  type: String = ""
    @objc dynamic var  isMember: Int = 0, membersCount: Int = 0
    @objc dynamic var  photo50: String = "", photo200: String = ""
    @objc dynamic var  isAdmin: Int = 0
    @objc dynamic var  photo100: String = ""
    @objc dynamic var  name: String = "", screenName: String = ""
    
    func toFirestore(owner: String) -> [String: Any] {
        return [
            String(format: "%0.f", owner) : name
        ]
    }
    
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

    convenience init(id: Int, isClosed: Int, isAdvertiser: Int, type: String, isMember: Int, membersCount: Int, photo50: String, photo200: String, isAdmin: Int, photo100: String, name: String, screenName: String) {
        self.init()

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
