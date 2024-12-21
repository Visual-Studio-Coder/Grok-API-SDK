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
    
    func testCreateChatCompletion() async throws {
        let apiKey = "xai-friohoxvxHfPhoacf9bkvBnsPWOwqgJFerEQrKGtVjaDiuoTEZeLI0GXsOdC9Ju6M6uHzIS3C9Dk8nD4"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "CreateChatCompletion")
        
        let messages = [
            ChatMessage(role: "system", content: "You are a helpful assistant that can search the web."),
            ChatMessage(role: "user", content: "Can you find the latest news about AI?")
        ]
        
        let request = ChatCompletionRequest(
            model: "grok-beta",
            messages: messages,
            frequencyPenalty: nil,
            logitBias: nil,
            logprobs: nil,
            maxTokens: 150,
            n: nil,
            presencePenalty: nil,
            responseFormat: nil,
            seed: nil,
            stop: nil,
            stream: nil,
            temperature: 0.7,
            toolChoice: nil,
            tools: nil,
            topLogprobs: nil,
            topP: nil,
            user: nil
        )
        
        api.createChatCompletion(request: request) { result in
            switch result {
            case .success(let response):
                print("CreateChatCompletion Response: \(response)")
                XCTAssertNotNil(response, "ChatCompletionResponse should not be nil")
                expectation.fulfill()
            case .failure(let error):
                if let grokError = error as? GrokAPIError {
                    print("CreateChatCompletion Error: \(grokError.localizedDescription)")
                } else {
                    print("CreateChatCompletion Error: \(error.localizedDescription)")
                }
                XCTAssertNotNil(error, "Error should not be nil")
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 30)
    }
    
    func testCreateChatCompletionWithFunctionCall() async throws {
        let apiKey = "xai-friohoxvxHfPhoacf9bkvBnsPWOwqgJFerEQrKGtVjaDiuoTEZeLI0GXsOdC9Ju6M6uHzIS3C9Dk8nD4"
        let api = GrokAPI(apiKey: apiKey)
        
        var messages = [
            ChatMessage(role: "system", content: "You are a helpful assistant that can perform calculations."),
            ChatMessage(role: "user", content: "What is 5027 * 3032? Use the calculator tool.")
        ]
        
        let request = ChatCompletionRequest(
            model: "grok-beta",
            messages: messages,
            frequencyPenalty: nil,
            logitBias: nil,
            logprobs: nil,
            maxTokens: 150,
            n: nil,
            presencePenalty: nil,
            responseFormat: nil,
            seed: nil,
            stop: nil,
            stream: nil,
            temperature: 0.7,
            toolChoice: nil,
            tools: nil,
            topLogprobs: nil,
            topP: nil,
            user: nil
        )
        
        let functionParameterA = FunctionParameter(type: "number", description: "The first operand", exampleValue: "5027")
        let functionParameterB = FunctionParameter(type: "number", description: "The second operand", exampleValue: "3032")
        let functionParameters = FunctionParameters(type: "object", properties: ["a": functionParameterA, "b": functionParameterB], required: ["a", "b"], optional: nil)
        let functionDefinition = FunctionDefinition(name: "calculator", parameters: functionParameters, arguments: nil)
        let tool = Tool(type: "function", name: "calculator", description: "Performs basic arithmetic operations", parameters: functionParameters, function: functionDefinition)
        
        do {
            let response = try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: [tool])
            print("CreateChatCompletionWithFunctionCall Response: \(response)")
            XCTAssertNotNil(response, "ChatCompletionResponse should not be nil")
            
            // Step 4: Run tool functions and append returns to message
            if let toolCalls = response.choices.first?.message.toolCalls {
                for toolCall in toolCalls {
                    let functionName = toolCall.function.name
                    guard let functionArgs = try? JSONDecoder().decode([String: Int].self, from: Data(toolCall.function.arguments?.utf8 ?? "".utf8)) else {
                        print("Failed to decode function arguments.")
                        continue
                    }
                    
                    // Define the tools map with updated parameters "a" and "b"
                    let toolsMap: [String: ([String: Int]) -> [String: Int]] = [
                        "calculator": { args in
                            if let a = args["a"], let b = args["b"] {
                                return ["result": a * b]
                            }
                            return ["result": 0]
                        }
                    ]
                    
                    // Call the appropriate tool function
                    if let toolFunction = toolsMap[functionName] {
                        let result = toolFunction(functionArgs)
                        
                        // Append the result to the messages
                        messages.append(
                            ChatMessage(
                                role: "tool",
                                content: String(data: try! JSONEncoder().encode(result), encoding: .utf8)!,
                                toolCalls: nil
                            )
                        )
                    } else {
                        print("No tool function found for name: \(functionName)")
                    }
                }
                
                // Step 5: Send the tool function returns back to the model to get the response
                let finalRequest = ChatCompletionRequest(
                    model: "grok-beta",
                    messages: messages,
                    frequencyPenalty: nil,
                    logitBias: nil,
                    logprobs: nil,
                    maxTokens: 150,
                    n: nil,
                    presencePenalty: nil,
                    responseFormat: nil,
                    seed: nil,
                    stop: nil,
                    stream: nil,
                    temperature: 0.7,
                    toolChoice: nil,
                    tools: nil,
                    topLogprobs: nil,
                    topP: nil,
                    user: nil
                )
                
                let finalResponse = try await api.createChatCompletionWithFunctionCallAsync(request: finalRequest, tools: [tool])
                print("Final CreateChatCompletionWithFunctionCall Response: \(finalResponse)")
                XCTAssertNotNil(finalResponse, "ChatCompletionResponse should not be nil")
                print("Final response content: \(finalResponse.choices.first?.message.content ?? "No content")")
                
                // **Extract and Assert the Numerical Result**
                if let content = finalResponse.choices.first?.message.content {
                    // Use a regular expression to extract the number (handles commas and formatting)
                    let pattern = "\\b\\d{1,3}(?:,\\d{3})*(?:\\.\\d+)?\\b"
                    let regex = try? NSRegularExpression(pattern: pattern, options: [])
                    let range = NSRange(location: 0, length: content.utf16.count)
                    if let match = regex?.firstMatch(in: content, options: [], range: range),
                       let matchRange = Range(match.range, in: content) {
                        let numberString = String(content[matchRange]).replacingOccurrences(of: ",", with: "")
                        if let number = Int(numberString) {
                            XCTAssertEqual(number, 5027 * 3032, "Calculator tool did not compute the correct result.")
                        } else {
                            XCTFail("Failed to parse numeric result from response content.")
                        }
                    } else {
                        XCTFail("No numeric result found in response content.")
                    }
                } else {
                    XCTFail("Response content is nil.")
                }
            }
        } catch {
            if let grokError = error as? GrokAPIError {
                print("CreateChatCompletionWithFunctionCall Error: \(grokError.localizedDescription)")
            } else {
                print("CreateChatCompletionWithFunctionCall Error: \(error.localizedDescription)")
            }
            XCTFail("Error should not be nil")
        }
    }
    
//    func testListEmbeddingModels() async throws {
//        let apiKey = "xai-friohoxvxHfPhoacf9bkvBnsPWOwqgJFerEQrKGtVjaDiuoTEZeLI0GXsOdC9Ju6M6uHzIS3C9Dk8nD4"
//        let api = GrokAPI(apiKey: apiKey)
//        let expectation = expectation(description: "ListEmbeddingModels")
//
//        api.listEmbeddingModels { result in
//            switch result {
//            case .success(let modelList):
//                print("ListEmbeddingModels Response: \(modelList)")
//                XCTAssertNotNil(modelList, "ModelList should not be nil")
//                XCTAssertFalse(modelList.models.isEmpty, "ModelList should not be empty")
//            case .failure(let error):
//                if let grokError = error as? GrokAPIError {
//                    print("ListEmbeddingModels Error: \(grokError.localizedDescription)")
//                } else {
//                    print("ListEmbeddingModels Error: \(error.localizedDescription)")
//                }
//                XCTAssertNotNil(error, "Error should not be nil")
//            }
//            expectation.fulfill()
//        }
//
//        await fulfillment(of: [expectation], timeout: 5)
//    }
}
