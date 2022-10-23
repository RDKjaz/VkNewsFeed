//
//  NewsFeedModels.swift
//  VkNewsFeed
//

import UIKit

/// Request type
enum RequestType {
    /// Get news
    case getNewsFeed
    /// Get info about user
    case getUser
    /// Reveal full post
    case revealPost(postId: Int)
    /// Get next part of news
    case getNextBatchNews
}

enum ResponseType {
    case presentNewsFeed(feed: FeedResponse, relvealedPostIds: [Int])
    case presentUserInfo(user: UserResponseItem?)
}

enum ViewModelData {
    case displayNewsFeed(feedViewModel: FeedViewModel)
    case displayUser(userViewModel: UserViewModel)
}

struct UserViewModel: TitleViewViewModel {
    var imageUrlSrting: String?
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int
        
        var topImageUrlString: String
        var name: String
        var date: String
        var text: String?
        var imageAttachments: [FeedCellPhotoAttachmentViewModel]
        var likes: String?
        var comments: String?
        var reposts: String?
        var views: String?
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var imageUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
