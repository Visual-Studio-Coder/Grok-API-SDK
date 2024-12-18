import Foundation

struct LanguageModel: Codable {
    let completionTextTokenPrice: Int
    let created: Int
    let id: String
    let inputModalities: [String]
    let object: String
    let outputModalities: [String]
    let ownedBy: String
    let promptImageTokenPrice: Int
    let promptTextTokenPrice: Int

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
