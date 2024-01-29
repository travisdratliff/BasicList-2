//
//  Models and Extensions.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/22/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ListItem: Hashable {
    @Attribute(.unique) var name: String
    var type: String
    var picked: Bool
    init(name: String, type: String, picked: Bool) {
        self.name = name
        self.type = type
        self.picked = picked
    }
}

@Model
class Meal {
    struct Ingredient: Identifiable, Codable, Hashable {
        var id = UUID()
        var name: String
        var type: String
    }
    @Attribute(.unique) var name: String
    var ingredients: [Ingredient]
    init(name: String, ingredients: [Ingredient]) {
        self.name = name
        self.ingredients = ingredients
    }
}

@Observable
class Category {
    var types = [""]
}

