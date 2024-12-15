import XCTest
@testable import Grok_API_SDK

final class Grok_API_SDKTests: XCTestCase {
    
    func testFetchData() async throws {
        let apiKey = "invalid_api_key"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "FetchData")
        
        api.fetchData(endpoint: "api-key", responseType: APIKeyInfo.self) { result in
            switch result {
            case .success(let apiKeyInfo):
                print("FetchData Response: \(apiKeyInfo)")
                XCTAssertNotNil(apiKeyInfo, "APIKeyInfo should not be nil")
            case .failure(let error):
                if let grokError = error as? GrokAPIError {
                    print("FetchData Error: \(grokError.localizedDescription)")
                } else {
                    print("FetchData Error: \(error.localizedDescription)")
                }
                XCTAssertNotNil(error, "Error should not be nil")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testGetAPIKeyInfo() async throws {
        let apiKey = "xai-friohoxvxHfPhoacf9bkvBnsPWOwqgJFerEQrKGtVjaDiuoTEZeLI0GXsOdC9Ju6M6uHzIS3C9Dk8nD4"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "GetAPIKeyInfo")
        
        api.getAPIKeyInfo { result in
            switch result {
            case .success(let apiKeyInfo):
                print("GetAPIKeyInfo Response: \(apiKeyInfo)")
                XCTAssertNotNil(apiKeyInfo, "APIKeyInfo should not be nil")
            case .failure(let error):
                if let grokError = error as? GrokAPIError {
                    print("GetAPIKeyInfo Error: \(grokError.localizedDescription)")
                } else {
                    print("GetAPIKeyInfo Error: \(error.localizedDescription)")
                }
                XCTAssertNotNil(error, "Error should not be nil")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testListModels() async throws {
        let apiKey = "xai-friohoxvxHfPhoacf9bkvBnsPWOwqgJFerEQrKGtVjaDiuoTEZeLI0GXsOdC9Ju6M6uHzIS3C9Dk8nD4"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "ListModels")
        
        api.listModels { result in
            switch result {
            case .success(let modelList):
                print("ListModels Response: \(modelList)")
                XCTAssertNotNil(modelList, "ModelList should not be nil")
            case .failure(let error):
                if let grokError = error as? GrokAPIError {
                    print("ListModels Error: \(grokError.localizedDescription)")
                } else {
                    print("ListModels Error: \(error.localizedDescription)")
                }
                XCTAssertNotNil(error, "Error should not be nil")
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
}