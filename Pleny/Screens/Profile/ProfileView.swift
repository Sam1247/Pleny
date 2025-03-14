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
        VStack(spacing: 0) {
            HeaderView()
            ScrollView {
                PostView(imagesPaths: [])
                PostView(imagesPaths: ["postImage"])
                PostView(imagesPaths: ["postImage", "postImage"])
                PostView(imagesPaths: ["postImage", "postImage", "postImage"])
                PostView(imagesPaths: ["postImage", "postImage", "postImage", "postImage", "postImage"])


            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ProfileView(homeCoordinator: HomeCoordinator())
}
