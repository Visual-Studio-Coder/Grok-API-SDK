import XCTest
@testable import Grok_API_SDK

final class Grok_API_SDKTests: XCTestCase {
    
    func testFetchData() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "FetchData")
        
        api.fetchData(endpoint: "api-key", responseType: APIKeyInfo.self) { result in
            switch result {
            case .success(let info):
                XCTAssertNotNil(info)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testGetAPIKeyInfo() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "GetAPIKeyInfo")
        
        api.getAPIKeyInfo { result in
            switch result {
            case .success(let info):
                XCTAssertNotNil(info)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testListModels() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "ListModels")
        
        api.listModels { result in
            switch result {
            case .success(let modelList):
                XCTAssertNotNil(modelList)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testCreateChatCompletion() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "CreateChatCompletion")
        
        let messages = [
            ChatMessage(role: "user", content: "Hello, how are you?")
        ]
        
        let functionParameterA = FunctionParameter(type: "number", description: "The first operand", exampleValue: "5027")
        let functionParameterB = FunctionParameter(type: "number", description: "The second operand", exampleValue: "3032")
        let functionParameters = FunctionParameters(type: "object", properties: ["a": functionParameterA, "b": functionParameterB], required: ["a", "b"], optional: nil)
        let functionDefinition = FunctionDefinition(name: "calculator", parameters: functionParameters, arguments: nil)
        let tool = Tool(type: "function", name: "calculator", description: "Performs basic arithmetic operations", parameters: functionParameters, function: functionDefinition)
        
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
            toolChoice: "auto",
            tools: [tool],
            topLogprobs: nil,
            topP: nil,
            user: nil
        )
        
        let response = try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: [tool])
        
        api.createChatCompletion(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 30)
    }
    
    func testCreateChatCompletionWithFunctionCall() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        
        let messages = [
            ChatMessage(role: "user", content: "Calculate 5027 * 3032 using the calculator tool.")
        ]
        
        let functionParameterA = FunctionParameter(type: "number", description: "The first operand", exampleValue: "5027")
        let functionParameterB = FunctionParameter(type: "number", description: "The second operand", exampleValue: "3032")
        let functionParameters = FunctionParameters(type: "object", properties: ["a": functionParameterA, "b": functionParameterB], required: ["a", "b"], optional: nil)
        let functionDefinition = FunctionDefinition(name: "calculator", parameters: functionParameters, arguments: nil)
        let tool = Tool(type: "function", name: "calculator", description: "Performs basic arithmetic operations", parameters: functionParameters, function: functionDefinition)
        
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
            toolChoice: "auto",
            tools: [tool],
            topLogprobs: nil,
            topP: nil,
            user: nil
        )
        
        do {
            let response = try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: [tool])
            print("Function call response: \(response)")
            XCTAssertNotNil(response)
        } catch {
            XCTFail("Function call failed with error: \(error)")
        }
    }
    
    func testCreateChatCompletionStream() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = expectation(description: "CreateChatCompletionStream")
        
        let messages = [
            ChatMessage(role: "user", content: "Calculate 5027 * 3032 using the calculator tool.")
        ]
        
        let functionParameterA = FunctionParameter(type: "number", description: "The first operand", exampleValue: "5027")
        let functionParameterB = FunctionParameter(type: "number", description: "The second operand", exampleValue: "3032")
        let functionParameters = FunctionParameters(type: "object", properties: ["a": functionParameterA, "b": functionParameterB], required: ["a", "b"], optional: nil)
        let functionDefinition = FunctionDefinition(name: "calculator", parameters: functionParameters, arguments: nil)
        let tool = Tool(type: "function", name: "calculator", description: "Performs basic arithmetic operations", parameters: functionParameters, function: functionDefinition)
        
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
            stream: true,
            temperature: 0.7,
            toolChoice: "auto",
            tools: [tool],
            topLogprobs: nil,
            topP: nil,
            user: nil
        )
        
        Task {
            do {
                let responseStream = try await api.createChatCompletionStream(request: request)
                var finalResponseContent: String = ""
                
                for try await chunk in responseStream {
                    // Decode the chunk into ChatCompletionChunk
                    if let data = chunk.data(using: .utf8),
                       let chatChunk = try? JSONDecoder().decode(ChatCompletionChunk.self, from: data) {
                        for choice in chatChunk.choices {
                            if let content = choice.delta?.content {
                                print(content, terminator: "")
                                finalResponseContent += content
                            }
                        }
                    }
                }
                
                print("\nFinal response content: \(finalResponseContent)")
                XCTAssertEqual(finalResponseContent.trimmingCharacters(in: .whitespacesAndNewlines), "15189824", "Calculator tool did not compute the correct result.")
                
                expectation.fulfill()
            } catch {
                XCTFail("Streaming failed with error: \(error)")
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 30)
    }
    
    func testCreateChatCompletionWithStructuredOutput() async throws {
        let apiKey = ProcessInfo.processInfo.environment["GROK_API_KEY"] ?? "your_api_key_here"
        let api = GrokAPI(apiKey: apiKey)
        let expectation = self.expectation(description: "StructuredOutput")

        // Example structured request
        let messages = [
            ChatMessage(role: "system", content: "You are an assistant helping the user rate movies."),
            ChatMessage(role: "user", content: "What is the rating of Star Wars?")
        ]
        
        let schemaProperties: [String: SchemaProperty] = [
            "title": SchemaProperty(type: "string", description: nil),
            "rating": SchemaProperty(type: "number", description: "The rating of the movie, typically out of 10"),
            "summary": SchemaProperty(type: "string", description: nil)
        ]

        let request = ChatCompletionRequest(
            model: "grok-2-1212",
            messages: messages,
            frequencyPenalty: nil,
            logitBias: nil,
            logprobs: nil,
            maxTokens: 150,
            n: nil,
            presencePenalty: nil,
            responseFormat: ResponseFormat(
                type: "json_schema",
                jsonSchema: JSONSchema(
                    name: "movie_response",
                    schema: SchemaDetails(
                        type: "object",
                        properties: schemaProperties,
                        required: ["title", "rating", "summary"],
                        additionalProperties: false
                    ),
                    strict: true
                )
            ),
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
        
        // Call createChatCompletion
        api.createChatCompletion(request: request) { result in
            switch result {
            case .success(let response):
                // Print the entire response object
                print("Received ChatCompletionResponse:\n\(response)")
                fflush(stdout)

                // Print just the content (if any)
                if let content = response.choices.first?.message.content {
                    print("Raw response data from structured output:\n\(content)")
                    fflush(stdout)
                } else {
                    print("No content in response. Possibly empty result.")
                    fflush(stdout)
                }
            case .failure(let error):
                XCTFail("Request failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        await self.fulfillment(of: [expectation], timeout: 30.0)
    }
    
}
