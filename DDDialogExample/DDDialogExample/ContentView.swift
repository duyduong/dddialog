//
//  ContentView.swift
//  DDDialogExample
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingNavigationExample = false
    @State private var isShowingTabExample = false
    
    var body: some View {
        VStack(spacing: 16) {
            Button {
                isShowingNavigationExample = true
            } label: {
                Text("NavigationView example")
            }
            
            Button {
                isShowingTabExample = true
            } label: {
                Text("TabView example")
            }
        }
        .fullScreenCover(isPresented: $isShowingNavigationExample) {
            NavigationViewExample()
        }
        .fullScreenCover(isPresented: $isShowingTabExample) {
            TabBarViewExample()
        }
    }
}
