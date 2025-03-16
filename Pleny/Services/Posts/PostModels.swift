//
//  PostModels.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import Foundation

struct PostsResponse: Codable {
    let posts: [Post]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
    let tags: [String]?
    let reactions: Reactions?
    let views: Int
    let userId: Int?
    
    init(id: Int, title: String, body: String, tags: [String]? = nil, reactions: Reactions? = nil, views: Int, userId: Int? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.tags = tags
        self.reactions = reactions
        self.views = views
        self.userId = userId
    }
}

struct Reactions: Codable {
    let likes: Int
    let dislikes: Int
}
