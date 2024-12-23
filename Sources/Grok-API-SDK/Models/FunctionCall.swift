//
//  File.swift
//  Grok-API-SDK
//
//  Created by Vaibhav Satishkumar on 12/15/24.
//

import Foundation

public struct FunctionParameter: Codable, Sendable {
    public let type: String
    public let description: String
    public let exampleValue: String?

    // Explicit public initializer
    public init(type: String, description: String, exampleValue: String? = nil) {
        self.type = type
        self.description = description
        self.exampleValue = exampleValue
    }
}

public struct FunctionParameters: Codable, Sendable {
    public let type: String
    public let properties: [String: FunctionParameter]
    public let required: [String]
    public let optional: [String]?

    // Explicit public initializer
    public init(type: String, properties: [String: FunctionParameter], required: [String], optional: [String]? = nil) {
        self.type = type
        self.properties = properties
        self.required = required
        self.optional = optional
    }

    // Example initializer for calculator with "a" and "b"
    public static func calculatorParameters() -> FunctionParameters {
        return FunctionParameters(
            type: "object",
            properties: [
                "a": FunctionParameter(type: "number", description: "The first operand", exampleValue: "5027"),
                "b": FunctionParameter(type: "number", description: "The second operand", exampleValue: "3032")
            ],
            required: ["a", "b"],
            optional: nil
        )
    }
}

public struct FunctionDefinition: Codable, Sendable {
    public let name: String
    public let parameters: FunctionParameters? // Re-added as optional to include in requests
    public let arguments: String? // Added to match the JSON response

    // Explicit public initializer
    public init(name: String, parameters: FunctionParameters? = nil, arguments: String? = nil) {
        self.name = name
        self.parameters = parameters
        self.arguments = arguments
    }
}

public struct Function: Codable, Sendable {
    public let type: String
    public let name: String
    public let parameters: FunctionParameters? // Re-added as optional
    public let arguments: String? // Added to match the JSON response

    // Remove the following property
    // let description: String
}

public struct ToolCall: Codable, Sendable {
    public let id: String
    public let function: FunctionCallDetails
    public let index: Int
    public let type: String
}

public struct FunctionCallDetails: Codable, Sendable {
    public let name: String
    public let arguments: [String: String]

    // Custom decoding to handle JSON string for arguments
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let argumentsString = try container.decode(String.self, forKey: .arguments)
        if let data = argumentsString.data(using: .utf8),
           let argumentsDict = try? JSONDecoder().decode([String: String].self, from: data) {
            arguments = argumentsDict
        } else {
            arguments = [:]
        }
    }

    // Custom encoding to handle JSON string for arguments
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        let argumentsData = try JSONEncoder().encode(arguments)
        let argumentsString = String(data: argumentsData, encoding: .utf8) ?? "{}"
        try container.encode(argumentsString, forKey: .arguments)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case arguments
    }
}

public struct ToolCallResponse: Codable, Sendable {
    public let choices: [ToolCallChoice]
}

public struct ToolCallChoice: Codable, Sendable {
    public let message: ToolCallMessage
}

public struct ToolCallMessage: Codable, Sendable {
    public let toolCalls: [ToolCall]?

    enum CodingKeys: String, CodingKey {
        case toolCalls = "tool_calls"
    }
}
