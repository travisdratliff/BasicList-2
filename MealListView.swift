//
//  MealListView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation

struct MealListView: View {
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    @Bindable var categories: Category
    @Query var mealList: [Meal]
    @State private var mealName = ""
    @State private var showSheet = false
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    private var isValid: Bool {
        !mealName.isEmpty
    }
    var body: some View {
        NavigationStack {
            List {
                ForEach(mealList) { meal in
                    NavigationLink {
                        MealDetailView(meal: meal, categories: categories)
                    } label: {
                        Text(meal.name)
                    }
                }
                .onDelete { indexes in
                    for index in indexes {
                        deleteItem(mealList[index])
                    }
                }
            }
            .navigationTitle("Meals")
            .viewModifier()
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
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
                AddMealView()
            }
        }
        .onDisappear {
            isEditing = false
        }
    }
    func deleteItem(_ item: Meal) {
        context.delete(item)
    }
}

#Preview {
    MealListView(categories: Category())
        .modelContainer(for: Meal.self)
}
