//
//  PostStore.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/16/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import Foundation

typealias PostStoreBlock = (_ posts: [Post], _ after: String?, _ error: ServiceAPIError?) -> Void

class PostStore: NSObject {

    class func posts(size: Int? = 50, after: String?, completion: PostStoreBlock?) {
        let stringURL = RedditServiceAPI.shared.baseURL.absoluteString + Endpoint.top.rawValue
        var topURL = URLComponents(string: stringURL)!
        topURL.queryItems = [
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "after", value: after ?? "")
        ]
        if let url = topURL.url {
            RedditServiceAPI.shared.fetchResources(url: url) { (result: Result<PostResponse, ServiceAPIError>) in
                switch result {
                case .success(let postResponse): completion?(postResponse.children, postResponse.after, nil)
                case .failure(let error): completion?([], nil, error)
                }
            }
        } else {
            completion?([], nil, .invalidEndpoint)
        }
    }

}
