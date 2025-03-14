//
//  MainCoordinator.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

class MainCoordinator: ObservableObject {
    @Published var currentFlow: AppFlows = .auth
    @Published var homeCoordinator = HomeCoordinator()

    func showHome() {
        currentFlow = .app
    }

    func logout() {
        currentFlow = .auth
    }
}
