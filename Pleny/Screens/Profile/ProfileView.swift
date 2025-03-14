//
//  ProfileView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var homeCoordinator: HomeCoordinator

    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)

            Button("Back to Marketplace") {
                homeCoordinator.showMarketplace()
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView(homeCoordinator: HomeCoordinator())
}
