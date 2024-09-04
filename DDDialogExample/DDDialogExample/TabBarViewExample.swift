//
//  TabBarViewExample.swift
//  DDDialogExample
//
//  Created by Duong Dao on 15/04/2024.
//

import SwiftUI
import DDDialog

struct TabBarViewExample: View {
    enum Tab: CaseIterable {
        case home
        case setting
        
        var image: Image {
            switch self {
            case .home: return Image(systemName: "house.fill")
            case .setting: return Image(systemName: "gear.circle.fill")
            }
        }
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .setting: return "Settings"
            }
        }
    }
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var selection: Tab?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(Tab.allCases, id: \.self) {
                tabView(tab: $0)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.black, for: .tabBar)
            }
        }
        .setupPopover()
        .setupDialogs() // <- Put it here to cover the whole navigation view (including navigation bar) and tab bar
    }
    
    func tabView(tab: Tab) -> some View {
        NavigationView {
            switch tab {
            case .home: HomeView()
            case .setting: SettingsView()
            }
        }
        .tabItem {
            VStack {
                tab.image
                Text(tab.title)
            }
        }
        .tag(tab)
    }
}

// MARK: -

struct HomeView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            ExampleView(navigationBarColor: .green)
            Spacer()
            NavigationLink {
                MultipleDialogExampleView(navigationBarColor: .yellow)
                    // Uncomment this to see the effect the root point overriden
                    // The dialog then won't cover the navigation bar and tab bar as root point is inside this view
                    // .setupDialogs()
            } label: {
                Text("Push to another view")
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 40)
        }
        .padding(16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: 15)
                }
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ExampleView(navigationBarColor: .red)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 15)
                    }
                }
            }
    }
}
