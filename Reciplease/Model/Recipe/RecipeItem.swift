import Foundation

struct RecipeItem: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let image: String?
    let url: String
    let ingredientLines: [String]
    let totalTime: Int?
}
