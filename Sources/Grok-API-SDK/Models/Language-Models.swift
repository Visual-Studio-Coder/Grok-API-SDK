import Foundation

struct LanguageModel: Codable {
    public let completionTextTokenPrice: Int
    public let created: Int
    public let id: String
    public let inputModalities: [String]
    public let object: String
    public let outputModalities: [String]
    public let ownedBy: String
    public let promptImageTokenPrice: Int
    public let promptTextTokenPrice: Int

    enum CodingKeys: String, CodingKey {
        case completionTextTokenPrice = "completion_text_token_price"
        case created
        case id
        case inputModalities = "input_modalities"
        case object
        case outputModalities = "output_modalities"
        case ownedBy = "owned_by"
        case promptImageTokenPrice = "prompt_image_token_price"
        case promptTextTokenPrice = "prompt_text_token_price"
    }
}

struct LanguageModelsResponse: Codable {
    let models: [LanguageModel]
}
