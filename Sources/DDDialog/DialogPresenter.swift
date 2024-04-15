//
//  DialogPresenter.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

/// Dialog presenter object, use for dismiss a dialog manually
public final class DialogPresenter: ObservableObject {
    var didDimiss: (() -> Void)?
    @Published var isPresented = false

    /// Dismiss the current dialog with completion callback (animation finished)
    public func dismiss(completion: (() -> Void)? = nil) {
        didDimiss = completion
        isPresented = false
    }
}

// MARK: -

public extension EnvironmentValues {
    internal(set) var dialogPresenter: DialogPresenter {
        get { self[DialogPresenterKey.self] }
        set { self[DialogPresenterKey.self] = newValue }
    }
}

private struct DialogPresenterKey: EnvironmentKey {
    static let defaultValue = DialogPresenter()
}
