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

You can create a chat completion with function calling using the `createChatCompletionWithFunctionCallAsync` method. This method requires a `ChatCompletionRequest` object, a list of `Function` objects, and a completion handler:

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

#### How It Works

1. **Define Functions**: Specify the functions that the assistant can call. In this example, a `calculator` function is defined with two parameters, `a` and `b`.

2. **Create Request**: Construct a `ChatCompletionRequest` with the desired messages and include the functions that the assistant can utilize.

3. **Handle Response**: The assistant may respond by calling one of the predefined functions (`ToolCall`). You can then execute the function and provide the result back to the assistant to continue the conversation.

4. **Using `ToolCall`**: The `ToolCall` object contains the function name and arguments. After executing the function, append the result to the conversation to receive the final response from the assistant.

#### Example Workflow

1. **User Input**: "What is 5027 * 3032? Use the calculator tool."

2. **Assistant's Response**: The assistant recognizes the need to perform a calculation and issues a `ToolCall` for the `calculator` function with the provided operands.

3. **Execute Function**: Your application executes the `calculator` function using the provided arguments.

4. **Append Result**: Add the calculation result to the messages and send another `ChatCompletionRequest` to get the assistant's final response.

5. **Final Response**: The assistant provides the computed result to the user.

#### Benefits of Using `ToolCall`

- **Flexibility**: Easily extend the assistant's capabilities by defining new functions as needed.
- **Modularity**: Keep business logic separate from the assistant's responses, making the codebase cleaner and more maintainable.
- **Enhanced User Experience**: Provide dynamic and accurate responses by leveraging custom functions tailored to your application's needs.

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

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License.
