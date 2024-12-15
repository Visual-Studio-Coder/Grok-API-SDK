import Foundation

public struct Model: Codable {
    let id: String
    let created: Int
    let object: String
    let ownedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case created
        case object
        case ownedBy = "owned_by"
    }
}

public struct ModelList: Codable {
    let data: [Model]
    let object: String
}