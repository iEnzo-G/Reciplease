import Foundation

struct RecipeItem: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    // Recipe name
    let label: String
    // Image 300px
    let image: String?
    // Website for more details
    let url: String
    // List of ingredients needed
    let ingredientLines: [String]
    // Time to cook, maybe minute ?
    let totalTime: Int?
}
