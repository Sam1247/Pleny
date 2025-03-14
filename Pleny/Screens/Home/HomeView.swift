//
//  HomeView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeCoordinator: HomeCoordinator

    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.largeTitle)

            Button("Go to Profile") {
                homeCoordinator.showProfile()
            }
            .padding()

            Button("Go to Gallery") {
                homeCoordinator.showGallery()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(homeCoordinator: HomeCoordinator())
}
