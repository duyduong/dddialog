//
//  NavigationViewExample.swift
//  DDDialogExample
//
//  Created by Duong Dao on 15/04/2024.
//

import SwiftUI
import DDDialog

struct NavigationViewExample: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            contentView
                .toolbarBackground(Color.blue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
        .setupDialogs() // <- Put it here to cover the whole navigation view (including navigation bar)
    }
    
    var contentView: some View {
        VStack {
            Spacer()
            ExampleView()
            Spacer()
            NavigationLink {
                ExampleView(navigationBarColor: .yellow)
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
        .navigationTitle("Navigation example")
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

// MARK: -

struct ExampleView: View {
    var navigationBarColor: Color = .blue
    @State private var isShowingDialog = false
    
    var body: some View {
        contentView
            .toolbarBackground(navigationBarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    var contentView: some View {
        VStack(spacing: 16) {
            Button {
                isShowingDialog = true
            } label: {
                Text("Show center dialog")
            }
        }
        .dialog(isPresented: $isShowingDialog, placement: .center) {
            CenterDialogView(message: "Example bottom dialog is showing")
        }
    }
}

struct MultipleDialogExampleView: View {
    struct MultipleDialog: Dialog {
        enum DialogType {
            case dialog1, dialog2
        }
        
        let content: String
        let type: DialogType
    }
    
    var navigationBarColor: Color = .blue
    @State private var dialog: MultipleDialog?
    
    var body: some View {
        contentView
            .toolbarBackground(navigationBarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
    
    var contentView: some View {
        VStack(spacing: 16) {
            Button {
                dialog = .init(
                    content: "Hi, how are you today?",
                    type: .dialog1
                )
            } label: {
                Text("Show Dialog 1")
            }
        }
        .dialog(item: $dialog) {
            DialogContentView(content: $0.content) {
                dialog = .init(
                    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    type: .dialog2
                )
            }
        }
    }
}

extension MultipleDialogExampleView {
    struct DialogContentView: View {
        @Environment(\.dialogPresenter) private var dialogPresenter
        
        let content: String
        let action: () -> Void
        
        var body: some View {
            VStack {
                Text(content)
                    .font(.title2)
                
                Button {
                    dialogPresenter.dismiss()
                    action()
                } label: {
                    Text("Next dialog")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(
                Color.white
                    .cornerRadius(8, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}
