# Grok API Swift SDK

![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-blue)
![License](https://img.shields.io/badge/License-MIT-green)

Using this SDK, you can interact with Elon Musk's new AI! This SDK provides methods to interact with various endpoints of the Grok API, including fetching API key information, listing models, and creating chat completions.

## Installation

To install the Grok API Swift SDK, add the following dependency to your `Package.swift` file:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Grok-API-SDK",
    platforms: [
        .iOS(.v12),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Grok-API-SDK",
            targets: ["Grok-API-SDK"]),
    ],
    targets: [
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
    ChatMessage(role: "user", content: "Hello, how are you?")
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
    ChatMessage(role: "system", content: "You are a helpful assistant that can perform calculations."),
    ChatMessage(role: "user", content: "What is 5027 * 3032? Use the calculator tool.")
]

let calculatorFunction = Function(
    type: "function",
    name: "calculator",
    parameters: FunctionParameters(
        type: "object",
        properties: [
            "a": FunctionParameter(type: "number", description: "The first operand", exampleValue: "5027"),
            "b": FunctionParameter(type: "number", description: "The second operand", exampleValue: "3032")
        ],
        required: ["a", "b"]
    )
)

let request = ChatCompletionRequest(
    model: "grok-beta",
    messages: messages,
    maxTokens: 150,
    temperature: 0.7,
    toolChoice: "auto",
    tools: [calculatorFunction.name]
)

Task {
    do {
        let response = try await api.createChatCompletionWithFunctionCallAsync(request: request, tools: [calculatorFunction])
        print("Chat Completion Response: \(response)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

### Streaming Chat Completions

To provide a seamless and interactive user experience, the Grok API Swift SDK supports streaming responses. This allows you to receive partial results in real-time as the model generates content.

```swift
let request = ChatCompletionRequest(
    model: "grok-beta",
    messages: messages,
    maxTokens: 150,
    temperature: 0.7,
    stream: true,
    toolChoice: "auto",
    tools: [calculatorFunction.name]
)

Task {
    do {
        var finalResponseContent: String = ""
        
        for try await chunk in api.createChatCompletionStream(request: request) {
            print(chunk, terminator: "") // Print partial content
            finalResponseContent += chunk
        }
        
        print("\nFinal response content: \(finalResponseContent)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

### Structured Output

The Grok API Swift SDK supports structured outputs, allowing you to define the expected format of the response using JSON Schema. This ensures that the response adheres to a specific structure, making it easier to parse and use in your application.

```swift
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
    maxTokens: 150,
    temperature: 0.7,
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
    )
)

api.createChatCompletion(request: request) { result in
    switch result {
    case .success(let response):
        print("Structured Output Response: \(response)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

## Error Handling

The SDK provides detailed error messages to help you understand any issues that arise. Errors are returned as instances of the `GrokAPIError` enum, which conforms to the `LocalizedError` protocol:

```swift
public enum GrokAPIError: Error, LocalizedError {
    case invalidResponse
    case httpError(Int, Data?)
    case noData
    case decodingError(Error)
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from the server."
        case .httpError(let statusCode, let data):
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                return "HTTP Error: \(statusCode). Response: \(responseString)"
            } else {
                return "HTTP Error: \(statusCode). Please check your API key and endpoint."
            }
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

<details>
<summary>Invalid API Key</summary>

**Symptoms**: Receiving `HTTP Error: 401` or similar authentication errors.  
**Solution**: Ensure that your API key is correct and has the necessary permissions. You can verify your API key using the `getAPIKeyInfo` method.
</details>

<details>
<summary>Decoding Errors</summary>

**Symptoms**: Errors related to JSON decoding, such as missing keys or type mismatches.  
**Solution**: 
- Verify that the API response structure matches the models defined in the SDK.
- Ensure that all required parameters are provided in function calls.
- Check for updates in the API that might introduce new fields or change existing ones.
</details>

<details>
<summary>Network Connectivity Issues</summary>

**Symptoms**: Timeouts or inability to reach the API server.  
**Solution**: 
- Check your internet connection.
- Ensure that there are no firewalls or proxies blocking the requests.
- Retry the request after some time in case of temporary server issues.
</details>

<details>
<summary>Missing Function Definitions</summary>

**Symptoms**: The assistant attempts to call a function that is not defined or provided in the `tools` list.  
**Solution**: 
- Ensure that all required functions are defined and included in the `tools` array when making the `ChatCompletionRequest`.
- Verify the function parameters and their types are correctly specified.
</details>

### Getting Help

If you encounter issues not covered in this section, please open an issue on the [GitHub repository](https://github.com/Visual-Studio-Coder/Grok-API-SDK) or contact the maintainer directly.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License.