//
//  AddMealView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation

struct AddMealView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query var mealList: [Meal]
    @State private var mealName = ""
    @State private var showForm = false
    private var isValid: Bool {
        !mealName.isReallyEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $mealName)
                } header: {
                    Text("meal details")
                        .categoryHeadline()
                }
            }
            .navigationTitle("Add Meal")
            .viewModifier()
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        if isValid {
                            let meal = Meal(name: mealName, ingredients: [])
                            context.insert(meal)
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            mealName = ""
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
    AddMealView()
        .modelContainer(for: Meal.self)
}
