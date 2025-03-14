//
//  LoginView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @ObservedObject var authCoordinator: AuthCoordinator

    var body: some View {
        VStack {
            Text("Login Screen")
                .font(.largeTitle)

            Button("Login") {
                authCoordinator.login()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(authCoordinator: AuthCoordinator(mainCoordinator: MainCoordinator()))
}
