//
//  API.swift
//  VkNewsFeed
//

import Foundation

/// API
enum API: String {
    /// Scheme
    case scheme = "https"
    /// Host
    case host = "api.vk.com"
    /// Verison
    case verison = "5.92"
    /// News feed request
    case newsFeed = "/method/newsfeed.get"
    /// Users request
    case user = "/method/users.get"
}
