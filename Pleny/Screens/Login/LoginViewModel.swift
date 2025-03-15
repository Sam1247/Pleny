//
//  LoginViewModel.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = "emilys"
    @Published var password = "emilyspass"
    @Published var loginFailed = false
    @Published var isLoading = false
    
    var authCoordinator: AuthCoordinatorProtocol? = nil
    private var loginService: LoginServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    @Published var errorMessage: String? = nil

    init(loginService: LoginServiceProtocol = LoginService.shared) {
        self.loginService = loginService
    }
    
    func authenticateUser() {
        let username = self.username.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate inputs
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        loginService.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false

            }, receiveValue: { [weak self] response in
                guard let self else { return }
                print("Login Successful! Token: \(response.accessToken)")
                self.authCoordinator?.login()
            })
            .store(in: &cancellables)
    }
}
