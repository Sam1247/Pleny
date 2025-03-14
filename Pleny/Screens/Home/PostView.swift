//
//  PostView\.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import SwiftUI

struct PostView: View {
    let imagesPaths: [String]
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image("profile")
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
            Text("Craving something delicious? Try our new dish - a savory mix of roasted vegetables and quinoa, topped with a zesty garlic. Yum!")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Constants.Colors.textColor)
                .padding(.horizontal)
            if imagesPaths.count == 1 {
                Image(imagesPaths[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.screenWidth - 36)
                    .cornerRadius(8)
            } else if imagesPaths.count == 2 {
                HStack(spacing: 3) {
                    Image(imagesPaths[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constants.screenWidth - 36) / 2, height: 343)
                        .cornerRadius(8, corners: .topLeft)
                        .cornerRadius(8, corners: .bottomLeft)


                    Image(imagesPaths[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constants.screenWidth - 36) / 2, height: 343)
                        .cornerRadius(8, corners: .topRight)
                        .cornerRadius(8, corners: .bottomRight)


                }
            } else if imagesPaths.count == 3 {
                HStack(spacing: 3) {
                    Image(imagesPaths[0])
                        .resizable()
                        .scaledToFill()
                        .frame(width: (Constants.screenWidth - 36) / 2, height: 343)
                        .cornerRadius(8, corners: .topLeft)
                        .cornerRadius(8, corners: .bottomLeft)


                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topRight)
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomRight)

                    }


                }

            } else if imagesPaths.count == 4 {
                HStack {
                    
                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topLeft)
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomLeft)

                    }


                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topRight)
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomRight)

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
                        
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .bottomLeft)

                    }


                    VStack(spacing: 3) {
                        Image(imagesPaths[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: (Constants.screenWidth - 36) / 2, height: 343 / 2 - 1.5)
                            .cornerRadius(8, corners: .topRight)
                        
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


                    }
                }

            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Constants.Colors.separatorColor)
                .padding(.top, 6)

        }.padding(.top)
    }
}

