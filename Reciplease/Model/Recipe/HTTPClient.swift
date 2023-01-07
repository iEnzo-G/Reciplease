import Foundation
import Alamofire

protocol HTTPClient {
    func request(from url: URL, completion: @escaping (Data?, HTTPURLResponse?) -> Void)
}

final class AlamofireHTTPClient: HTTPClient {
    func request(from url: URL, completion: @escaping (Data?, HTTPURLResponse?) -> Void) {
        AF.request(url).response { result in
            completion(result.data, result.response)
        }
    }
}
