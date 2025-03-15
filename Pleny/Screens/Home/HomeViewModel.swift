//
//  HomeViewModel.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private var postService: PostServiceProtocol
    private var currentPage = 0
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var morePostsIsLoading = false
    
    @Published var errorMessage: String? = nil
    @Published var hasMorePosts: Bool = false
    
    
    init(postService: PostServiceProtocol = PostService.shared) {
        self.postService = postService
    }
    
    func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        postService.fetchPosts(limit: 10, skip: 0)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    break
                }
                self.isLoading = false
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.posts.append(contentsOf: response.posts)
                self.currentPage += 1
                self.hasMorePosts = posts.count < response.total
            })
            .store(in: &cancellables)
    }
    
    func loadMorePosts() {
        guard !morePostsIsLoading && hasMorePosts else { return }
        
        morePostsIsLoading = true
        postService.fetchPosts(limit: 10, skip: currentPage * 10)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    break
                case .failure:
                    self.morePostsIsLoading = false
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                self.posts.append(contentsOf: response.posts)
                self.currentPage += 1
                self.hasMorePosts = posts.count < response.total
                self.morePostsIsLoading = false
            })
            .store(in: &cancellables)
    }
    
}
