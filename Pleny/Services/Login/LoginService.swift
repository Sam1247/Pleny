//
//  LoginService.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import Foundation
import Combine

protocol LoginServiceProtocol {
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error>}

class LoginService: LoginServiceProtocol {
    
    static let shared = LoginService()
    private let baseURL = "https://dummyjson.com/auth/login"
    
    private init() {}
    
    func login(username: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let loginRequest = LoginRequest(username: username, password: password, expiresInMins: 30)

        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("include", forHTTPHeaderField: "credentials")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                // Check the HTTP status code here
                if let httpResponse = output.response as? HTTPURLResponse,
                   (200...299).contains(httpResponse.statusCode) {
                    return output
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .map(\.data)
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
