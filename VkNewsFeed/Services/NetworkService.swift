//
//  NetworkService.swift
//  VkNewsFeed
//

import Foundation

/// Protocol for network service
protocol Networking {
    /// Do reqeust
    /// - Parameters:
    ///   - path: Path
    ///   - params: Params
    ///   - completion: Completion
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {

    // MARK: - Properties
    
    private let authService: AuthService = SceneDelegate.shared().authService
    
    // MARK: - Methods
    
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.verison.rawValue

        let url = self.createUrl(from: path, params: allParams)
        let request = URLRequest(url: url)
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }
    
    /// Create data task
    /// - Parameters:
    ///   - request: Request
    ///   - completion: Completion
    /// - Returns: URLSessionDataTask
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
    /// Create url
    /// - Parameters:
    ///   - path: Path
    ///   - params: Params
    /// - Returns: URL
    private func createUrl(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme.rawValue
        components.host = API.host.rawValue
        components.path = path
        components.queryItems = params.map { URLQueryItem.init(name: $0, value: $1) }

        return components.url!
    }
}
