import Foundation

struct RecipeMapper {
    static func map(data: Data, response: HTTPURLResponse) throws -> RecipeItem {
        guard response.statusCode == 200, let response = try? JSONDecoder().decode(RecipeItem.self, from: data) else {
            throw NetworkError.undecodableData
        }
        return response
    }
}
