
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let photoAlbum = try? newJSONDecoder().decode(PhotoAlbum.self, from: jsonData)

import Foundation

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
class PhotoItem: Codable {
    let id: Int
    let comments: Comments
    let likes: Likes
    let reposts, tags: Comments
    let date, ownerID, postID: Int
    let text: String
    let sizes: [Size]
    let hasTags: Bool
    let albumID, canComment: Int

    enum CodingKeys: String, CodingKey {
        case id, comments, likes, reposts, tags, date
        case ownerID = "owner_id"
        case postID = "post_id"
        case text, sizes
        case hasTags = "has_tags"
        case albumID = "album_id"
        case canComment = "can_comment"
    }

    init(id: Int, comments: Comments, likes: Likes, reposts: Comments, tags: Comments, date: Int, ownerID: Int, postID: Int, text: String, sizes: [Size], hasTags: Bool, albumID: Int, canComment: Int) {
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
class Comments: Codable {
    let count: Int

    init(count: Int) {
        self.count = count
    }
}

// MARK: - Likes
class Likes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }

    init(userLikes: Int, count: Int) {
        self.userLikes = userLikes
        self.count = count
    }
}

// MARK: - Size
class Size: Codable {
    let width, height: Int
    let url: String
    let type: String

    init(width: Int, height: Int, url: String, type: String) {
        self.width = width
        self.height = height
        self.url = url
        self.type = type
    }
}
