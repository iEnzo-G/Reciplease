import Foundation

final class RecipeService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = AlamofireHTTPClient()) {
        self.httpClient = httpClient
    }
    
    private func baseRequest(url: URL, completion: @escaping (Result<RecipeItem, Error>) -> Void) {
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
