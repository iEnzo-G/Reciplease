import Foundation
import Alamofire

class RecipeService {
    
    func request(ingredientList: [String], completion: @escaping (Result<RecipeItem, Error>) -> Void) {
        let baseURL = URL(string: "https://api.edamam.com")!
        let url = RecipeEndpoint.get(ingredientList: ingredientList).url(baseURL: baseURL)
        AF.request(url).response { response in
            guard let data = response.data, let response = response.response else { return }
            do {
                completion(.success(try RecipeMapper.map(data: data, response: response)))
            }
            catch {
                completion(.failure(NetworkError.undecodableData))
            }
            
        }
    }
}
