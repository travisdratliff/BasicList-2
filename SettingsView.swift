//
//  Settings.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/24/24.
//

import SwiftUI
import Observation
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    @Bindable var categories: Category
    @Query var groceryList: [ListItem]
    @State private var name = ""
    @State private var isEditing = false
    @State private var showSheet = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(categories.types, id: \.self) { type in
                        Text(type)
                    }
                    .onDelete(perform: removeRows)
                    .onMove(perform: move)
                } header: {
                    Text("")
                        .categoryHeadline()
                }
            }
            .viewModifier()
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: isEditing ? "minus.circle.fill" : "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(isEditing ? .red : colorScheme == .light ? .black : .white)
                    }
                    .buttonColor()
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonColor()
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .sheet(isPresented: $showSheet) {
                AddCategoryView(categories: categories)
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
        .onDisappear {
            isEditing = false
        }
    }
    func removeRows(at offsets: IndexSet) {
        if !groceryList.isEmpty {
            alertMessage = "Please delete all items in the grocery list before removing any categories."
            showAlert.toggle()
        } else {
            categories.types.remove(atOffsets: offsets)
            let userDefaults = UserDefaults.standard
            userDefaults.set(categories.types, forKey: "types")
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        categories.types.move(fromOffsets: source, toOffset: destination)
        let userDefaults = UserDefaults.standard
        userDefaults.set(categories.types, forKey: "types")
    }
}

#Preview {
    SettingsView(categories: Category())
}
