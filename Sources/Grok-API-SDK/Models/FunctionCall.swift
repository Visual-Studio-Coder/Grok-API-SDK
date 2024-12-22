//
//  File.swift
//  Grok-API-SDK
//
//  Created by Vaibhav Satishkumar on 12/15/24.
//

import Foundation

public struct FunctionParameter: Codable, Sendable {
    let type: String
    let description: String
    let exampleValue: String?
}

public struct FunctionParameters: Codable, Sendable {
    let type: String
    let properties: [String: FunctionParameter]
    let required: [String]
    let optional: [String]?

    init(type: String, properties: [String: FunctionParameter], required: [String], optional: [String]? = nil) {
        self.type = type
        self.properties = properties
        self.required = required
        self.optional = optional
    }

    // Example initializer for calculator with "a" and "b"
    static func calculatorParameters() -> FunctionParameters {
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
    let name: String
    let parameters: FunctionParameters? // Re-added as optional to include in requests
    let arguments: String? // Added to match the JSON response

    // Remove the following properties as they are not present in the JSON response
    // let description: String
}

public struct Function: Codable, Sendable {
    let type: String
    let name: String
    let parameters: FunctionParameters? // Re-added as optional
    let arguments: String? // Added to match the JSON response

    // Remove the following property
    // let description: String
}

public struct ToolCall: Codable, Sendable {
    let id: String
    let function: FunctionCallDetails
    let index: Int
    let type: String
}

public struct FunctionCallDetails: Codable, Sendable {
    let name: String
    let arguments: String
}

public struct ToolCallResponse: Codable, Sendable {
    let choices: [ToolCallChoice]
}

public struct ToolCallChoice: Codable, Sendable {
    let message: ToolCallMessage
}

public struct ToolCallMessage: Codable, Sendable {
    let toolCalls: [ToolCall]?

    enum CodingKeys: String, CodingKey {
        case toolCalls = "tool_calls"
    }
}
