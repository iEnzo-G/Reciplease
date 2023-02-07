import XCTest
@testable import Reciplease

final class RecipeImageServiceTests: XCTestCase {
    
    func test_GivenImageUrl_ThenSendBackImageData() {
        
        let exp = expectation(description: "Waiting for request...")
        
        let data = "Data".data(using: .utf8)!
        let client = ClientStub(result: .success((data, HTTPURLResponse(url: URL(string: "https://www.recipe.com")!, statusCode: 200, httpVersion: .none, headerFields: .none)!)))
        let sut = RecipeImageService(httpClient: client)
        
        sut.request(image: "https://www.image.com") { result in
            switch result {
            case let .success(image):
                XCTAssertEqual(image, data)
            case let .failure(error):
                XCTFail("Error was not expected: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_GivenNoImageUrl_ThenGotAnError() {
        let exp = expectation(description: "Waiting for request...")
        
        let client = ClientStub(result: .failure(NetworkError.noData))
        let sut = RecipeImageService(httpClient: client)
        
        sut.request(image: "https://www.image.com") { result in
            switch result {
            case .success:
                XCTFail("Test failed")
            case let .failure(error):
                XCTAssertEqual(error as! NetworkError, NetworkError.noData)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

