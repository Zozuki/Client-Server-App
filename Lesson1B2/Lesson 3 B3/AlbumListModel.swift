// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let albumListModel = try? newJSONDecoder().decode(AlbumListModel.self, from: jsonData)

import Foundation

// MARK: - AlbumListModel
class AlbumListModel: Codable {
    let response: Response

    init(response: Response) {
        self.response = response
    }
}

// MARK: - Response
class Response: Codable {
    let count: Int
    let items: [Item]

    init(count: Int, items: [Item]) {
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class Item: Codable {
    let size, id, thumbID, ownerID: Int
    let title: String
    let thumbSrc: String
    let updated, created: Int?
    let itemDescription: String?

    enum CodingKeys: String, CodingKey {
        case size, id
        case thumbID = "thumb_id"
        case ownerID = "owner_id"
        case title
        case thumbSrc = "thumb_src"
        case updated, created
        case itemDescription = "description"
    }

    init(size: Int, id: Int, thumbID: Int, ownerID: Int, title: String, thumbSrc: String, updated: Int?, created: Int?, itemDescription: String?) {
        self.size = size
        self.id = id
        self.thumbID = thumbID
        self.ownerID = ownerID
        self.title = title
        self.thumbSrc = thumbSrc
        self.updated = updated
        self.created = created
        self.itemDescription = itemDescription
    }
}

