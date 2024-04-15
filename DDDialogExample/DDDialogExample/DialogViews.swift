//
//  DialogViews.swift
//  DDDialogExample
//
//  Created by Duong Dao on 15/04/2024.
//

import SwiftUI

struct TopDialogView: View {
    @Environment(\.dialogPresenter) private var dialogPresenter
    
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Top dialog title")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            Color(.separator)
                .frame(height: 1)
            VStack {
                Text(message)
                    .font(.body)
                    .frame(maxWidth: .infinity)
                    
                Button {
                    dialogPresenter.dismiss()
                } label: {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(
            Color.white
                .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                .ignoresSafeArea(edges: .top)
        )
    }
}

struct CenterDialogView: View {
    @Environment(\.dialogPresenter) private var dialogPresenter
    
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Center dialog title")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            Color(.separator)
                .frame(height: 1)
            VStack {
                Text(message)
                    .font(.body)
                    .frame(maxWidth: .infinity)
                    
                Button {
                    dialogPresenter.dismiss()
                } label: {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
        )
        .padding(.horizontal, 24)
    }
}

struct BottomDialogView: View {
    @Environment(\.dialogPresenter) private var dialogPresenter
    
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Bottom dialog title")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            Color(.separator)
                .frame(height: 1)
            VStack {
                Text(message)
                    .font(.body)
                    .frame(maxWidth: .infinity)
                    
                Button {
                    dialogPresenter.dismiss()
                } label: {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(
            Color.white
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
