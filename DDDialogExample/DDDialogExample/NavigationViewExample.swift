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
            if #available(iOS 16, *) {
                contentView
                    .toolbarBackground(Color.blue, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            } else {
                contentView
            }
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

struct ExampleView: View {
    var navigationBarColor: Color = .blue
    @State private var isShowingDialog = false
    
    var body: some View {
        if #available(iOS 16, *) {
            contentView
                .toolbarBackground(navigationBarColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } else {
            contentView
        }
    }
    
    var contentView: some View {
        VStack(spacing: 16) {
            Button {
                isShowingDialog = true
            } label: {
                Text("Show center dialog")
            }
        }
        .dialog(isPresented: $isShowingDialog) {
            CenterDialogView(message: "Example bottom dialog is showing")
        }
    }
}
