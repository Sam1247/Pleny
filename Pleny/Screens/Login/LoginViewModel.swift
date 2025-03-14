//
//  LoginViewModel.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var loginFailed = false
    @Published var isLoading = false
    
    var authCoordinator: AuthCoordinatorProtocol? = nil
    
    private let predefinedUsername = "user"
    private let predefinedPassword = "password"
    
    func authenticateUser() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.username == self.predefinedUsername && self.password == self.predefinedPassword {
                self.loginFailed = false
                print("Login successful!")
                self.authCoordinator?.login()
            } else {
                self.loginFailed = true
            }
            self.isLoading = false
        }
    }
}
