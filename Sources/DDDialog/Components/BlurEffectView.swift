//
//  BlurEffectView.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

public struct BlurEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    public func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}

    public init(style: UIBlurEffect.Style = .dark) {
        self.style = style
    }
}
