//
//  PostService.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import Combine
import Foundation

protocol PostServiceProtocol {
    func fetchPosts(limit: Int, skip: Int, search: String) -> AnyPublisher<PostsResponse, Error>
}

class PostService: PostServiceProtocol {
    static let shared = PostService()
    
    private let baseURL = "https://dummyjson.com/posts/search"
    
    private init() {}
    
    func fetchPosts(limit: Int, skip: Int, search: String) -> AnyPublisher<PostsResponse, Error> {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(search)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)"),
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PostsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
