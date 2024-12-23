import Foundation

public struct Model: Codable {
    public let id: String
    public let created: Int
    public let object: String
    public let ownedBy: String

    enum CodingKeys: String, CodingKey {
        case id
        case created
        case object
        case ownedBy = "owned_by"
    }
}

public struct ModelList: Codable {
    public let data: [Model]
    public let object: String
}
