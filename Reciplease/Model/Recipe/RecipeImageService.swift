import Foundation

final class RecipeImageService {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = AlamofireHTTPClient()) {
        self.httpClient = httpClient
    }
    
    func request(image: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: image) else { return }
        httpClient.request(from: url, completion: { result in
            switch result {
            case let .success((data, _)):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}



