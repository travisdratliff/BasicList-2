//
//  MealDetailView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation

struct MealDetailView: View {
    @Bindable var meal: Meal
    @Bindable var categories: Category
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    @State private var alertMessage = ""
    @State private var showSheet = false
    @State private var showAlert = false
    @State private var isEditing = false
    let types = ["Shelf", "Cold", "Frozen"]
    var body: some View {
        NavigationStack {
            List {
                ForEach(types, id: \.self) { type in
                    Section {
                        ForEach(meal.ingredients) { ingredient in
                            if ingredient.type == type {
                                Text(ingredient.name)
                            }
                        }
                        .onDelete(perform: removeRows)
                    } header: {
                        Text(type)
                            .categoryHeadline()
                    }
                }
            }
            .navigationTitle(meal.name)
            .viewModifier()
            .toolbar {
                ToolbarItemGroup {
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
                    Button {
                        for ingredient in meal.ingredients {
                            let listItem = ListItem(name: ingredient.name, type: ingredient.type, picked: false)
                            context.insert(listItem)
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        if meal.ingredients.isEmpty {
                            showAlert = true
                            alertMessage = "You need to add ingredients!"
                        } else {
                            showAlert = true
                            alertMessage = "Ingredients added to grocery list!"
                        }
                    } label: {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .buttonColor()
                    }
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .sheet(isPresented: $showSheet) {
                AddIngredientView(meal: meal)
            }
        }
        .onDisappear {
            isEditing = false
        }
    }
    func removeRows(at offsets: IndexSet) {
        meal.ingredients.remove(atOffsets: offsets)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Meal.self, configurations: config)
        let mealExample = Meal(name: "meal", ingredients: [])
        return MealDetailView(meal: mealExample, categories: Category())
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
