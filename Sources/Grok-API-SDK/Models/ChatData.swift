import Foundation

public struct ChatMessage: Codable {
    let role: String
    let content: String
}

public struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let frequencyPenalty: Double?
    let logitBias: [String: Int]?
    let logprobs: Bool?
    let maxTokens: Int?
    let n: Int?
    let presencePenalty: Double?
    let responseFormat: String?
    let seed: Int?
    let stop: [String]?
    let stream: Bool?
    let temperature: Double?
    let toolChoice: String?
    let tools: [String]?
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
