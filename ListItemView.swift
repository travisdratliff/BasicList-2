//
//  ListItemView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData

struct ListItemView: View {
    @Bindable var listItem: ListItem
    @Environment(\.colorScheme) var colorScheme
    @State private var showSheet = false
    var body: some View {
        HStack {
            Text(listItem.name)
            Spacer()
            Button {
                listItem.picked.toggle()
            } label: {
                Image(systemName: listItem.picked ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(colorScheme == .light ? .black : .white)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ListItem.self, configurations: config)
        let example = ListItem(name: "food", type: "Cold", picked: false/*, price: 0.0, amount: 1*/)
        return ListItemView(listItem: example)
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
