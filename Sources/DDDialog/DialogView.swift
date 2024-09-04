//
//  DialogView.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

struct DialogContainerView<Content: View>: View {
    @Environment(DialogPresenter.self) private var presenter

    let placement: DialogPlacement
    let shouldDismissOnTapOutside: Bool
    let overlay: DialogOverlay
    let preferredAnimation: Animation?
    let preferredTransition: AnyTransition?
    let didDismiss: (() -> Void)?
    let content: () -> Content

    private let duration: Double = 0.35
    private var defaultAnimation: Animation { .easeInOut(duration: duration) }

    @State private var showedContent = false

    var body: some View {
        ZStack {
            if showedContent {
                overlayView
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        guard shouldDismissOnTapOutside else { return }
                        presenter.isPresented = false
                    }
                    .transition(.opacity.animation(defaultAnimation))

                contentView
            }
        }
        .onAppear {
            guard !presenter.isPresented else { return }
            presenter.isPresented = true
        }
        .onChange(of: presenter.isPresented) { _, isPresented in
            var animation: Animation = defaultAnimation
            if isPresented {
                if let preferredAnimation {
                    animation = preferredAnimation
                } else if placement == .center {
                    animation = .interpolatingSpring(stiffness: 300, damping: 15)
                }
                
                withAnimation(animation) {
                    showedContent = true
                }
            } else {
                withAnimation(animation) {
                    showedContent = false
                } completion: {
                    presenter.didDimiss?()
                    didDismiss?()
                }
            }
        }
    }

    init(
        placement: DialogPlacement = .bottom,
        shouldDismissOnTapOutside: Bool = false,
        overlay: DialogOverlay,
        preferredAnimation: Animation? = nil,
        preferredTransition: AnyTransition? = nil,
        didDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.placement = placement
        self.shouldDismissOnTapOutside = shouldDismissOnTapOutside
        self.overlay = overlay
        self.preferredAnimation = preferredAnimation
        self.preferredTransition = preferredTransition
        self.didDismiss = didDismiss
        self.content = content
    }
}

private extension DialogContainerView {
    @ViewBuilder
    var overlayView: some View {
        switch overlay {
        case let .color(color):
            color
        case let .effect(style):
            BlurEffectView(style: style)
        }
    }

    @ViewBuilder
    var contentView: some View {
        let transition = preferredTransition ?? placement.defaultTransition
        Group {
            switch placement {
            case .center:
                content()

            case .top:
                VStack {
                    content()
                    Spacer()
                }

            case .bottom:
                VStack {
                    Spacer()
                    content()
                }
            }
        }
        .transition(transition)
    }
}

// MARK: - ViewModifiers

struct DialogViewModifier<Item: Dialog, DialogContent: View>: ViewModifier {
    @Binding var item: Item?
    let content: (Item) -> DialogContent

    @Environment(DialogManager.self) private var manager

    func body(content: Content) -> some View {
        content.onChange(of: item) { _, newValue in
            if let newValue {
                manager.addDialog(id: newValue) {
                    DialogItemView(item: newValue) { dismissedItem in
                        manager.removeDialog(id: dismissedItem)
                        // If the dismissed item and the current is the same
                        // should change current to the last item in the list
                        if item == dismissedItem {
                            item = manager.getLastItem(with: Item.self)
                        }
                    } content: {
                        self.content($0)
                    }
                }
            } else {
                manager.dismissLastDialog(with: Item.self)
            }
        }
    }
}

struct DialogPresentedViewModifier<DialogContent: View>: ViewModifier {
    struct BoolDialog: Dialog {
        static func == (lhs: BoolDialog, rhs: BoolDialog) -> Bool {
            lhs.id == rhs.id
        }

        var id = UUID() // For unique
        let placement: DialogPlacement
        let overlay: DialogOverlay
        let shouldDismissOnTapOutside: Bool
        let animation: Animation?
        let transition: AnyTransition?

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    @Binding var isPresented: Bool
    let placement: DialogPlacement
    let overlay: DialogOverlay
    let shouldDismissOnTapOutside: Bool
    let animation: Animation?
    let transition: AnyTransition?
    let content: () -> DialogContent

    // To keep track of the current showing item
    @State private var presentingItem: BoolDialog?

    @Environment(DialogManager.self) private var manager

    func body(content: Content) -> some View {
        content.onChange(of: isPresented) { _, isPresented in
            if isPresented {
                let presentingItem = BoolDialog(
                    placement: placement,
                    overlay: overlay,
                    shouldDismissOnTapOutside: shouldDismissOnTapOutside,
                    animation: animation,
                    transition: transition
                )
                self.presentingItem = presentingItem
                manager.addDialog(id: presentingItem) {
                    DialogItemView(item: presentingItem) { dismissedItem in
                        manager.removeDialog(id: dismissedItem)
                        self.presentingItem = nil
                        self.isPresented = false
                    } content: { _ in
                        self.content()
                    }
                }
            } else if let presentingItem {
                manager.dismissDialog(id: presentingItem)
            }
        }
    }
}

struct DialogItemView<Item: Dialog, Content: View>: View {
    let item: Item
    let didDismiss: (Item) -> Void
    let content: (Item) -> Content

    var body: some View {
        DialogContainerView(
            placement: item.placement,
            shouldDismissOnTapOutside: item.shouldDismissOnTapOutside,
            overlay: item.overlay,
            preferredAnimation: item.animation,
            preferredTransition: item.transition
        ) {
            didDismiss(item)
        } content: {
            content(item)
        }
    }
}

struct SetupDialogsViewModifier: ViewModifier {
    @State private var manager = DialogManager()

    func body(content: Content) -> some View {
        ZStack {
            content
            ForEach(manager.dialogs, id: \.self) {
                $0.contentView
            }
        }
        .environment(manager)
    }
}
