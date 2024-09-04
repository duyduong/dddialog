//
//  View+UIPopover.swift
//  DDDialog
//
//  Created by Duong Dao on 4/9/24.
//

import SwiftUI

public extension View {
    func uiPopover<Content: View>(
        isPresented: Binding<Bool>,
        permittedArrow: PermittedArrow = .down,
        arrowColor: Color = .white,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PopoverViewModifier(
            isPresented: isPresented,
            permittedArrow: permittedArrow,
            arrowColor: arrowColor,
            content: content
        ))
    }
}

public extension View {
    /// Setup root point for global dialog
    func setupPopover() -> some View {
        modifier(SetupPopoverViewModifier())
    }
}

// MARK: -

public enum PermittedArrow: Hashable, Sendable {
    case up, down
}

// MARK: -

private struct SetupPopoverViewModifier: ViewModifier {
    @State private var manager = PopoverManager()

    func body(content: Content) -> some View {
        ZStack {
            content
            ForEach(manager.items) {
                $0.contentView
            }
        }
        .environment(manager)
        .animation(.easeInOut(duration: 0.25), value: manager.items)
    }
}

private struct PopoverViewModifier<PopoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let permittedArrow: PermittedArrow
    let arrowColor: Color
    let content: () -> PopoverContent

    @Environment(PopoverManager.self) private var manager
    @State private var frame: CGRect = .zero

    func body(content: Content) -> some View {
        content
            .onFrameChange(coordinateSpace: .named(manager.coordinateSpace)) {
                frame = $0
            }
            .onChange(of: isPresented) {
                if $1 {
                    let id = UUID()
                    manager.items.append(.init(id: id, view: AnyView(
                        PopoverView(
                            id: id,
                            preferredArrow: permittedArrow,
                            arrowColor: arrowColor,
                            itemFrame: $frame,
                            coordinateSpace: manager.coordinateSpace,
                            onDismiss: { dismissedId in
                                manager.removeItem(with: dismissedId)
                                isPresented = false
                            },
                            content: self.content
                        )
                    )))
                } else if !manager.items.isEmpty {
                    manager.items.removeLast()
                }
            }
    }
}

private struct PopoverView<Content: View>: View {
    let id: UUID
    let preferredArrow: PermittedArrow
    let arrowColor: Color
    @Binding var itemFrame: CGRect
    let coordinateSpace: String
    let onDismiss: (UUID) -> Void
    let content: () -> Content

    let verticalPadding: CGFloat = 24
    let horizontaPadding: CGFloat = 10

    @Environment(DialogPresenter.self) private var presenter: DialogPresenter
    @State private var containerFrame: CGRect = .zero
    @State private var contentFrame: CGRect = .zero

    var permittedArrow: PermittedArrow {
        guard contentFrame != .zero else {
            return preferredArrow
        }
        switch preferredArrow {
        case .down:
            return itemFrame.minY - contentFrame.height < verticalPadding ? .up : .down

        case .up:
            return itemFrame.maxY + contentFrame.height > containerFrame.height - verticalPadding ? .down : .up
        }
    }

    var contentOffsetY: CGFloat {
        switch permittedArrow {
        case .down: 
            return itemFrame.minY - contentFrame.height / 2
        case .up: 
            return itemFrame.maxY + contentFrame.height / 2
        }
    }

    var popoverOffsetX: CGFloat {
        if contentFrame.maxX > containerFrame.maxX - horizontaPadding {
            return -(contentFrame.maxX - containerFrame.maxX) - horizontaPadding
        }
        if contentFrame.minX < containerFrame.minX {
            return abs(contentFrame.minX) + horizontaPadding
        }
        return 0
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Overlay
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(presenter.isPresented ? 1 : 0)
                .onTapGesture { presenter.isPresented = false }

            hiddenContent
            popoverContent
        }
        .edgesIgnoringSafeArea(.all)
        .onFrameChange(coordinateSpace: .named(coordinateSpace)) {
            containerFrame = $0
        }
        .onChange(of: contentFrame) {
            guard $1 != .zero, !presenter.isPresented else { return }
            presenter.isPresented = true
        }
        .onChange(of: presenter.isPresented) {
            guard !$1 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                presenter.didDimiss?()
                onDismiss(id)
            }
        }
    }
}

private extension PopoverView {
    @ViewBuilder
    var popoverContent: some View {
        contentView(permittedArrow: permittedArrow) {
            content()
                .offset(x: popoverOffsetX, y: 0)
        }
        .opacity(presenter.isPresented ? 1 : 0)
        .position(CGPoint(
            x: itemFrame.centerPoint.x,
            y: contentOffsetY
        ))
        .frame(maxWidth: 320)
        .animation(.easeInOut(duration: 0.25), value: presenter.isPresented)
    }

    /// The hidden content for calculating frame
    var hiddenContent: some View {
        contentView(permittedArrow: preferredArrow) {
            content()
        }
        .onFrameChange(coordinateSpace: .named(coordinateSpace)) {
            contentFrame = $0
        }
        .position(itemFrame.centerPoint)
        .frame(maxWidth: 320)
        .hidden()
    }

    func contentView<C: View>(
        permittedArrow: PermittedArrow,
        @ViewBuilder content: () -> C
    ) -> some View {
        VStack(spacing: 0) {
            switch permittedArrow {
            case .up:
                arrow(.up)
                content()

            case .down:
                content()
                arrow(.down)
            }
        }
        .padding(permittedArrow == .down ? .bottom : .top, 8)
    }

    func arrow(_ permittedArrow: PermittedArrow) -> some View {
        Arrow(permittedArrow: permittedArrow)
            .fill(arrowColor)
            .frame(width: 24, height: 14)
    }
}

private extension PopoverView {
    struct Arrow: Shape {
        let permittedArrow: PermittedArrow

        func path(in rect: CGRect) -> Path {
            let cornerRadius: CGFloat = 4
            let path: Path
            switch permittedArrow {
            case .up:
                path = Path { path in
                    path.move(to: CGPoint(x: 0, y: rect.height))
                    path.addLine(to: CGPoint(x: (rect.width / 2) - cornerRadius, y: cornerRadius))
                    path.addArc(
                        tangent1End: CGPoint(x: rect.width / 2, y: 0),
                        tangent2End: CGPoint(x: (rect.width / 2) + cornerRadius, y: cornerRadius),
                        radius: cornerRadius
                    )
                    path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                    path.closeSubpath()
                }

            case .down:
                path = Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: (rect.width / 2) - cornerRadius, y: rect.height - cornerRadius))
                    path.addArc(
                        tangent1End: CGPoint(x: rect.width / 2, y: rect.height),
                        tangent2End: CGPoint(x: (rect.width / 2) + cornerRadius, y: rect.height - cornerRadius),
                        radius: cornerRadius
                    )
                    path.addLine(to: CGPoint(x: rect.width, y: 0))
                    path.closeSubpath()
                }
            }

            return path
        }
    }
}

// MARK: -

extension CGRect {
    var centerPoint: CGPoint {
        CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

// MARK: -

extension EnvironmentValues {
    private(set) var isPopoverPresented: Binding<Bool> {
        get { self[PopoverPresentedKey.self] }
        set { self[PopoverPresentedKey.self] = newValue }
    }
}

private struct PopoverPresentedKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}
