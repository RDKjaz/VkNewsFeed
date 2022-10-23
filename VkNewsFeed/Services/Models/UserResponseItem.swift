//
//  UserResponse.swift
//  VkNewsFeed
//

import Foundation

/// Response for info of users
struct UserResponse: Decodable {
    let response: [UserResponseItem]
}

/// Response for info of user
struct UserResponseItem: Decodable {
    /// Url of photo with size 100x100
    let photo100: String?
}
