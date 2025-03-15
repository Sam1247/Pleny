//
//  ImageViewer.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import SwiftUI

struct ImageViewer: View {
    let images: [String] // Array of image names
    @Binding var currentIndex: Int
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Background
            
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .gesture(
                            // Pinch to zoom
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { _ in
                                    withAnimation { scale = 1.0 }
                                }
                        )
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.height) > 200 {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        withAnimation { offset = .zero }
                    }
                }
        )

    }
}
