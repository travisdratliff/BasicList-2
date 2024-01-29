//
//  AddCategoryView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/24/24.
//

import SwiftUI
import Observation

struct AddCategoryView: View {
    @Bindable var categories: Category
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    private var isValid: Bool {
        !name.isReallyEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                } header: {
                    Text("category details")
                        .categoryHeadline()
                }
            }
            .viewModifier()
            .interactiveDismissDisabled()
            .navigationTitle("Add Category")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if isValid {
                            categories.types.append(name)
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(categories.types, forKey: "types")
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
    AddCategoryView(categories: Category())
}
