//
//  PopoverManager.swift
//  DDDialog
//
//  Created by Duong Dao on 4/9/24.
//

import Combine
import SwiftUI
import Observation

@Observable
final class PopoverManager {
    struct Item: Identifiable, Equatable {
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id
        }

        let id: UUID
        let view: AnyView

        private let presenter = DialogPresenter()

        var contentView: some View {
            view
                .environment(presenter)
                .environment(\.dialogPresenter, presenter)
        }
    }

    let coordinateSpace = UUID().uuidString
    var items: [Item] = []

    func removeItem(with id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return
        }
        items.remove(at: index)
    }
}
