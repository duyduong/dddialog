//
//  DialogManager.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

@Observable
final class DialogManager {
    // The item pushed into stacks
    struct DialogItem: Hashable {
        static func == (lhs: DialogItem, rhs: DialogItem) -> Bool {
            lhs.id == rhs.id
        }

        let id: AnyHashable
        let presenter = DialogPresenter()
        private let content: () -> AnyView

        var contentView: some View {
            content()
                .environment(presenter)
        }

        init(id: AnyHashable, content: @escaping () -> AnyView) {
            self.id = id
            self.content = content
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // Stacks for storing all presented dialogs
    var dialogs: [DialogItem] = []
}

extension DialogManager {
    func addDialog<ID: Hashable, Content: View>(
        id: ID,
        @ViewBuilder content: @escaping () -> Content
    ) {
        guard !dialogs.contains(where: { ($0.id as? ID) == id }) else { return }
        dialogs.append(DialogItem(id: id) { AnyView(content()) })
    }

    func getLastItem<ID: Hashable>(with id: ID.Type) -> ID? {
        dialogs.last?.id as? ID
    }

    func removeDialog<ID: Hashable>(id: ID) {
        guard let index = dialogs.firstIndex(where: { ($0.id as? ID) == id }) else { return }
        dialogs.remove(at: index)
    }

    func dismissDialog<ID: Hashable>(id: ID) {
        let lastItem = dialogs.last(where: { ($0.id as? ID) == id })
        guard let presenter = lastItem?.presenter else { return }
        // Call this for dismiss animation
        // The view will call `removeDialog` after animation completed
        presenter.isPresented = false
    }

    func dismissLastDialog<ID: Hashable>(with id: ID.Type) {
        let lastItem = dialogs.last(where: { ($0.id as? ID) != nil })
        guard let presenter = lastItem?.presenter else { return }
        // Call this for dismiss animation
        // The view will call `removeDialog` after animation completed
        presenter.isPresented = false
    }
}
