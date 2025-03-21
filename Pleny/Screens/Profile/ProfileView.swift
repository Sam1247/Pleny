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
            ScrollView {


            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ProfileView(homeCoordinator: HomeCoordinator())
}
