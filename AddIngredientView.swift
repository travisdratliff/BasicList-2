//
//  AddIngredientView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation

struct AddIngredientView: View {
    @Bindable var meal: Meal
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var showForm = false
    @State private var showAlert = false
    @State private var name = ""
    @State private var type = ""
    @State private var alertMessage = ""
    let types = ["Shelf", "Cold", "Frozen"]
    private var isValid: Bool {
        !name.isReallyEmpty && !type.isEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                } header: {
                    Text("ingredient details")
                        .categoryHeadline()
                }
            }
            .navigationTitle("Add Ingredient")
            .interactiveDismissDisabled()
            .viewModifier()
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        if isValid {
                            let ingredient = Meal.Ingredient(name: name, type: type)
                            meal.ingredients.append(ingredient)
                            name = ""
                            type = ""
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Meal.self, configurations: config)
        let mealExample = Meal(name: "meal", ingredients: [])
        return AddIngredientView(meal: mealExample)
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
