//
//  DialogManager.swift
//  DDDialog
//
//  Created by Duong Dao on 11/04/2024.
//

import SwiftUI

final class DialogManager: ObservableObject {
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
                .environmentObject(presenter)
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
    @Published var dialogs: [DialogItem] = []
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
        guard let presenter = dialogs.last(where: { ($0.id as? ID) == id })?.presenter else { return }
        // Call this for dismiss animation
        // The view will call `removeDialog` after animation completed
        presenter.isPresented = false
    }

    func dismissLastDialog<ID: Hashable>(with id: ID.Type) {
        guard let presenter = dialogs.last(where: { ($0.id as? ID) != nil })?.presenter else { return }
        // Call this for dismiss animation
        // The view will call `removeDialog` after animation completed
        presenter.isPresented = false
    }
}
