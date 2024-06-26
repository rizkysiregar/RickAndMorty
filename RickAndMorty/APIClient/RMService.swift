//
//  RMService.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 14/03/24.
//

import Foundation


/// Primary API Service object to get Rick and Morty data
final class RMService {
    
    /// Shared singleton instance
    static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    /// Privalized constructor
    public init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - type: The type of object we expect to get back
    ///   - completion: callback wit data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            if let cacheData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
                print("using cache api request")
                do {
                    let result = try JSONDecoder().decode(type.self, from: cacheData)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToGetData))
                    return
                }
                
                // decode response
                do {
                    //let json = try JSONSerialization.jsonObject(with: data)
                    let result = try JSONDecoder().decode(type.self, from: data)
                    self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                    completion(.success(result))
                    //                    print(String(describing:result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    
    // MARK: - Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
