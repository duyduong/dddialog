//
//  View+Dialog.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

// MARK: - For usage in each view

public extension View {
    /// Present a dialog by a specific item
    func dialog<Item: Dialog, Content: View>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        modifier(DialogViewModifier(item: item, content: content))
    }

    /// Present a dialog using bool flag
    func dialog<Content: View>(
        isPresented: Binding<Bool>,
        placement: DialogPlacement = .bottom,
        overlay: DialogOverlay = .color(.black.opacity(0.4)),
        shouldDismissOnTapOutside: Bool = true,
        animation: Animation? = nil,
        transition: AnyTransition? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DialogPresentedViewModifier(
            isPresented: isPresented,
            placement: placement,
            overlay: overlay,
            shouldDismissOnTapOutside: shouldDismissOnTapOutside,
            animation: animation,
            transition: transition,
            content: content
        ))
    }
}

// MARK: - Setup at root point

public extension View {
    /// Setup root point for dialog
    ///
    /// This can be called many times, the nearest setup will be used
    func setupDialogs() -> some View {
        modifier(SetupDialogsViewModifier())
    }
}
