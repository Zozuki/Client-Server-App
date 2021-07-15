//
//  News.swift
//  Lesson1B2
//
//  Created by user on 15.07.2021.
//
import Foundation

// MARK: - News
class NewsPhotoModel: Codable {
    let response: NewsPhotoResponse

    init(response: NewsPhotoResponse) {
        self.response = response
    }
}

// MARK: - Response
class NewsPhotoResponse: Codable {
    let items: [NewsPhotoItem]
    let groups: [NewsPhotoGroup]
    let profiles: [NewsPhotoProfile]

    init(items: [NewsPhotoItem], groups: [NewsPhotoGroup], profiles: [ NewsPhotoProfile]) {
        self.items = items
        self.groups = groups
        self.profiles = profiles
    }
}

// MARK: - Group
class NewsPhotoGroup: Codable {
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

// MARK: - ResponseItem
class NewsPhotoItem: Codable {
    let photos: Photos
    let postID, sourceID: Int
    let type: String
    let date: Int

    enum CodingKeys: String, CodingKey {
        case photos
        case postID = "post_id"
        case sourceID = "source_id"
        case type, date
    }

    init(photos: Photos, postID: Int, sourceID: Int, type: String, date: Int) {
        self.photos = photos
        self.postID = postID
        self.sourceID = sourceID
        self.type = type
        self.date = date
    }
}

// MARK: - Photos
class Photos: Codable {
    let count: Int
    let items: [NewsPhotoPhotosItem]

    init(count: Int, items: [NewsPhotoPhotosItem]) {
        self.count = count
        self.items = items
    }
}

// MARK: - PhotosItem
class NewsPhotoPhotosItem: Codable {
    let id: Int
    let comments: NewsPhotoComments
    let likes: NewsPhotoLikes
    let accessKey: String
    let userID: Int
    let reposts: Reposts
    let date, ownerID: Int
    let text: String
    let canRepost: Int
    let sizes: [NewsPhotoSize]
    let hasTags: Bool
    let albumID, canComment: Int

    enum CodingKeys: String, CodingKey {
        case id, comments, likes
        case accessKey = "access_key"
        case userID = "user_id"
        case reposts, date
        case ownerID = "owner_id"
        case text
        case canRepost = "can_repost"
        case sizes
        case hasTags = "has_tags"
        case albumID = "album_id"
        case canComment = "can_comment"
    }

    init(id: Int, comments: NewsPhotoComments, likes: NewsPhotoLikes, accessKey: String, userID: Int, reposts: Reposts, date: Int, ownerID: Int, text: String, canRepost: Int, sizes: [NewsPhotoSize], hasTags: Bool, albumID: Int, canComment: Int) {
        self.id = id
        self.comments = comments
        self.likes = likes
        self.accessKey = accessKey
        self.userID = userID
        self.reposts = reposts
        self.date = date
        self.ownerID = ownerID
        self.text = text
        self.canRepost = canRepost
        self.sizes = sizes
        self.hasTags = hasTags
        self.albumID = albumID
        self.canComment = canComment
    }
}

// MARK: - Comments
class NewsPhotoComments: Codable {
    let count: Int

    init(count: Int) {
        self.count = count
    }
}

// MARK: - Likes
class NewsPhotoLikes: Codable {
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

// MARK: - Reposts
class Reposts: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }

    init(count: Int, userReposted: Int) {
        self.count = count
        self.userReposted = userReposted
    }
}

// MARK: - Size
class NewsPhotoSize: Codable {
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


// MARK: - Profile
class NewsPhotoProfile: Codable {
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool
    let firstName: String

    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case firstName = "first_name"
    }

    init(id: Int, lastName: String, canAccessClosed: Bool, isClosed: Bool, firstName: String) {
        self.id = id
        self.lastName = lastName
        self.canAccessClosed = canAccessClosed
        self.isClosed = isClosed
        self.firstName = firstName
    }
}
