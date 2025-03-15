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
    @Published var searchQuery: String = "" {
        didSet {
            // Reset the state
            currentPage = 0
            posts.removeAll()
        }
    }
    
    @Published var errorMessage: String? = nil
    @Published var hasMorePosts: Bool = false
    
    
    init(postService: PostServiceProtocol = PostService.shared) {
        self.postService = postService
        bindToSeachQuery()
    }
    
    private func bindToSeachQuery() {
        isLoading = true
        $searchQuery
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .compactMap { [weak self] searchQuery in
                self?.postService.fetchPosts(limit: 10, skip: (self?.currentPage ?? 0) * 10, search: searchQuery)
            }
            .switchToLatest()
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
                self.posts = response.posts
                self.currentPage += 1
                self.hasMorePosts = posts.count < response.total
            })
            .store(in: &cancellables)
    }
    
    func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        postService.fetchPosts(limit: 10, skip: 0, search: searchQuery)
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
                self.posts =  response.posts
                self.currentPage += 1
                self.hasMorePosts = posts.count < response.total
            })
            .store(in: &cancellables)
    }
    
    func loadMorePosts() {
        guard !morePostsIsLoading && hasMorePosts else { return }
        
        morePostsIsLoading = true
        postService.fetchPosts(limit: 10, skip: currentPage * 10, search: searchQuery)
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
