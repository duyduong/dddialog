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
    enum MyDialog: Dialog {
        case top(message: String)
        case center(message: String)
        case bottom(message: String)
        
        var placement: DialogPlacement {
            switch self {
            case .top: return .top
            case .center: return .center
            case .bottom: return .bottom
            }
        }
        
        var shouldDismissOnTapOutside: Bool {
            false
        }
        
        var overlay: DialogOverlay {
            switch self {
            case .center: return .effect(.dark)
            default: return .color(.black.opacity(0.5))
            }
        }
    }
    
    var navigationBarColor: Color = .blue
    @State private var dialog: MyDialog?
    
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
                dialog = .top(message: "Example top dialog is showing")
            } label: {
                Text("Show top dialog")
            }
            
            Button {
                dialog = .center(message: "Example center dialog is showing")
            } label: {
                Text("Show center dialog")
            }
            
            Button {
                dialog = .bottom(message: "Example bottom dialog is showing")
            } label: {
                Text("Show bottom dialog")
            }
        }
        .dialog(item: $dialog) {
            switch $0 {
            case let .top(message): TopDialogView(message: message)
            case let .center(message): CenterDialogView(message: message)
            case let .bottom(message): BottomDialogView(message: message)
            }
        }
    }
}
