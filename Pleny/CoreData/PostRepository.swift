//
//  PostRepository.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 16/03/2025.
//

import Combine
import CoreData

protocol PostRepositoryProtocol {
    func fetchPosts() -> AnyPublisher<[Post], Error>
    func savePosts(posts: [Post])
}

class CoreDataPostRepository: PostRepositoryProtocol {
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        Just(coreDataManager.fetchPostsFromCoreData())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    
    func savePosts(posts: [Post]) {
        let context = coreDataManager.viewContext
        posts.forEach { post in
            let postEntity = PostEntity(context: context)
            postEntity.id = Int64(post.id)
            postEntity.title = post.title
            postEntity.body = post.body
            postEntity.views = Int64(post.views)
        }
        coreDataManager.saveContext()
    }
}
