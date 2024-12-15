//import Foundation
//
//public enum GrokAPIError: Error, LocalizedError {
//    case invalidResponse
//    case httpError(Int)
//    case noData
//    case decodingError(Error)
//    case custom(String)
//    
//    public var errorDescription: String? {
//        switch self {
//        case .invalidResponse:
//            return "Invalid response from the server."
//        case .httpError(let statusCode):
//            return "HTTP Error: \(statusCode)"
//        case .noData:
//            return "No data received from the server."
//        case .decodingError(let error):
//            return "Decoding error: \(error.localizedDescription)"
//        case .custom(let message):
//            return message
//        }
//    }
//}
