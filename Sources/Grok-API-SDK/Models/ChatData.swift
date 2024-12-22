import Foundation

public struct ChatMessage: Codable, Sendable {
    let role: String
    let content: String
    let toolCalls: [ToolCall]? // Ensure ToolCall is defined only once in FunctionCall.swift

    init(role: String, content: String, toolCalls: [ToolCall]? = nil) {
        self.role = role
        self.content = content // Fixed 'this' to 'self'
        self.toolCalls = toolCalls
    }

    enum CodingKeys: String, CodingKey {
        case role
        case content
        case toolCalls = "tool_calls"
    }
}

public struct Tool: Codable, Sendable {
    let type: String
    let name: String
    let description: String
    let parameters: FunctionParameters
    let function: FunctionDefinition
}

// Removed duplicate ToolCall struct as it's defined in FunctionCall.swift

public struct ChatCompletionRequest: Codable, Sendable {
    let model: String
    let messages: [ChatMessage]
    let frequencyPenalty: Double?
    let logitBias: [String: Int]?
    let logprobs: Bool?
    let maxTokens: Int?
    let n: Int?
    let presencePenalty: Double?
    let responseFormat: ResponseFormat? // Add responseFormat for structured outputs
    let seed: Int?
    let stop: [String]?
    var stream: Bool? // Changed from 'let' to 'var' to allow assignment
    let temperature: Double?
    let toolChoice: String?
    var tools: [Tool]?
    let topLogprobs: Int?
    let topP: Double?
    let user: String?

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case logprobs
        case maxTokens = "max_tokens"
        case n
        case presencePenalty = "presence_penalty"
        case responseFormat = "response_format"
        case seed
        case stop
        case stream
        case temperature
        case toolChoice = "tool_choice"
        case tools
        case topLogprobs = "top_logprobs"
        case topP = "top_p"
        case user
    }
}

public struct ChatCompletionResponse: Codable, Sendable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [ChatChoice]
    let systemFingerprint: String
    let usage: Usage?

    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case systemFingerprint = "system_fingerprint"
        case usage
    }
}

public struct ChatChoice: Codable, Sendable {
    let index: Int
    let message: ChatMessage
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

public struct Usage: Codable, Sendable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

public struct ChatCompletionChunk: Codable, Sendable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [ChatChunkChoice]
    let usage: Usage?

    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case usage
    }
}

public struct ChatChunkChoice: Codable, Sendable {
    let index: Int
    let delta: ChatDelta?
    let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index
        case delta
        case finishReason = "finish_reason"
    }
}

public struct ChatDelta: Codable, Sendable {
    let role: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case role
        case content
    }
}

public struct ResponseFormat: Codable, Sendable {
    let type: String
    let jsonSchema: JSONSchema

    enum CodingKeys: String, CodingKey {
        case type
        case jsonSchema = "json_schema"
    }
}

public struct JSONSchema: Codable, Sendable {
    let name: String
    let schema: SchemaDetails
    let strict: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case schema
        case strict
    }
}

public struct SchemaDetails: Codable, Sendable {
    let type: String
    let properties: [String: SchemaProperty]
    let required: [String]
    let additionalProperties: Bool

    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case required
        case additionalProperties = "additional_properties"
    }
}

public struct SchemaProperty: Codable, Sendable {
    let type: String
    let description: String?
}
