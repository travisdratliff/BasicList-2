//
//  ContentView.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import SwiftUI
import SwiftData
import Observation 

struct ContentView: View {
    @State private var categories = Category()
    var body: some View {
        TabView {
            GroceryListView(categories: categories)  
                .tabItem {
                    Label {
                        Text("Groceries & Items")
                    } icon: {
                        Image(systemName: "carrot")
                    }
                }
            MealListView(categories: categories)
                .tabItem {
                    Label {
                        Text("Meals")
                    } icon: {
                        Image(systemName: "fork.knife")    
                    }
                }
            SettingsView(categories: categories) 
                .tabItem {
                    Label {
                        Text("Categories")
                    } icon: {
                        Image(systemName: "square.on.square")  
                    }
                }
        }
        .onAppear {
            let userDefaults = UserDefaults.standard
            categories.types = userDefaults.object(forKey: "types") as? [String] ?? ["Shelf", "Cold", "Frozen"]
        }
        .accentColor(.primary) 
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ListItem.self, Meal.self])
}
