import Foundation

class RecipeImageService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = AlamofireHTTPClient()) {
        self.httpClient = httpClient
    }
    
    func request(image: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: image) else { return }
        httpClient.request(from: url, completion: { data, response in
            guard let data = data, response?.statusCode == 200 else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        })
    }
}
