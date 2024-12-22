import Foundation

public struct APIKeyInfo: Codable {
    let redactedApiKey: String
    let userId: String
    let name: String
    let createTime: String
    let modifyTime: String?
    let modifiedBy: String
    let teamId: String
    let acls: [String]
    let apiKeyId: String
    let teamBlocked: Bool
    let apiKeyBlocked: Bool
    let apiKeyDisabled: Bool

    enum CodingKeys: String, CodingKey {
        case redactedApiKey = "redacted_api_key"
        case userId = "user_id"
        case name
        case createTime = "create_time"
        case modifyTime = "modify_time"
        case modifiedBy = "modified_by"
        case teamId = "team_id"
        case acls
        case apiKeyId = "api_key_id"
        case teamBlocked = "team_blocked"
        case apiKeyBlocked = "api_key_blocked"
        case apiKeyDisabled = "api_key_disabled"
    }
}
