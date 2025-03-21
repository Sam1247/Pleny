//
//  AuthCoordinator.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

protocol AuthCoordinatorProtocol {
    func login()
}

class AuthCoordinator: ObservableObject, AuthCoordinatorProtocol {
    @Published var isAuthenticated = false
    private let mainCoordinator: MainCoordinator

    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
    }

    func login() {
        isAuthenticated = true
        mainCoordinator.showHome()
    }
}
