//
//  HomeViewModelTests.swift
//  PlenyTests
//
//  Created by Abdalla Elsaman on 16/03/2025.
//

import XCTest
import Combine
@testable import Pleny

class MockPostService: PostServiceProtocol {
    var fetchPostsResult: Result<PostsResponse, Error>?
    
    func fetchPosts(limit: Int, skip: Int, search: String) -> AnyPublisher<PostsResponse, Error> {
        if let result = fetchPostsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "MockError", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockPostRepository: PostRepositoryProtocol {
    var fetchPostsResult: Result<[Post], Error>?
    var savePostsCalled = false
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        if let result = fetchPostsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "MockError", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func savePosts(posts: [Post]) {
        savePostsCalled = true
    }
}

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockPostService: MockPostService!
    var mockPostRepository: MockPostRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockPostService = MockPostService()
        mockPostRepository = MockPostRepository()
        viewModel = HomeViewModel(postService: mockPostService, postsRepository: mockPostRepository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchPosts_Success() {
        let postResponse = PostsResponse(posts: [Post(id: 1, title: "Test Post", body: "body", views: 50)], total: 1, skip: 0, limit: 10)
        mockPostService.fetchPostsResult = .success(postResponse)
        
        let expectation = self.expectation(description: "Fetch Posts Success")
        viewModel.$posts
            .dropFirst()
            .sink { posts in
                if !posts.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPosts()
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Test Post")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchPosts_Failure() {
        mockPostService.fetchPostsResult = .failure(NSError(domain: "MockError", code: -1, userInfo: nil))
        
        let expectation = self.expectation(description: "Fetch Posts Failure")
        viewModel.$errorMessage
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPosts()
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (MockError error -1.)")
    }

    func testLoadMorePosts_Success() {
        let postResponse = PostsResponse(posts: [Post(id: 2, title: "Test Post 2", body: "body", views: 50)], total: 2, skip: 0, limit: 1)
        mockPostService.fetchPostsResult = .success(postResponse)
        
        let fetchPostsExpectation = self.expectation(description: "Fetch Posts Success")
        
        XCTAssertEqual(viewModel.hasMorePosts, false)

        viewModel.$posts
            .dropFirst()
            .sink { posts in
                if posts.count == 1 {
                    fetchPostsExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPosts()
        
        wait(for: [fetchPostsExpectation], timeout: 1)
        
        
        XCTAssertEqual(viewModel.hasMorePosts, true)

        let loadMorePostsExpectation = self.expectation(description: "Load More Posts Success")
        
        viewModel.$posts
            .dropFirst()
            .sink { posts in
                if posts.count > 1 {
                    loadMorePostsExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadMorePosts()
        
        wait(for: [loadMorePostsExpectation], timeout: 1)
        XCTAssertEqual(viewModel.hasMorePosts, false)
        XCTAssertEqual(viewModel.errorMessage, nil)
        XCTAssertEqual(viewModel.posts.count, 2)
        XCTAssertEqual(viewModel.posts.last?.title, "Test Post 2")
    }

    func testLoadMorePosts_Failure() {
        mockPostService.fetchPostsResult = .failure(NSError(domain: "MockError", code: -1, userInfo: nil))
        
        let expectation = self.expectation(description: "Load More Posts Failure")
        viewModel.$errorMessage
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchPosts()
        viewModel.loadMorePosts()
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "The operation couldn’t be completed. (MockError error -1.)")
    }

    func testSearchQueryTriggersNewFetch() {
        let postResponse = PostsResponse(posts: [Post(id: 1, title: "Search Result", body: "body", views: 50)], total: 1, skip: 0, limit: 10)
        mockPostService.fetchPostsResult = .success(postResponse)
        
        let expectation = self.expectation(description: "Search Query Triggers Fetch")
        
        viewModel.$posts
            .dropFirst()
            .sink { posts in
                if posts.count == 1 && posts.first?.title == "Search Result" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "Search Term"
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Search Result")
    }
}
