import Foundation

class RecipeService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = AlamofireHTTPClient()) {
        self.httpClient = httpClient
    }
    
    func request(ingredientList: [String], completion: @escaping (Result<RecipeItem, Error>) -> Void) {
        let baseURL = URL(string: "https://api.edamam.com")!
        let url = RecipeEndpoint.get(ingredientList: ingredientList).url(baseURL: baseURL)
        httpClient.request(from: url, completion: { data, response in
            guard let data = data, let response = response else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                completion(.success(try RecipeMapper.map(data: data, response: response)))
            }
            catch {
                completion(.failure(NetworkError.undecodableData))
            }
        })
    }
}
