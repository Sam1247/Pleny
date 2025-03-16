//
//  PostServiceTests.swift
//  PlenyTests
//
//  Created by Abdalla Elsaman on 16/03/2025.
//

import XCTest
import Combine
@testable import Pleny

class PostServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        cancellables = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }
    
    func testFetchPostsEmptyResponse() {
        let mockResponse = PostsResponse(posts: [], total: 0, skip: 0, limit: 10)
        let data = try! JSONEncoder().encode(mockResponse)
        let url = URL(string: "https://dummyjson.com/posts/search?q=love&limit=10&skip=0")!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data, httpResponse, nil)
        }
        
        let expectation = XCTestExpectation(description: "Fetch posts successfully, but no posts available")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.posts.count, 0)
                XCTAssertEqual(response.total, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    func testFetchPostsSuccess() {
        let mockResponse = PostsResponse(posts: [
            Post(id: 1, title: "Test Post 1", body: "This is the body of post 1", tags: ["Swift", "iOS"], reactions: Reactions(likes: 5, dislikes: 1), views: 100, userId: 1),
            Post(id: 2, title: "Test Post 2", body: "This is the body of post 2", tags: nil, reactions: Reactions(likes: 10, dislikes: 0), views: 150, userId: 2)
        ], total: 2, skip: 0, limit: 10)
        
        let data = try! JSONEncoder().encode(mockResponse)
        let url = URL(string: "https://dummyjson.com/posts/search?q=love&limit=10&skip=0")!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data, httpResponse, nil)
        }
        
        let expectation = XCTestExpectation(description: "Fetch posts successfully")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.posts.count, 2)
                XCTAssertEqual(response.posts.first?.title, "Test Post 1")
                XCTAssertEqual(response.posts.last?.title, "Test Post 2")
                XCTAssertEqual(response.posts.first?.tags, ["Swift", "iOS"])
                XCTAssertEqual(response.posts.first?.reactions?.likes, 5)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPostsPagination() {
        let mockResponsePage1 = PostsResponse(posts: [
            Post(id: 1, title: "Test Post 1", body: "This is the body of post 1", tags: ["Swift"], reactions: Reactions(likes: 5, dislikes: 1), views: 100, userId: 1),
            Post(id: 2, title: "Test Post 2", body: "This is the body of post 2", tags: nil, reactions: Reactions(likes: 10, dislikes: 0), views: 150, userId: 2)
        ], total: 5, skip: 0, limit: 2)
        
        let mockResponsePage2 = PostsResponse(posts: [
            Post(id: 3, title: "Test Post 3", body: "This is the body of post 3", tags: nil, reactions: Reactions(likes: 5, dislikes: 2), views: 200, userId: 1),
            Post(id: 4, title: "Test Post 4", body: "This is the body of post 4", tags: nil, reactions: Reactions(likes: 12, dislikes: 0), views: 300, userId: 2)
        ], total: 5, skip: 2, limit: 2)
        
        let dataPage1 = try! JSONEncoder().encode(mockResponsePage1)
        let dataPage2 = try! JSONEncoder().encode(mockResponsePage2)
        
        let urlPage1 = URL(string: "https://dummyjson.com/posts/search?q=love&limit=2&skip=0")!
        let urlPage2 = URL(string: "https://dummyjson.com/posts/search?q=love&limit=2&skip=2")!
        
        var requestCount = 0
        
        MockURLProtocol.requestHandler = { request in
            if request.url == urlPage1 {
                XCTAssertEqual(request.url, urlPage1)
                requestCount += 1
                let httpResponse = HTTPURLResponse(url: urlPage1, statusCode: 200, httpVersion: nil, headerFields: nil)
                return (dataPage1, httpResponse, nil)
            } else if request.url == urlPage2 {
                XCTAssertEqual(request.url, urlPage2)
                requestCount += 1
                let httpResponse = HTTPURLResponse(url: urlPage2, statusCode: 200, httpVersion: nil, headerFields: nil)
                return (dataPage2, httpResponse, nil)
            }
            return (nil, nil, URLError(.badURL))
        }
        
        let expectation = XCTestExpectation(description: "Fetch posts with pagination")
        
        var allPosts: [Post] = []
        
        PostService.shared.fetchPosts(limit: 2, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { response in
                allPosts.append(contentsOf: response.posts)
                
                PostService.shared.fetchPosts(limit: 2, skip: 2, search: "love")
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            XCTFail("Expected success, but got error: \(error)")
                        }
                    }, receiveValue: { response in
                        allPosts.append(contentsOf: response.posts)
                        
                        XCTAssertEqual(allPosts.count, 4)
                        XCTAssertEqual(allPosts.first?.title, "Test Post 1")
                        XCTAssertEqual(allPosts.last?.title, "Test Post 4")
                        expectation.fulfill()
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }

    func testFetchPostsFailure() {
        let url = URL(string: "https://dummyjson.com/posts/search?q=love&limit=10&skip=0")!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            return (nil, nil, URLError(.notConnectedToInternet))
        }
        
        let expectation = XCTestExpectation(description: "Fail to fetch posts")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
                    expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTFail("Expected failure, but got response: \(response)")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testBadURL() {
        MockURLProtocol.requestHandler = { request in
            return (nil, nil, URLError(.badURL))
        }
        
        let expectation = XCTestExpectation(description: "Fail due to bad URL")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "invalid")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .badURL)
                    expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTFail("Expected failure, but got response: \(response)")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testFetchPostsBadRequest() {
        let url = URL(string: "https://dummyjson.com/posts/search?q=love&limit=10&skip=0")!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
            return (nil, httpResponse, nil)
        }
        
        let expectation = XCTestExpectation(description: "Fail with 400 Bad Request")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if let urlError = error as? URLError {
                        XCTAssertEqual(urlError.code, .badServerResponse)
                    } else {
                        XCTFail("Expected URLError, but got \(error)")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTFail("Expected failure, but got response: \(response)")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPostsNotFound() {
        let url = URL(string: "https://dummyjson.com/posts/search?q=love&limit=10&skip=0")!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let httpResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
            return (nil, httpResponse, nil)
        }
        
        let expectation = XCTestExpectation(description: "Fail with 404 Not Found")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if let urlError = error as? URLError {
                        XCTAssertEqual(urlError.code, .badServerResponse)
                    } else {
                        XCTFail("Expected URLError, but got \(error)")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTFail("Expected failure, but got response: \(response)")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPostsInternalServerError() {
        let url = URL(string: "https://dummyjson.com/posts/search?q=love&limit=10&skip=0")!
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, url)
            let httpResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (nil, httpResponse, nil)
        }
        
        let expectation = XCTestExpectation(description: "Fail with 500 Internal Server Error")
        
        PostService.shared.fetchPosts(limit: 10, skip: 0, search: "love")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if let urlError = error as? URLError {
                        XCTAssertEqual(urlError.code, .badServerResponse)
                    } else {
                        XCTFail("Expected URLError, but got \(error)")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTFail("Expected failure, but got response: \(response)")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

}
