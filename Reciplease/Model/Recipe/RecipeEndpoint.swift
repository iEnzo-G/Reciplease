import Foundation

enum RecipeEndpoint{
    case get(ingredientList: [String])
    
    func url(baseURL: URL) -> URL {
        switch self {
        case let .get(ingredientList):
            var components = URLComponents()
            
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = "/api/recipes/v2"
            components.queryItems = [
                URLQueryItem(name: "type", value: "public"),
                URLQueryItem(name: "q", value: ingredientList.joined(separator: ",")),
                URLQueryItem(name: "app_id", value: APIConfig.apiID),
                URLQueryItem(name: "app_key", value: APIConfig.apiKey)
            ]
            return components.url!
        }
    }
}
