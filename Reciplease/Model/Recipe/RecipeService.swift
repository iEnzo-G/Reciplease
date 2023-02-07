import Foundation

final class RecipeService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = AlamofireHTTPClient()) {
        self.httpClient = httpClient
    }
    
    private func baseRequest(url: URL, completion: @escaping (Result<RecipeItem, Error>) -> Void) {
        httpClient.request(from: url, completion: { result in
            switch result {
            case let .success((data, response)):
                do {
                    completion(.success(try RecipeMapper.map(data: data, response: response)))
                }
                catch {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func request(ingredientList: [String], completion: @escaping (Result<RecipeItem, Error>) -> Void) {
        guard let baseURL = URL(string: "https://api.edamam.com") else { return }
        let url = RecipeEndpoint.get(ingredientList: ingredientList).url(baseURL: baseURL)
        baseRequest(url: url, completion: completion)
    }
    
    func requestMore(url: String, completion: @escaping (Result<RecipeItem, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        baseRequest(url: url, completion: completion)
    }
}
