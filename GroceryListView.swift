//
//  GroceryListView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation

struct GroceryListView: View {
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    @Bindable var categories: Category
    @Query var groceryList: [ListItem]
    @State private var showSheet = false
    @State private var showAlert = false
    @State private var isEditing = false
    @State private var alertMessage = ""
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories.types, id: \.self) { type in
                    Section {
                        ForEach(groceryList) { item in
                            if item.type == type {
                                ListItemView(listItem: item)
                            }
                        }
                        .onDelete { indexes in
                            for index in indexes {
                                deleteItem(groceryList[index])
                            }
                        }
                    } header: {
                        Text(type)
                            .categoryHeadline()
                    }
                }
            }
            .viewModifier()
            .navigationTitle("Groceries & Items")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        alertMessage = "Do you want to delete all items in the grocery list?"
                        showAlert = true
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundColor(isEditing ? .red : colorScheme == .light ? .white : .black)
                    }
                    .disabled(!isEditing)
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: isEditing ? "minus.circle.fill" : "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(isEditing ? .red : colorScheme == .light ? .black : .white) 
                    }
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .buttonColor()
                    }
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .sheet(isPresented: $showSheet) {
                AddItemView(categories: categories)
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .destructive) {
                    do {
                        try context.delete(model: ListItem.self)
                    } catch{
                        fatalError()
                    }
                    isEditing.toggle()
                }
                Button("Cancel", role: .cancel) {
                    isEditing.toggle()
                }
            }
        }
        .onDisappear {
            isEditing = false
        }
    }
    func deleteItem(_ item: ListItem) {
        context.delete(item)
    }
}

#Preview {
    GroceryListView(categories: Category())
        .modelContainer(for: ListItem.self)
}
