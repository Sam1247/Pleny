//
//  HeaderView.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 15/03/2025.
//

import SwiftUI

struct HeaderView: View {
    @State var searching: Bool = true
    @Binding var searchQuery: String
    enum FocusedField {
        case searchQuery
    }
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    
                    Image("logo")
                        .scaleEffect(searching ? 1: 0)
                        .opacity(searching ? 1: 0)
                        .animation(.spring(), value: searching)
                    
                    
                    HStack {
                        Image("smallSearch")
                            .opacity(searching ? 0: 1)
                        TextField("Search", text: $searchQuery)
                            .foregroundStyle(.blue)
                            .opacity(searching ? 0: 1)
                            .frame(maxWidth: Constants.screenWidth)
                            .focused($focusedField, equals: .searchQuery)
                    }
                    .scaleEffect(searching ? 0: 1)
                    .animation(.spring(), value: searching)
                }
                
                ZStack {
                    Image("search")
                        .scaleEffect(searching ? 1: 0)
                        .onTapGesture {
                            searching.toggle()
                            focusedField = .searchQuery
                            
                        }
                        .animation(.spring(), value: searching)
                    
                    Image("close")
                        .scaleEffect(searching ? 0: 1)
                        .animation(.spring(), value: searching)
                        .onTapGesture {
                            searching.toggle()
                            focusedField = nil
                            searchQuery = ""
                        }
                }
            }
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Constants.Colors.separatorColor, lineWidth: 2)
                    .frame(maxWidth: searching ? 300: Constants.screenWidth)
                    .opacity(searching ? 0: 1)
                    .animation(.spring(), value: searching)
            )
            .padding(.horizontal)
        }.padding(.bottom, 8)
        
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Constants.Colors.separatorColor)

    }
}
