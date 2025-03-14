//
//  HomeCoordinator.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

enum HomeScreen {
    case home
    case marketplace
    case addNewPost
    case gallery
    case profile
}

class HomeCoordinator: ObservableObject {
    @Published var currentScreen: HomeScreen = .home

    func showProfile() {
        currentScreen = .profile
    }
    
    func showMarketplace() {
        currentScreen = .marketplace
    }
    
    func showAddNewPost() {
        currentScreen = .addNewPost
    }
    
    func showGallery() {
        currentScreen = .gallery
    }
    
    func showHome() {
        currentScreen = .home
    }

}
