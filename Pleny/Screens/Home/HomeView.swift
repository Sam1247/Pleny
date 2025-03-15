//
//  HomeView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 14/03/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeCoordinator: HomeCoordinator
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top)
            } else {
                List {
                    ForEach(viewModel.posts, id: \.id) { post in
                        PostView(post: post)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                if viewModel.posts.last?.id == post.id {
                                    viewModel.loadMorePosts()
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
            Spacer()
        }.onAppear {
            viewModel.fetchPosts()
        }
    }
}

#Preview {
    HomeView(homeCoordinator: HomeCoordinator())
}
