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
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 40) {
                    VStack (spacing: 24) {
                        Image("loginImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.screenWidth)
                        
                        
                        Text("Welcome")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Constants.Colors.themeColor)
                        
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("User Name")
                                .font(.system(size: 15, weight: .medium))
                            
                            
                            TextField("Username", text: $viewModel.username)
                                .padding(.all, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Constants.Colors.strokeColor, lineWidth: 2)
                                )
                                .cornerRadius(10)
                                .frame(width: Constants.screenWidth - 32)
                            
                        }
                        .padding(.horizontal)
                        
                        
                        
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.system(size: 15, weight: .medium))
                            
                            SecureField("Password", text: $viewModel.password)
                                .padding(.all, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Constants.Colors.strokeColor, lineWidth: 2)
                                )
                                .cornerRadius(10)
                                .frame(width: Constants.screenWidth - 32)
                        }
                        .padding(.horizontal)
                        
                        
                    }
                    
                    
                    Button(action: {
                        viewModel.authenticateUser()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.top)
                        } else {
                            Text("Sign in")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Constants.Colors.themeColor)
                                .foregroundColor(.white)
                                .cornerRadius(40)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .disabled(viewModel.isLoading)
                    
                }
            }
            .alert(viewModel.errorMessage ?? "", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { }
            }
            .onAppear {
                viewModel.authCoordinator = authCoordinator
            }
        }
    }
    
}

#Preview {
    LoginView(authCoordinator: AuthCoordinator(mainCoordinator: MainCoordinator()))
}
