//
//  WebImageView.swift
//  VkNewsFeed
//

import UIKit

/// Image from web
class WebImageView: UIImageView {

    /// Current url in string format
    private var currentUrlString: String?
    
    /// Set image in UIImageView by url
    /// - Parameter imageUrl: Url of image in string format
    func set(imageUrl: String?) {
        currentUrlString = imageUrl
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.image = nil
            return
        }

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, _) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }.resume()
    }
    
    /// Handle response after request and add in cache
    /// - Parameters:
    ///   - data: Data
    ///   - response: Response
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }
        let cachedResponse =  CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        
        if responseUrl.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }
}
