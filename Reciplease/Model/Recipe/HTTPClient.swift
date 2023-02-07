import Foundation
import Alamofire

protocol HTTPClient {
    func request(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

final class AlamofireHTTPClient: HTTPClient {
    
    func request(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        AF.request(url).response { result in
            guard result.error == nil else {
                completion(.failure(result.error!))
                return
            }
            guard let data = result.data, let response = result.response, response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success((data, response)))
        }
    }
}
