//
//  LoginModels.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

struct LoginRequest: Codable {
    let username: String
    let password: String
    let expiresInMins: Int
}

// LoginResponse.swift
struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let username: String
}

