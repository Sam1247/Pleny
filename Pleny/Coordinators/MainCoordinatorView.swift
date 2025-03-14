//
//  ContentView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

import SwiftUI

struct MainCoordinatorView: View {
    @StateObject private var mainCoordinator = MainCoordinator()
    var body: some View {
        LoginView(authCoordinator: AuthCoordinator(mainCoordinator: mainCoordinator))
            .fullScreenCover(isPresented: .constant(mainCoordinator.currentFlow == .app)) {
                HomeTabView(homeCoordinator: mainCoordinator.homeCoordinator)
            }
    }
}
#Preview {
    MainCoordinatorView()
}
