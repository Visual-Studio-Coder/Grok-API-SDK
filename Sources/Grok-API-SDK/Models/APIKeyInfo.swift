import Foundation

public struct APIKeyInfo: Codable {
    public let redactedApiKey: String
    public let userId: String
    public let name: String
    public let createTime: String
    public let modifyTime: String?
    public let modifiedBy: String
    public let teamId: String
    public let acls: [String]
    public let apiKeyId: String
    public let teamBlocked: Bool
    public let apiKeyBlocked: Bool
    public let apiKeyDisabled: Bool

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
