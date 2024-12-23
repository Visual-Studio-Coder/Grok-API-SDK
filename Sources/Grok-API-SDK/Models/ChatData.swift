import Foundation

public struct ChatMessage: Codable, Sendable {
    public let role: String
    public let content: String
    public let toolCalls: [ToolCall]? // Ensure ToolCall is defined only once in FunctionCall.swift

    // Explicit public initializer
    public init(role: String, content: String, toolCalls: [ToolCall]? = nil) {
        self.role = role
        self.content = content
        self.toolCalls = toolCalls
    }

    enum CodingKeys: String, CodingKey {
        case role
        case content
        case toolCalls = "tool_calls"
    }
}

public struct Tool: Codable, Sendable {
    public let type: String
    public let name: String
    public let description: String
    public let parameters: FunctionParameters
    public let function: FunctionDefinition
}

// Removed duplicate ToolCall struct as it's defined in FunctionCall.swift

public struct ChatCompletionRequest: Codable, Sendable {
    public let model: String
    public let messages: [ChatMessage]
    public let frequencyPenalty: Double?
    public let logitBias: [String: Int]?
    public let logprobs: Bool?
    public let maxTokens: Int?
    public let n: Int?
    public let presencePenalty: Double?
    public let responseFormat: ResponseFormat?
    public let seed: Int?
    public let stop: [String]?
    public var stream: Bool?
    public let temperature: Double?
    public let toolChoice: String?
    public var tools: [Tool]?
    public let topLogprobs: Int?
    public let topP: Double?
    public let user: String?

    // Explicit initializer
    public init(model: String,
                messages: [ChatMessage],
                frequencyPenalty: Double? = nil,
                logitBias: [String: Int]? = nil,
                logprobs: Bool? = nil,
                maxTokens: Int? = nil,
                n: Int? = nil,
                presencePenalty: Double? = nil,
                responseFormat: ResponseFormat? = nil,
                seed: Int? = nil,
                stop: [String]? = nil,
                stream: Bool? = nil,
                temperature: Double? = nil,
                toolChoice: String? = nil,
                tools: [Tool]? = nil,
                topLogprobs: Int? = nil,
                topP: Double? = nil,
                user: String? = nil) {
        self.model = model
        self.messages = messages
        self.frequencyPenalty = frequencyPenalty
        self.logitBias = logitBias
        self.logprobs = logprobs
        self.maxTokens = maxTokens
        self.n = n
        self.presencePenalty = presencePenalty
        self.responseFormat = responseFormat
        self.seed = seed
        self.stop = stop
        self.stream = stream
        self.temperature = temperature
        self.toolChoice = toolChoice
        self.tools = tools
        self.topLogprobs = topLogprobs
        self.topP = topP
        self.user = user
    }

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
    public let id: String
    public let object: String
    public let created: Int
    public let model: String
    public let choices: [ChatChoice]
    public let systemFingerprint: String
    public let usage: Usage?

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
    public let index: Int
    public let message: ChatMessage
    public let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

public struct Usage: Codable, Sendable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

public struct ChatCompletionChunk: Codable, Sendable {
    public let id: String
    public let object: String
    public let created: Int
    public let model: String
    public let choices: [ChatChunkChoice]
    public let usage: Usage?

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
    public let index: Int
    public let delta: ChatDelta?
    public let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case index
        case delta
        case finishReason = "finish_reason"
    }
}

public struct ChatDelta: Codable, Sendable {
    public let role: String?
    public let content: String?

    enum CodingKeys: String, CodingKey {
        case role
        case content
    }
}

public struct ResponseFormat: Codable, Sendable {
    public let type: String
    public let jsonSchema: JSONSchema

    enum CodingKeys: String, CodingKey {
        case type
        case jsonSchema = "json_schema"
    }
}

public struct JSONSchema: Codable, Sendable {
    public let name: String
    public let schema: SchemaDetails
    public let strict: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case schema
        case strict
    }
}

public struct SchemaDetails: Codable, Sendable {
    public let type: String
    public let properties: [String: SchemaProperty]
    public let required: [String]
    public let additionalProperties: Bool

    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case required
        case additionalProperties = "additional_properties"
    }
}

public struct SchemaProperty: Codable, Sendable {
    public let type: String
    public let description: String?
}
