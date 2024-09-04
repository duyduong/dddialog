//
//  View+OnFrameChange.swift
//  DDDialog
//
//  Created by Duong Dao on 4/9/24.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func onSizeChange(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy -> AnyView in
                DispatchQueue.main.async { onChange(proxy.size) }
                return AnyView(EmptyView())
            }
        )
    }

    @ViewBuilder
    func onFrameChange(
        coordinateSpace: CoordinateSpace,
        onChange: @escaping (CGRect) -> Void
    ) -> some View {
        background(
            GeometryReader { proxy -> AnyView in
                let rect = proxy.frame(in: coordinateSpace)
                DispatchQueue.main.async { onChange(rect) }
                return AnyView(EmptyView())
            }
        )
    }
}
