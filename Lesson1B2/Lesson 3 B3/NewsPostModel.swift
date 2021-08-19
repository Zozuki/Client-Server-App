
import Foundation

// MARK: - NewsPostModel
class NewsPostModel: Codable {
    let response: NewsPostResponse

    init(response: NewsPostResponse) {
        self.response = response
    }
}

// MARK: - Response
class NewsPostResponse: Codable {
    let items: [NewsPostItem]
    let groups: [NewsPostGroup]
    let profiles: [NewsPostProfile]
    let nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, groups, profiles
        case nextFrom = "next_from"
    }

    init(items: [NewsPostItem], groups: [NewsPostGroup], profiles: [NewsPostProfile], nextFrom: String) {
        self.items = items
        self.groups = groups
        self.profiles = profiles
        self.nextFrom = nextFrom
    }
}

// MARK: - Group
class NewsPostGroup: Codable {
    let isMember, id: Int
    let photo100: String
    let isAdvertiser, isAdmin: Int
    let photo50, photo200: String
  
    let screenName, name: String
    let isClosed: Int

    enum CodingKeys: String, CodingKey {
        case isMember = "is_member"
        case id
        case photo100 = "photo_100"
        case isAdvertiser = "is_advertiser"
        case isAdmin = "is_admin"
        case photo50 = "photo_50"
        case photo200 = "photo_200"
       
        case screenName = "screen_name"
        case name
        case isClosed = "is_closed"
    }

    init(isMember: Int, id: Int, photo100: String, isAdvertiser: Int, isAdmin: Int, photo50: String, photo200: String,  screenName: String, name: String, isClosed: Int) {
        self.isMember = isMember
        self.id = id
        self.photo100 = photo100
        self.isAdvertiser = isAdvertiser
        self.isAdmin = isAdmin
        self.photo50 = photo50
        self.photo200 = photo200
        
        self.screenName = screenName
        self.name = name
        self.isClosed = isClosed
    }
}

enum GroupType: String, Codable {
    case page = "page"
}

// MARK: - Item
class NewsPostItem: Codable {
    let donut: ItemDonut
    let comments: NewsPostComments
    let isFavorite: Bool
    let shortTextRate: Double
    let likes, reposts: NewsPostLikes
    let type, postType: PostTypeEnum
    let date, sourceID: Int
    let text: String
    let attachments: [ItemAttachment]?
    let markedAsAds, postID: Int
   
    let carouselOffset, topicID, signerID: Int?
    let categoryAction: CategoryAction?
    let copyHistory: [CopyHistory]?

    enum CodingKeys: String, CodingKey {
        case donut, comments
        
        case isFavorite = "is_favorite"
        case shortTextRate = "short_text_rate"
        case likes, reposts, type
        case postType = "post_type"
        case date
        case sourceID = "source_id"
        case text
        case attachments
        case markedAsAds = "marked_as_ads"
        case postID = "post_id"
       
        case carouselOffset = "carousel_offset"
        case topicID = "topic_id"
        case signerID = "signer_id"
        case categoryAction = "category_action"
        case copyHistory = "copy_history"
    }

    init(donut: ItemDonut, comments: NewsPostComments, isFavorite: Bool, shortTextRate: Double, likes: NewsPostLikes, reposts: NewsPostLikes, type: PostTypeEnum, postType: PostTypeEnum, date: Int, sourceID: Int, text: String, attachments: [ItemAttachment]?, markedAsAds: Int, postID: Int,  carouselOffset: Int?, topicID: Int?, signerID: Int?, categoryAction: CategoryAction?, copyHistory: [CopyHistory]?) {
        self.donut = donut
        self.comments = comments
        
        self.isFavorite = isFavorite
        self.shortTextRate = shortTextRate
        self.likes = likes
        self.reposts = reposts
        self.type = type
        self.postType = postType
        self.date = date
        self.sourceID = sourceID
        self.text = text
        
        self.attachments = attachments
        self.markedAsAds = markedAsAds
        self.postID = postID
       
        self.carouselOffset = carouselOffset
        self.topicID = topicID
        self.signerID = signerID
        self.categoryAction = categoryAction
        self.copyHistory = copyHistory
    }
}

// MARK: - ItemAttachment
class ItemAttachment: Codable {
   
    let photo: NewsPostPhoto?
    
 

    init(photo: NewsPostPhoto?) {
       
        self.photo = photo
        
    }
}

// MARK: - Album
class Album: Codable {
    let updated, id: Int
    let title: String
    let size, created: Int
    let thumb: NewsPostPhoto
    let albumDescription: String
    let ownerID: Int

    enum CodingKeys: String, CodingKey {
        case updated, id, title, size, created, thumb
        case albumDescription = "description"
        case ownerID = "owner_id"
    }

    init(updated: Int, id: Int, title: String, size: Int, created: Int, thumb: NewsPostPhoto, albumDescription: String, ownerID: Int) {
        self.updated = updated
        self.id = id
        self.title = title
        self.size = size
        self.created = created
        self.thumb = thumb
        self.albumDescription = albumDescription
        self.ownerID = ownerID
    }
}

// MARK: - Photo
class NewsPostPhoto: Codable {
    let albumID, id, date: Int
    let text: String
    let userID: Int?
    let sizes: [NewsPostSize]
    let hasTags: Bool
    let ownerID: Int
    let accessKey: String?
    let postID: Int?
    let long, lat: Double?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id, date, text
        case userID = "user_id"
        case sizes
        case hasTags = "has_tags"
        case ownerID = "owner_id"
        case accessKey = "access_key"
        case postID = "post_id"
        case long, lat
    }

    init(albumID: Int, id: Int, date: Int, text: String, userID: Int?, sizes: [NewsPostSize], hasTags: Bool, ownerID: Int, accessKey: String?, postID: Int?, long: Double?, lat: Double?) {
        self.albumID = albumID
        self.id = id
        self.date = date
        self.text = text
        self.userID = userID
        self.sizes = sizes
        self.hasTags = hasTags
        self.ownerID = ownerID
        self.accessKey = accessKey
        self.postID = postID
        self.long = long
        self.lat = lat
    }
}

// MARK: - Size
class NewsPostSize: Codable {
    let width, height: Int
    let url: String
    let type: SizeType?
    let withPadding: Int?

    enum CodingKeys: String, CodingKey {
        case width, height, url, type
        case withPadding = "with_padding"
    }

    init(width: Int, height: Int, url: String, type: SizeType?, withPadding: Int?) {
        self.width = width
        self.height = height
        self.url = url
        self.type = type
        self.withPadding = withPadding
    }
}

enum SizeType: String, Codable {
    case k = "k"
    case l = "l"
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

// MARK: - Audio
class Audio: Codable {
    let id: Int
    let storiesAllowed, storiesCoverAllowed: Bool
    let mainArtists: [MainArtist]
    let trackCode: String
    let url: String
    let title: String
    let ownerID, date: Int
    let shortVideosAllowed: Bool
    let duration: Int
    let artist: String
    let isExplicit, isFocusTrack: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case storiesAllowed = "stories_allowed"
        case storiesCoverAllowed = "stories_cover_allowed"
        case mainArtists = "main_artists"
        case trackCode = "track_code"
        case url, title
        case ownerID = "owner_id"
        case date
        case shortVideosAllowed = "short_videos_allowed"
        case duration, artist
        case isExplicit = "is_explicit"
        case isFocusTrack = "is_focus_track"
    }

    init(id: Int, storiesAllowed: Bool, storiesCoverAllowed: Bool, mainArtists: [MainArtist], trackCode: String, url: String, title: String, ownerID: Int, date: Int, shortVideosAllowed: Bool, duration: Int, artist: String, isExplicit: Bool, isFocusTrack: Bool) {
        self.id = id
        self.storiesAllowed = storiesAllowed
        self.storiesCoverAllowed = storiesCoverAllowed
        self.mainArtists = mainArtists
        self.trackCode = trackCode
        self.url = url
        self.title = title
        self.ownerID = ownerID
        self.date = date
        self.shortVideosAllowed = shortVideosAllowed
        self.duration = duration
        self.artist = artist
        self.isExplicit = isExplicit
        self.isFocusTrack = isFocusTrack
    }
}

// MARK: - MainArtist
class MainArtist: Codable {
    let name, id, domain: String

    init(name: String, id: String, domain: String) {
        self.name = name
        self.id = id
        self.domain = domain
    }
}

// MARK: - Link
class Link: Codable {
    let photo: NewsPostPhoto?
    let isFavorite: Bool
    let title: String
    let url: String
    let linkDescription, target: String

    enum CodingKeys: String, CodingKey {
        case photo
        case isFavorite = "is_favorite"
        case title, url
        case linkDescription = "description"
        case target
    }

    init(photo: NewsPostPhoto?, isFavorite: Bool, title: String, url: String, linkDescription: String, target: String) {
        self.photo = photo
        self.isFavorite = isFavorite
        self.title = title
        self.url = url
        self.linkDescription = linkDescription
        self.target = target
    }
}

enum AttachmentType: String, Codable {
    case album = "album"
    case audio = "audio"
    case link = "link"
    case photo = "photo"
    case video = "video"
}

// MARK: - Video
class Video: Codable {
    let ownerID: Int
    let title: String
    let canAdd, duration: Int
    let image: [NewsPostSize]
    let isFavorite: Bool
    let views: Int
    let type: AttachmentType
    let canLike, canComment: Int
    let firstFrame: [NewsPostSize]?
    let date, id, height: Int
    let trackCode: String
    let width, canAddToFaves: Int
    let accessKey: String
    let canSubscribe, canRepost: Int
    let videoDescription: String?
    let contentRestricted: Int?
    let contentRestrictedMessage: String?

    enum CodingKeys: String, CodingKey {
        case ownerID = "owner_id"
        case title
        case canAdd = "can_add"
        case duration, image
        case isFavorite = "is_favorite"
        case views, type
        case canLike = "can_like"
        case canComment = "can_comment"
        case firstFrame = "first_frame"
        case date, id, height
        case trackCode = "track_code"
        case width
        case canAddToFaves = "can_add_to_faves"
        case accessKey = "access_key"
        case canSubscribe = "can_subscribe"
        case canRepost = "can_repost"
        case videoDescription = "description"
        case contentRestricted = "content_restricted"
        case contentRestrictedMessage = "content_restricted_message"
    }

    init(ownerID: Int, title: String, canAdd: Int, duration: Int, image: [NewsPostSize], isFavorite: Bool, views: Int, type: AttachmentType, canLike: Int, canComment: Int, firstFrame: [NewsPostSize]?, date: Int, id: Int, height: Int, trackCode: String, width: Int, canAddToFaves: Int, accessKey: String, canSubscribe: Int, canRepost: Int, videoDescription: String?, contentRestricted: Int?, contentRestrictedMessage: String?) {
        self.ownerID = ownerID
        self.title = title
        self.canAdd = canAdd
        self.duration = duration
        self.image = image
        self.isFavorite = isFavorite
        self.views = views
        self.type = type
        self.canLike = canLike
        self.canComment = canComment
        self.firstFrame = firstFrame
        self.date = date
        self.id = id
        self.height = height
        self.trackCode = trackCode
        self.width = width
        self.canAddToFaves = canAddToFaves
        self.accessKey = accessKey
        self.canSubscribe = canSubscribe
        self.canRepost = canRepost
        self.videoDescription = videoDescription
        self.contentRestricted = contentRestricted
        self.contentRestrictedMessage = contentRestrictedMessage
    }
}

// MARK: - CategoryAction
class CategoryAction: Codable {
    let name: String
    let action: Action

    init(name: String, action: Action) {
        self.name = name
        self.action = action
    }
}

// MARK: - Action
class Action: Codable {
    let target, type, url: String

    init(target: String, type: String, url: String) {
        self.target = target
        self.type = type
        self.url = url
    }
}

// MARK: - Comments
class NewsPostComments: Codable {
    let count: Int
    let donut: CommentsDonut?

    init(count: Int, donut: CommentsDonut?) {
        self.count = count
        self.donut = donut
    }
}

// MARK: - CommentsDonut
class CommentsDonut: Codable {
    let placeholder: Placeholder

    init(placeholder: Placeholder) {
        self.placeholder = placeholder
    }
}

// MARK: - Placeholder
class Placeholder: Codable {
    let text: String

    init(text: String) {
        self.text = text
    }
}

// MARK: - CopyHistory
class CopyHistory: Codable {
    let postSource: PostSource
    let postType: PostTypeEnum
    let id, fromID, date: Int
    let text: String
    let attachments: [CopyHistoryAttachment]
    let ownerID: Int

    enum CodingKeys: String, CodingKey {
        case postSource = "post_source"
        case postType = "post_type"
        case id
        case fromID = "from_id"
        case date, text, attachments
        case ownerID = "owner_id"
    }

    init(postSource: PostSource, postType: PostTypeEnum, id: Int, fromID: Int, date: Int, text: String, attachments: [CopyHistoryAttachment], ownerID: Int) {
        self.postSource = postSource
        self.postType = postType
        self.id = id
        self.fromID = fromID
        self.date = date
        self.text = text
        self.attachments = attachments
        self.ownerID = ownerID
    }
}

// MARK: - CopyHistoryAttachment
class CopyHistoryAttachment: Codable {
    let type: AttachmentType
    let photo: NewsPostPhoto?
    let link: Link?

    init(type: AttachmentType, photo: NewsPostPhoto?, link: Link?) {
        self.type = type
        self.photo = photo
        self.link = link
    }
}

// MARK: - PostSource
class PostSource: Codable {
    let type: String

    init(type: String) {
        self.type = type
    }
}

enum PostTypeEnum: String, Codable {
    case post = "post"
}

// MARK: - ItemDonut
class ItemDonut: Codable {
    let isDonut: Bool

    enum CodingKeys: String, CodingKey {
        case isDonut = "is_donut"
    }

    init(isDonut: Bool) {
        self.isDonut = isDonut
    }
}

// MARK: - Likes
class NewsPostLikes: Codable {
    let count: Int

    init(count: Int) {
        self.count = count
    }
}

// MARK: - Profile
class NewsPostProfile: Codable {
    let canAccessClosed: Bool?
    let screenName: String?
    let online, id: Int
    let photo100: String
    let lastName: String
    let photo50: String
    
    let sex: Int
    let isClosed: Bool?
    let firstName: String
    let deactivated: String?
    let onlineMobile, onlineApp: Int?

    enum CodingKeys: String, CodingKey {
        case canAccessClosed = "can_access_closed"
        case screenName = "screen_name"
        case online, id
        case photo100 = "photo_100"
        case lastName = "last_name"
        case photo50 = "photo_50"
        
        case sex
        case isClosed = "is_closed"
        case firstName = "first_name"
        case deactivated
        case onlineMobile = "online_mobile"
        case onlineApp = "online_app"
    }

    init(canAccessClosed: Bool?, screenName: String?, online: Int, id: Int, photo100: String, lastName: String, photo50: String,  sex: Int, isClosed: Bool?, firstName: String, deactivated: String?, onlineMobile: Int?, onlineApp: Int?) {
        self.canAccessClosed = canAccessClosed
        self.screenName = screenName
        self.online = online
        self.id = id
        self.photo100 = photo100
        self.lastName = lastName
        self.photo50 = photo50
       
        self.sex = sex
        self.isClosed = isClosed
        self.firstName = firstName
        self.deactivated = deactivated
        self.onlineMobile = onlineMobile
        self.onlineApp = onlineApp
    }
}

// MARK: - OnlineInfo
class OnlineInfo: Codable {
    let visible, isMobile, isOnline: Bool
    let appID, lastSeen: Int?

    enum CodingKeys: String, CodingKey {
        case visible
        case isMobile = "is_mobile"
        case isOnline = "is_online"
        case appID = "app_id"
        case lastSeen = "last_seen"
    }

    init(visible: Bool, isMobile: Bool, isOnline: Bool, appID: Int?, lastSeen: Int?) {
        self.visible = visible
        self.isMobile = isMobile
        self.isOnline = isOnline
        self.appID = appID
        self.lastSeen = lastSeen
    }
}

