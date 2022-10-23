//
//  FeedResponse.swift
//  VkNewsFeed
//

import Foundation

struct FeedResponseWrapped: Decodable {
    var response: FeedResponse
}

/// Response for news feed
struct FeedResponse: Decodable {
    /// News
    var items: [FeedItem]
    /// Profiles
    var profiles: [Profile]
    /// Groups
    var groups: [Group]
    /// Parameter for get next part of news
    var nextFrom: String?
}

/// Item of news
struct FeedItem: Decodable {
    /// Id source item of news
    let sourceId: Int
    /// Id post item of news
    let postId: Int
    /// Text
    let text: String?
    /// Date
    let date: Double
    /// Count of comments
    let comments: CountableItem?
    /// Count of likes
    let likes: CountableItem?
    /// Count of reposts
    let reposts: CountableItem?
    /// Count of views
    let views: CountableItem?
    /// Objects related with item of news
    let attachments: [Attachment]?
}

/// Object with count of something
struct CountableItem: Decodable {
    /// Count
    let count: Int
}

/// Object related with item of news
struct Attachment: Decodable {
    /// Photo
    let photo: Photo?
}

/// Image from VK (from)
struct Photo: Decodable {
    /// Sizes of photo
    let sizes: [PhotoSize]

    /// Width
    var width: Int {
        return getPropperSize().width
    }

    /// Height
    var height: Int {
        return getPropperSize().height
    }

    var srcBIG: String {
        return getPropperSize().url
    }

    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "Wrong image", url: "Wrong image", width: 0, height: 0)
        }
    }
}

/// Size of photo
struct PhotoSize: Decodable {
    /// Type
    let type: String
    /// Url
    let url: String
    ///Width
    let width: Int
    /// Height
    let height: Int
}

protocol ProfileRepresentable {
    /// Id
    var id: Int { get }
    /// Name
    var name: String { get }
    /// Photo
    var photo: String { get }
}

/// Info about profile
struct Profile: Decodable, ProfileRepresentable {
    /// Id
    let id: Int
    /// Name
    var name: String { return "\(firstName) \(lastName)"}
    /// Photo
    var photo: String { return photo100 }

    /// Firest name
    let firstName: String
    /// Last Name
    let lastName: String
    /// Url of photo with size 100x100
    let photo100: String
}

/// Info about group
struct Group: Decodable, ProfileRepresentable {
    /// Id
    let id: Int
    /// name
    var name: String
    /// Url of photo
    var photo: String { return photo100 }
    
    /// Url of photo with size 100x100
    let photo100: String
}
