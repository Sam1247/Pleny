//
//  LoginServiceTests.swift
//  PlenyTests
//
//  Created by Abdalla Elsaman on 16/03/2025.
//

import XCTest
import Combine
import XCTest
import Combine
@testable import Pleny

class LoginServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        cancellables = nil
        super.tearDown()
    }
    
    func testLogin_Success() {
        let loginResponse = LoginResponse(accessToken: "valid_access_token",
                                          refreshToken: "valid_refresh_token",
                                          username: "testuser")
        let data = try! JSONEncoder().encode(loginResponse)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)
            return (data, response, nil)
        }
        
        let loginService = LoginService.shared
        
        let expectation = self.expectation(description: "Login Success")
        var result: LoginResponse?
        var loginError: Error?
        
        loginService.login(username: "testuser", password: "password")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    loginError = error
                }
            }, receiveValue: { response in
                result = response
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertNil(loginError, "Expected no error, but got: \(String(describing: loginError))")
        XCTAssertEqual(result?.accessToken, "valid_access_token", "Expected a valid access token, but got: \(String(describing: result?.accessToken))")
        XCTAssertEqual(result?.refreshToken, "valid_refresh_token", "Expected a valid refresh token, but got: \(String(describing: result?.refreshToken))")
        XCTAssertEqual(result?.username, "testuser", "Expected username to be 'testuser', but got: \(String(describing: result?.username))")
    }
    
    func testLogin_Failure_InvalidResponse() {
        let invalidData = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)
            return (invalidData, response, nil)
        }
        
        let loginService = LoginService.shared

        let expectation = self.expectation(description: "Login Failure")
        var loginError: Error?
        
        loginService.login(username: "testuser", password: "password")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    loginError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertNotNil(loginError, "Expected error, but got none.")
        XCTAssertTrue(loginError is URLError, "Expected URLError, but got: \(String(describing: loginError))")
    }
    
    func testLogin_Failure_DecodingError() {
        let invalidData = "invalid data".data(using: .utf8)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)
            return (invalidData, response, nil)
        }
        
        let loginService = LoginService.shared

        let expectation = self.expectation(description: "Login Failure - Decoding Error")
        var loginError: Error?
        
        loginService.login(username: "testuser", password: "password")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    loginError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertNotNil(loginError, "Expected error, but got none.")
        XCTAssertTrue(loginError is DecodingError, "Expected DecodingError, but got: \(String(describing: loginError))")
    }
}
