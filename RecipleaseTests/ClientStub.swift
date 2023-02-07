import XCTest
@testable import Reciplease

class ClientStub: HTTPClient {
    
    let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func request(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        completion(result)
    }
}

