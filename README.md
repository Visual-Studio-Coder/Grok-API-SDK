# Grok API Swift SDK

Using this SDK, you can interact with Elon Musk's new AI! This SDK provides methods to interact with various endpoints of the Grok API, including fetching API key information, listing models, and creating chat completions.

## Installation

To install the Grok API Swift SDK, add the following dependency to your `Package.swift` file:

```swift
// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Grok-API-SDK",
    platforms: [
        .iOS(.v12),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Grok-API-SDK",
            targets: ["Grok-API-SDK"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Grok-API-SDK"),
        .testTarget(
            name: "Grok-API-SDKTests",
            dependencies: ["Grok-API-SDK"]
        ),
    ]
)

```

## Usage

### Initialization

First, initialize the `GrokAPI` class with your API key:

```swift
import Grok_API_SDK

let apiKey = "your_api_key_here"
let api = GrokAPI(apiKey: apiKey)
```

### Fetch API Key Information

You can fetch information about your API key using the `getAPIKeyInfo` method:

```swift
api.getAPIKeyInfo { result in
    switch result {
    case .success(let apiKeyInfo):
        print("API Key Info: \(apiKeyInfo)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

### List Models

You can list available models using the `listModels` method:

```swift
api.listModels { result in
    switch result {
    case .success(let modelList):
        print("Models: \(modelList)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

### Create Chat Completion

You can create a chat completion using the `createChatCompletion` method. This method requires a `ChatCompletionRequest` object, which includes the model name and a list of messages:

```swift
let messages = [
    ChatMessage(role: "user", content: "Hello, how are you?"),
    ChatMessage(role: "assistant", content: "I'm good, thank you! How can I help you today?")
]

let request = ChatCompletionRequest(
    model: "grok-beta",
    messages: messages,
    maxTokens: 150,
    temperature: 0.7
)

api.createChatCompletion(request: request) { result in
    switch result {
    case .success(let response):
        print("Chat Completion Response: \(response)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

### Create Chat Completion with Function Calling

You can create a chat completion with function calling using the `createChatCompletionWithFunctionCallAsync` method. This method allows the assistant to call predefined functions to perform specific tasks:

```swift
let messages = [
    ChatMessage(role: "system", content: "You are a helpful assistant that can search the web."),
    ChatMessage(role: "user", content: "Can you find the latest news about AI?")
]

let functions: [Function] = [
    Function(
        type: "function",
        function: FunctionDefinition(
            name: "get_current_weather",
            description: "Get the current weather in a given location",
            parameters: FunctionParameters(
                type: "object",
                properties: [
                    "location": FunctionParameter(
                        type: "string",
                        description: "The city and state, e.g. San Francisco, CA",
                        exampleValue: "San Francisco, CA"
                    ),
                    "unit": FunctionParameter(
                        type: "string",
                        description: "The unit of temperature, e.g. celsius or fahrenheit",
                        exampleValue: "celsius"
                    )
                ],
                required: ["location"],
                optional: ["unit"]
            )
        )
    )
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
    toolChoice: "auto",
    tools: functions.map { $0.function.name },
    topLogprobs: nil,
    topP: nil,
    user: nil
)

Task {
    do {
        try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: functions) { result in
            switch result {
            case .success(let response):
                print("Chat Completion Response: \(response)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

#### Understanding `ToolCall`

`ToolCall` represents a function call made by the assistant during the chat completion process. It encapsulates the details of the function to be executed, including its name and arguments. This enables the assistant to perform actions like calculations, fetching weather data, or any other predefined operations seamlessly within the conversation.

#### Example Usage

```swift
let messages = [
    ChatMessage(role: "system", content: "You are a helpful assistant that can perform calculations."),
    ChatMessage(role: "user", content: "What is 5027 * 3032? Use the calculator tool.")
]

let functions: [Function] = [
    Function(
        type: "function",
        function: FunctionDefinition(
            name: "calculator",
            parameters: FunctionParameters(
                type: "object",
                properties: [
                    "a": FunctionParameter(
                        type: "number",
                        description: "The first operand",
                        exampleValue: "5027"
                    ),
                    "b": FunctionParameter(
                        type: "number",
                        description: "The second operand",
                        exampleValue: "3032"
                    )
                ],
                required: ["a", "b"],
                optional: nil
            )
        )
    )
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
    toolChoice: "auto",
    tools: functions.map { $0.function.name },
    topLogprobs: nil,
    topP: nil,
    user: nil
)

Task {
    do {
        let response = try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: functions)
        print("Chat Completion Response: \(response)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

#### Full Example: Calculator Tool Use Case

Below is a comprehensive example demonstrating how to use the `calculator` tool with function calling in the Grok API Swift SDK.

```swift
import Grok_API_SDK

// Initialize the GrokAPI with your API key
let apiKey = "your_api_key_here"
let api = GrokAPI(apiKey: apiKey)

// Define the messages for the conversation
let messages = [
    ChatMessage(role: "system", content: "You are a helpful assistant that can perform calculations."),
    ChatMessage(role: "user", content: "What is 5027 * 3032? Use the calculator tool.")
]

// Define the calculator function
let calculatorFunction = Function(
    type: "function",
    name: "calculator",
    description: "Performs basic arithmetic operations",
    parameters: FunctionParameters(
        type: "object",
        properties: [
            "a": FunctionParameter(
                type: "number",
                description: "The first operand",
                exampleValue: "5027"
            ),
            "b": FunctionParameter(
                type: "number",
                description: "The second operand",
                exampleValue: "3032"
            )
        ],
        required: ["a", "b"],
        optional: nil
    )
)

// Create the chat completion request with the calculator tool
let request = ChatCompletionRequest(
    model: "grok-beta",
    messages: messages,
    maxTokens: 150,
    temperature: 0.7,
    toolChoice: "auto",
    tools: [calculatorFunction.name]
)

// Execute the chat completion with function calling
Task {
    do {
        let response = try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: [calculatorFunction])
        print("Chat Completion Response: \(response)")
        
        // Handle the tool call
        if let toolCalls = response.choices.first?.message.toolCalls {
            for toolCall in toolCalls {
                let functionName = toolCall.function.name
                guard let functionArgs = try? JSONDecoder().decode([String: Int].self, from: Data(toolCall.function.arguments?.utf8 ?? "".utf8)) else {
                    print("Failed to decode function arguments.")
                    continue
                }
                
                // Define the tools map
                let toolsMap: [String: ([String: Int]) -> [String: Int]] = [
                    "calculator": { args in
                        if let a = args["a"], let b = args["b"] {
                            return ["result": a * b]
                        }
                        return ["result": 0]
                    }
                ]
                
                // Execute the appropriate tool function
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
            
            // Send the updated messages back to the assistant
            let finalRequest = ChatCompletionRequest(
                model: "grok-beta",
                messages: messages,
                maxTokens: 150,
                temperature: 0.7
            )
            
            let finalResponse = try await api.createChatCompletionWithFunctionCallAsync(request: finalRequest, tools: [calculatorFunction])
            print("Final Chat Completion Response: \(finalResponse)")
            print("Final response content: \(finalResponse.choices.first?.message.content ?? "No content")")
            
            // Extract and assert the numerical result
            if let content = finalResponse.choices.first?.message.content {
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
        print("Error: \(error.localizedDescription)")
    }
}
```

**Explanation of the Example:**

1. **Initialize GrokAPI**: Start by initializing the `GrokAPI` class with your API key.

2. **Define Messages**: Create a conversation where the user asks the assistant to perform a multiplication using the calculator tool.

3. **Define the Calculator Function**: Specify the `calculator` function with its parameters `a` and `b`.

4. **Create the Request**: Construct a `ChatCompletionRequest` that includes the model, messages, and the `calculator` tool.

5. **Execute the Request**: Call `createChatCompletionWithFunctionCallAsync` with the request and tools.

6. **Handle the Tool Call**:
    - **Decode Arguments**: Extract and decode the arguments passed to the `calculator` function.
    - **Execute Calculation**: Perform the multiplication and obtain the result.
    - **Append Result**: Add the calculation result back to the conversation messages and send another `ChatCompletionRequest` to get the assistant's final response.

7. **Finalize the Response**: The assistant provides the computed result to the user, completing the conversation.

8. **Validate the Result**: Use a regular expression to extract the numerical result from the assistant's response and assert its correctness.

#### How It Works

1. **Define Functions**: Specify the functions that the assistant can call. In this example, a `calculator` function is defined with two parameters, `a` and `b`.

2. **Create Request**: Construct a `ChatCompletionRequest` with the desired messages and include the `calculator` function in the `tools` array.

3. **Handle Response**: The assistant responds by calling the `calculator` function with the provided arguments.

4. **Execute Function**: Your application executes the `calculator` function using the provided arguments (`a` and `b`), performing the multiplication.

5. **Append Result**: Add the calculation result to the conversation messages and send another `ChatCompletionRequest` to get the assistant's final response.

6. **Final Response**: The assistant provides the computed result to the user, completing the conversation.

## Streaming Chat Completions

To provide a seamless and interactive user experience, the Grok API Swift SDK supports streaming responses. This allows you to receive partial results in real-time as the model generates content, similar to how the Gemini API handles streaming.

### Benefits of Streaming

- **Real-Time Feedback**: Receive responses incrementally as they are generated.
- **Enhanced User Experience**: Enable interactive applications where users can see responses build in real-time.
- **Efficient Resource Usage**: Stream data reduces the need to wait for the entire response before processing.

### Implementing Streaming

The following example demonstrates how to implement streaming using the `createChatCompletionStream` method to generate text from a text-only input prompt.

```swift
import Grok_API_SDK

// Initialize GrokAPI with your API key
let apiKey = "your_api_key_here"
let api = GrokAPI(apiKey: apiKey)

// Define the messages for the conversation
let messages = [
    ChatMessage(role: "system", content: "You are a helpful assistant that can perform calculations."),
    ChatMessage(role: "user", content: "What is 5027 * 3032? Use the calculator tool.")
]

// Define the calculator function
let calculatorFunction = Function(
    type: "function",
    name: "calculator",
    description: "Performs basic arithmetic operations",
    parameters: FunctionParameters(
        type: "object",
        properties: [
            "a": FunctionParameter(
                type: "number",
                description: "The first operand",
                exampleValue: "5027"
            ),
            "b": FunctionParameter(
                type: "number",
                description: "The second operand",
                exampleValue: "3032"
            )
        ],
        required: ["a", "b"],
        optional: nil
    )
)

// Create the chat completion request with streaming enabled
let request = ChatCompletionRequest(
    model: "grok-beta",
    messages: messages,
    maxTokens: 150,
    temperature: 0.7,
    stream: true,
    toolChoice: "auto",
    tools: [calculatorFunction.name]
)

// Execute the chat completion with streaming
Task {
    do {
        var finalResponseContent: String = ""
        
        for try await chunk in api.createChatCompletionStream(request: request) {
            print(chunk, terminator: "") // Print partial content
            finalResponseContent += chunk
        }
        
        print("\nFinal response content: \(finalResponseContent)")
        
        // Validate the result
        XCTAssertEqual(finalResponseContent.trimmingCharacters(in: .whitespacesAndNewlines), "15189824", "Calculator tool did not compute the correct result.")
        
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

### Explanation of the Example:

1. **Initialize GrokAPI**: Start by initializing the `GrokAPI` class with your API key.

2. **Define Messages**: Create a conversation where the user requests a multiplication operation using the calculator tool.

3. **Define the Calculator Function**: Specify the `calculator` function with its parameters `a` and `b`.

4. **Create the Request**: Construct a `ChatCompletionRequest` with streaming enabled by setting `stream: true`.

5. **Execute the Request**: Call `createChatCompletionStream` to receive a stream of partial `content` strings.

6. **Handle the Streaming Response**:
    - Iterate over each `String` chunk received from the stream.
    - Print each partial `content` as it arrives, providing real-time feedback.
    - Accumulate the content to form the final response.

7. **Validate the Result**: After the stream completes, assert that the final accumulated response matches the expected multiplication result.

### Additional Notes

- **Handling Partial Responses**: The streaming method yields each partial `content` string as the model generates it. This allows you to display or process the response incrementally.

- **Error Handling**: Ensure that your application gracefully handles any errors that may occur during streaming, such as network interruptions or unexpected data formats.

- **Customization**: You can customize the streaming behavior by adjusting parameters like `maxTokens`, `temperature`, and the functions included in the `tools` array.

By following this approach, users of your SDK can effectively utilize the streaming capabilities, providing a responsive and interactive experience similar to the Gemini API.

## Error Handling

The SDK provides detailed error messages to help you understand any issues that arise. Errors are returned as instances of the `GrokAPIError` enum, which conforms to the `LocalizedError` protocol:

```swift
public enum GrokAPIError: Error, LocalizedError {
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from the server."
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode). Please check your API key and endpoint."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription). Please check the response format."
        case .custom(let message):
            return message
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Invalid API Key**
   - **Symptoms**: Receiving `HTTP Error: 401` or similar authentication errors.
   - **Solution**: Ensure that your API key is correct and has the necessary permissions. You can verify your API key using the `getAPIKeyInfo` method.

2. **Decoding Errors**
   - **Symptoms**: Errors related to JSON decoding, such as missing keys or type mismatches.
   - **Solution**: 
     - Verify that the API response structure matches the models defined in the SDK.
     - Ensure that all required parameters are provided in function calls.
     - Check for updates in the API that might introduce new fields or change existing ones.

3. **Network Connectivity Issues**
   - **Symptoms**: Timeouts or inability to reach the API server.
   - **Solution**: 
     - Check your internet connection.
     - Ensure that there are no firewalls or proxies blocking the requests.
     - Retry the request after some time in case of temporary server issues.

4. **Missing Function Definitions**
   - **Symptoms**: The assistant attempts to call a function that is not defined or provided in the `tools` list.
   - **Solution**: 
     - Ensure that all required functions are defined and included in the `tools` array when making the `ChatCompletionRequest`.
     - Verify the function parameters and their types are correctly specified.

### Getting Help

If you encounter issues not covered in this section, please open an issue on the [GitHub repository](https://github.com/your-repo/Grok-API-SDK) or contact the maintainer directly.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License.
