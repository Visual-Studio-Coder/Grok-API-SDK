import Foundation
import CFNetwork // Add this import

// Ensure that the Models module is imported if it's separate
// import Models

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
    public let session: URLSession
    public let apiKey: String
    
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    internal func fetchData<T: Decodable>(endpoint: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
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
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Raw response data:\n\(prettyString)")
            } else {
                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
            
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
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Raw response data:\n\(prettyString)")
            } else {
                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(GrokAPIError.decodingError(error)))
            }
        }
        task.resume()
    }
    
    public func createChatCompletionWithFunctionCallAsync(
        request: ChatCompletionRequest,
        tools: [Tool]
    ) async throws -> ChatCompletionResponse {
        let url = baseURL.appendingPathComponent("chat/completions")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestWithTools = request
        requestWithTools.tools = tools
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(requestWithTools)
        } catch {
            throw GrokAPIError.custom("Failed to encode request body: \(error.localizedDescription)")
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            // Print the raw response data for debugging
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Raw response data:\n\(prettyString)")
            } else {
                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw GrokAPIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw GrokAPIError.httpError(httpResponse.statusCode)
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                return decodedResponse
            } catch {
                // **Enhance Error Logging for Missing Fields**
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Missing key: \(key) in \(context.debugDescription)")
                    default:
                        break
                    }
                }
                throw GrokAPIError.decodingError(error)
            }
        } catch {
            if let urlError = error as? URLError, let data = urlError.userInfo[NSURLErrorFailingURLStringErrorKey] as? Data {
                print("Raw response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
            throw GrokAPIError.custom(error.localizedDescription)
        }
    }
    
    // Updated streaming method to yield partial content strings
    public func createChatCompletionStream(request: ChatCompletionRequest) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let url = baseURL.appendingPathComponent("chat/completions")
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var requestWithTools = request
            requestWithTools.stream = true
            requestWithTools.tools = request.tools // Ensure tools are included if any
            
            do {
                urlRequest.httpBody = try JSONEncoder().encode(requestWithTools)
            } catch {
                continuation.finish(throwing: GrokAPIError.custom("Failed to encode request body: \(error.localizedDescription)"))
                return
            }
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.finish(throwing: GrokAPIError.custom(error.localizedDescription))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    continuation.finish(throwing: GrokAPIError.invalidResponse)
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    // Print the raw error response
                    if let data = data {
                        if let eventString = String(data: data, encoding: .utf8) {
                            print("Error Response (\(httpResponse.statusCode)):\n\(eventString)") // Enhanced logging
                        } else {
                            print("Error Response (\(httpResponse.statusCode)): Unable to parse response data.")
                        }
                    } else {
                        print("Error Response (\(httpResponse.statusCode)): No data received.")
                    }
                    continuation.finish(throwing: GrokAPIError.httpError(httpResponse.statusCode))
                    return
                }
                
                guard let data = data else {
                    continuation.finish(throwing: GrokAPIError.noData)
                    return
                }
                
                // Handle SSE parsing with enhanced logging and yield partial content
                if let eventString = String(data: data, encoding: .utf8) {
                    let events = eventString.components(separatedBy: "\n\n")
                    for event in events {
                        if event.starts(with: "data: ") {
                            let rawEvent = event.replacingOccurrences(of: "data: ", with: "")
                            print("Raw event received:\n\(rawEvent)") // Print raw event
                            
                            if rawEvent == "[DONE]" {
                                print("Stream ended with [DONE].")
                                continuation.finish()
                                return
                            }
                            
                            guard let jsonData = rawEvent.data(using: .utf8) else {
                                print("Failed to convert event string to Data.")
                                continue
                            }
                            
                            do {
                                let chunk = try JSONDecoder().decode(ChatCompletionChunk.self, from: jsonData)
                                if let delta = chunk.choices.first?.delta, let content = delta.content { // { Unwrap delta safely }
                                    continuation.yield(content)
                                }
                            } catch {
                                print("Decoding error for event:\n\(rawEvent)\nError: \(error.localizedDescription)") // Enhanced error logging
                                continuation.finish(throwing: GrokAPIError.decodingError(error))
                                return
                            }
                        }
                    }
                } else {
                    print("Unable to convert data to String for SSE parsing.")
                    continuation.finish(throwing: GrokAPIError.custom("Failed to parse streamed data as string."))
                }
                
                continuation.finish()
            }
            task.resume()
            
            // Handle cancellation
            continuation.onTermination = { @Sendable termination in
                task.cancel()
            }
        }
    }
}
