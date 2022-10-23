//
//  NetworkDataFetcher.swift
//  VkNewsFeed
//

import Foundation

protocol DataFetcher {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    /// Get user
    /// - Parameter response: Closure
    func getUser(response: @escaping (UserResponseItem?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {

    var networking: Networking
    private let authService: AuthService

    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }

    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post,photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed.rawValue, params: params) { data, error in
            if let error = error {
                print(error.localizedDescription)
                response(nil)
            }

            let decoded = decodeJson(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getUser(response: @escaping (UserResponseItem?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100"]
                
        networking.request(path: API.user.rawValue, params: params) { data, error in
            if let error = error {
                print(error.localizedDescription)
                response(nil)
            }
            
            let decoded = decodeJson(type: UserResponse.self, from: data)
            response(decoded?.response.first)
        }
    }

    /// Decode Json
    /// - Parameters:
    ///   - type: Type
    ///   - from: From data
    /// - Returns: Response
    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
