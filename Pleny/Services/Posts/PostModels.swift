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
    let tags: [String]
    let reactions: Reactions
    let views: Int
    let userId: Int
}

struct Reactions: Codable {
    let likes: Int
    let dislikes: Int
}
