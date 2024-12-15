# Grok API Swift SDK

Using this SDK, you can interact with Elon Musk's new AI! This SDK provides methods to interact with various endpoints of the Grok API, including fetching API key information, listing models, and creating chat completions.

## Installation

To install the Grok API Swift SDK, add the following dependency to your `Package.swift` file:

```swift
// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "YourProjectName",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/yourusername/Grok-API-SDK.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["Grok_API_SDK"]),
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