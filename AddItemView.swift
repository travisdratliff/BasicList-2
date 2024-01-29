//
//  AddItemView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation

struct AddItemView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Bindable var categories: Category
    @State private var name = ""
    @State private var type = ""
    private var isValid: Bool {
        !name.isReallyEmpty && !type.isEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .keyboardType(.default)
                    Picker("Type", selection: $type) {
                        ForEach(categories.types, id: \.self) {
                            Text($0)
                        }
                    }
                } header: {
                    Text("item details")
                        .categoryHeadline()
                }
            }
            .viewModifier()
            .interactiveDismissDisabled()
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if isValid {
                            let listItem = ListItem(name: name, type: type, picked: false)
                            context.insert(listItem)
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            name = ""
                            type = ""
                            dismiss()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .buttonColor()
                    }
                }
            }
        }
    }
}

#Preview {
    AddItemView(categories: Category())
        .modelContainer(for: ListItem.self)
}
