//
//  PostView\.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import SwiftUI

struct PostView: View {
//    private enum ViewerMode {
//        case profile
//        case gallery
//    }
//    
//    @State private var mode: ViewerMode = .gallery
    let imagesPaths: [String]
    @State private var showGalleryViewer = false
    @State private var showProfileImageViewer = false
    @State private var selectedImageIndex: Int = 0
    private let post: Post
    
    init(post: Post) {
        let imageCount = post.views % 6
        imagesPaths = [String](repeating: "postImage", count: imageCount)
        self.post = post
    }
    
    private func showGallery(with index: Int) {
        selectedImageIndex = index
        showGalleryViewer.toggle()
    }
    
    private func showProfileImage() {
        showProfileImageViewer.toggle()
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image("profile")
                    .onTapGesture {
                        showProfileImage()
                    }
                VStack(alignment: .leading) {
                    Text("Neama Ahmed")
                        .font(.system(size: 17, weight: .medium))
                    Text("2 days ago")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Constants.Colors.subLabelColor)
                }
                Spacer()
            }
            .padding(.horizontal)
            Text(post.body)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Constants.Colors.textColor)
                .padding(.horizontal)

            if imagesPaths.count == 1 {
                Image(imagesPaths[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.screenWidth - 36)
                    .cornerRadius(8)
                    .onTapGesture {
                        showGallery(with: 0)
                    }
            } else if imagesPaths.count == 2 {
                HStack(spacing: 3) {
                    Image(imagesPaths[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constants.screenWidth - 36) / 2, height: 343)
                        .cornerRadius(8, corners: .topLeft)
                        .cornerRadius(8, corners: .bottomLeft)
                        .onTapGesture {
                            showGallery(with: 0)
                        }
                    
                    
                    Image(imagesPaths[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constants.screenWidth - 36) / 2, height: 343)
                        .cornerRadius(8, corners: .topRight)
                        .cornerRadius(8, corners: .bottomRight)
                        .onTapGesture {
                            showGallery(with: 1)
                        }
                    
                    
                }
            } else if imagesPaths.count == 3 {
                HStack(spacing: 3) {
                    Image(imagesPaths[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constants.screenWidth - 36) / 2, height: 343)
                        .cornerRadius(8, corners: .topLeft)
                        .cornerRadius(8, corners: .bottomLeft)
                        .onTapGesture {
                            showGallery(with: 0)
                        }
                    
                    
                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topRight)
                            .onTapGesture {
                                showGallery(with: 1)
                            }
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomRight)
                            .onTapGesture {
                                showGallery(with: 2)
                            }
                        
                    }
                    
                    
                }
                
            } else if imagesPaths.count == 4 {
                HStack(spacing: 3) {
                    
                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topLeft)
                            .onTapGesture {
                                showGallery(with: 0)
                            }
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomLeft)
                            .onTapGesture {
                                showGallery(with: 1)
                            }
                        
                    }
                    
                    
                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topRight)
                            .onTapGesture {
                                showGallery(with: 2)
                            }
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomRight)
                            .onTapGesture {
                                showGallery(with: 3)
                            }
                        
                    }
                }
                
            } else if imagesPaths.count > 4 {
                HStack(spacing: 3) {
                    
                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topLeft)
                            .onTapGesture {
                                showGallery(with: 0)
                            }
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomLeft)
                            .onTapGesture {
                                showGallery(with: 1)
                            }
                        
                    }
                    
                    
                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topRight)
                            .onTapGesture {
                                showGallery(with: 2)
                            }
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .overlay {
                                ZStack {
                                    Rectangle()
                                        .fill(.black.opacity(0.6))
                                    Text("+\(imagesPaths.count - 4)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .cornerRadius(8, corners: .bottomRight)
                            .onTapGesture {
                                showGallery(with: 3)
                            }
                        
                    }
                }
                
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Constants.Colors.separatorColor)
                .padding(.top, 6)
            
        }
        .padding(.top)
        .fullScreenCover(isPresented: $showGalleryViewer) {
                ImageViewer(images: imagesPaths, currentIndex: $selectedImageIndex)
        }
        .fullScreenCover(isPresented: $showProfileImageViewer) {
            ImageViewer(images: ["profile"], currentIndex: .constant(0))
        }

    }
}

