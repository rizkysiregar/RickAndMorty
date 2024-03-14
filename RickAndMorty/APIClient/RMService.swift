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
    
    /// Privalized constructor
    public init() {}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - completion: callback wit data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
