import Foundation

// Import the ChatCompletion models
import Grok_API_SDK

public enum GrokAPIError: Error, LocalizedError {
    case invalidResponse
    case httpError(Int)
    case noData
    case decodingError(Error)
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from the server."
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode). Please check your API key and endpoint."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription). Please check the response format."
        case .custom(let message):
            return message
        }
    }
}

public class GrokAPI {
    private let baseURL = URL(string: "https://api.x.ai/v1")!
    private let session: URLSession
    private let apiKey: String
    
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func fetchData<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(GrokAPIError.custom(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(GrokAPIError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(GrokAPIError.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(GrokAPIError.noData))
                return
            }
            
            // Print the raw response data for debugging
            print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(GrokAPIError.decodingError(error)))
            }
        }
        task.resume()
    }
    
    public func getAPIKeyInfo(completion: @escaping (Result<APIKeyInfo, Error>) -> Void) {
        fetchData(endpoint: "api-key", responseType: APIKeyInfo.self, completion: completion)
    }
    
    public func listModels(completion: @escaping (Result<ModelList, Error>) -> Void) {
        fetchData(endpoint: "models", responseType: ModelList.self, completion: completion)
    }
    
    public func createChatCompletion(request: ChatCompletionRequest, completion: @escaping (Result<ChatCompletionResponse, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("chat/completions")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(GrokAPIError.custom("Failed to encode request body: \(error.localizedDescription)")))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(GrokAPIError.custom(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(GrokAPIError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(GrokAPIError.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(GrokAPIError.noData))
                return
            }
            
            // Print the raw response data for debugging
            print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(GrokAPIError.decodingError(error)))
            }
        }
        task.resume()
    }
}
