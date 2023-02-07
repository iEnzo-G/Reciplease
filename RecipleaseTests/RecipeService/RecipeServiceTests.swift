import XCTest
@testable import Reciplease

final class RecipeServiceTests: XCTestCase {
    
    func test_GivenData_WhenSendRequest() {
        let exp = expectation(description: "Waiting for request...")
        let data = RecipeData().data
        let client = ClientStub(result: .success((data, HTTPURLResponse(url: URL(string: "https://www.recipe.com")!, statusCode: 200, httpVersion: .none, headerFields: .none)!)))
        let sut = RecipeService(httpClient: client)
        sut.request(ingredientList: ["Tomato"]) { result in
            switch result {
            case let .success(recipe):
                XCTAssertEqual(recipe.hits[0].recipe.label, "Tomato Gravy")
                XCTAssertEqual(recipe.hits[0].recipe.image, "image")
                XCTAssertEqual(recipe.hits[0].recipe.url, "url")
            case let .failure(error):
                XCTFail("Error was not expected: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_AskMoreRequest() {
        let exp = expectation(description: "Waiting for request...")
        let data = RecipeData().data
        let client = ClientStub(result: .success((data, HTTPURLResponse(url: URL(string: "https://www.recipe.com")!, statusCode: 200, httpVersion: .none, headerFields: .none)!)))
        let sut = RecipeService(httpClient: client)
        let url = "https://www,nextrecipes.com"
        sut.requestMore(url: url) { result in
            switch result {
            case let .success(recipe):
                XCTAssertEqual(recipe.hits[0].recipe.totalTime, 5)
            case let .failure(error):
                XCTFail("Error was not expected: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_GivenRequest_ThenThrowError() {
        let error = NetworkError.noData
        let client = ClientStub(result: .failure(error))
        let sut = RecipeService(httpClient: client)
        let exp = expectation(description: "Wainting for request...")
        sut.request(ingredientList: ["Tomato"]) { result in
            switch result {
            case .success:
                XCTFail("Test is not valid")
            case let .failure(error):
                XCTAssertEqual(error as! NetworkError, NetworkError.noData)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_GivenUndecodableData_WhenTryJSONDecoder_ThenGetNetworkError() {
        let data = Data()
        let client = ClientStub(result: .success((data, HTTPURLResponse(url: URL(string: "https://www.a-url.com")!, statusCode: 200, httpVersion: .none, headerFields: .none)!)))
        let sut = RecipeService(httpClient: client)
        let exp = expectation(description: "Waiting for request...")
        
        sut.request(ingredientList: ["Tomato"]) { result in
            switch result {
            case .success:
                XCTFail("Test is not valid.")
            case let .failure(error):
                XCTAssertEqual(error as! NetworkError, NetworkError.undecodableData)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    
    
}

// MARK: - Helpers

class RecipeData {
    var data: Data {
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "Recipe", withExtension: "json")
        let RecipeData = try! Data(contentsOf: url!)
        return RecipeData
    }
}
