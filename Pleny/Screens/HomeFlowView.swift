//
//  HomeFlowView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

struct HomeTabView: View {
    @ObservedObject var homeCoordinator: HomeCoordinator
    
    var body: some View {
        TabView(selection: $homeCoordinator.currentScreen) {
            // Home Tab
            HomeView(homeCoordinator: homeCoordinator)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(HomeScreen.home)
            
            // Marketplace Tab
            MarketplaceView()
                .tabItem {
                    Label("Marketplace", systemImage: "cart.fill")
                }
                .tag(HomeScreen.marketplace)
            
            // Add New Post Tab
            AddNewPostView()
                .tabItem {
                    Label("Add Post", systemImage: "plus.circle.fill")
                }
                .tag(HomeScreen.addNewPost)
            
            // Gallery Tab
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.fill")
                }
                .tag(HomeScreen.gallery)
            
            // Profile Tab
            ProfileView(homeCoordinator: homeCoordinator)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(HomeScreen.profile)
        }
    }
}

#Preview {
    HomeTabView(homeCoordinator: HomeCoordinator())
}
