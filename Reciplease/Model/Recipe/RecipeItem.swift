import Foundation

struct RecipeItem: Decodable {
    let hits: [Hit]
    let _links: Links
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    let calories: Double
    let totalTime: Int
}

struct Links: Decodable {
    let next: Next
}

struct Next: Decodable {
    let href: String
}
