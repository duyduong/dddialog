//
//  Dialog.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

public protocol Dialog: Hashable {
    var id: String { get }
    
    /// Dialog placement `top`, `center` or `bottom`
    var placement: DialogPlacement { get }
    
    /// Dialog overlay (dim background), supports mono color or `UIBlurEffect.Style`
    var overlay: DialogOverlay { get }
    
    /// Whether allow to tap outside (dim background) to dismiss the dialog
    var shouldDismissOnTapOutside: Bool { get }
    
    /// Custom dialog animation
    var animation: Animation? { get }
    
    /// Custom dialog transition
    var transition: AnyTransition? { get }
}

// MARK: - Default values

public extension Dialog {
    var id: String { String(describing: self) }
    var placement: DialogPlacement { .bottom }
    var overlay: DialogOverlay { .color(.black.opacity(0.4)) }
    var shouldDismissOnTapOutside: Bool { true }
    var animation: Animation? { nil }
    var transition: AnyTransition? { nil }
}

// MARK: -

public enum DialogOverlay: Hashable {
    case color(Color)
    case effect(UIBlurEffect.Style)
}

public enum DialogPlacement: Hashable {
    case center
    case top
    case bottom
}

// MARK: - Default transitions

extension DialogPlacement {
    var defaultTransition: AnyTransition {
        switch self {
        case .top: return .move(edge: .top)
        case .bottom: return .move(edge: .bottom)
        case .center: return .opacity.combined(with: .zoom(from: 1.2))
        }
    }
}
