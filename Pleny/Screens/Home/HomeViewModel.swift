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
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

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
                self.posts = response.posts
            })
            .store(in: &cancellables)
    }
}
