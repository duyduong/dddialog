//
//  AnyTransition+Zoom.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

public extension AnyTransition {
    static func zoom(from: CGFloat, to: CGFloat = 1) -> AnyTransition {
        AnyTransition.modifier(
            active: ZoomInModifier(scale: from),
            identity: ZoomInModifier(scale: to)
        )
    }
}

private struct ZoomInModifier: ViewModifier {
    let scale: CGFloat

    func body(content: Content) -> some View {
        content.scaleEffect(scale)
    }
}
