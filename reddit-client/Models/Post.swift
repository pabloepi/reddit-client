//
//  File.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/16/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import Foundation

struct PostResponse {
    public let after: String
    public let children: [Post]

    enum RootKeys: String, CodingKey {
        case data
        case kind
    }
    
    enum DataKeys: String, CodingKey {
        case modhash
        case dist
        case children
        case after
        case before
    }
}

extension PostResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        after = try dataContainer.decode(String.self, forKey: .after)
        children = try dataContainer.decode([Post].self, forKey: .children)
    }
}

struct Post {
    public let postId: String
    public let numComments: Int
    public let title: String
    public let thumbnail: String
    public let author: String
    public let url: String
    public let createdUtc: Date
    public var read: Bool = false

    enum RootKeys: String, CodingKey {
        case data
        case kind
    }

    enum PostKeys: String, CodingKey {
        case id
        case numComments
        case title
        case thumbnail
        case author
        case url
        case createdUtc
    }
}

extension Post: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let postContainer = try container.nestedContainer(keyedBy: PostKeys.self, forKey: .data)
        postId = try postContainer.decode(String.self, forKey: .id)
        numComments = try postContainer.decode(Int.self, forKey: .numComments)
        title = try postContainer.decode(String.self, forKey: .title)
        thumbnail = try postContainer.decode(String.self, forKey: .thumbnail)
        author = try postContainer.decode(String.self, forKey: .author)
        url = try postContainer.decode(String.self, forKey: .url)
        createdUtc = try postContainer.decode(Date.self, forKey: .createdUtc)
    }
}
