
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let photoAlbum = try? newJSONDecoder().decode(PhotoAlbum.self, from: jsonData)

import Foundation
import RealmSwift
// MARK: - PhotoAlbum
class PhotoAlbum: Codable {
    let response: PhotoResponse

    init(response: PhotoResponse) {
        self.response = response
    }
}

// MARK: - Response
class PhotoResponse: Codable {
    let count: Int
    let items: [PhotoItem]

    init(count: Int, items: [PhotoItem]) {
        self.count = count
        self.items = items
    }
}

// MARK: - Item
class PhotoItem: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var comments: Comments? = Comments()
    @objc dynamic var likes: Likes? = Likes()
    @objc dynamic var reposts: Comments? = Comments(), tags: Comments? = Comments()
    @objc dynamic var date: Int = 0, ownerID: Int = 0, postID: Int = 0
    @objc dynamic var text: String = ""
    @objc dynamic var sizes: [Size]? = [Size]()
    @objc dynamic var hasTags: Bool = false
    @objc dynamic var albumID: Int = 0, canComment: Int = 0

    enum CodingKeys: String, CodingKey {
        case id, comments, likes, reposts, tags, date
        case ownerID = "owner_id"
        case postID = "post_id"
        case text, sizes
        case hasTags = "has_tags"
        case albumID = "album_id"
        case canComment = "can_comment"
    }

    convenience required init(id: Int, comments: Comments, likes: Likes, reposts: Comments, tags: Comments, date: Int, ownerID: Int, postID: Int, text: String, sizes: [Size], hasTags: Bool, albumID: Int, canComment: Int) {
        self.init()
        self.id = id
        self.comments = comments
        self.likes = likes
        self.reposts = reposts
        self.tags = tags
        self.date = date
        self.ownerID = ownerID
        self.postID = postID
        self.text = text
        self.sizes = sizes
        self.hasTags = hasTags
        self.albumID = albumID
        self.canComment = canComment
    }
}

// MARK: - Comments
class Comments: Object, Codable {
    @objc dynamic var count: Int = 0

    convenience required init(count: Int) {
        self.init()
        self.count = count
    }
}

// MARK: - Likes
class Likes: Object, Codable {
    @objc dynamic var userLikes: Int = 0, count: Int = 0

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }

    convenience required init(userLikes: Int, count: Int) {
        self.init()
        self.userLikes = userLikes
        self.count = count
    }
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var width: Int = 0, height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""

    convenience required init(width: Int, height: Int, url: String, type: String) {
        self.init()
        self.width = width
        self.height = height
        self.url = url
        self.type = type
    }
}
