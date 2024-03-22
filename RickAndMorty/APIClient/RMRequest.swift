//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 14/03/24.
//

import Foundation


/// Object that represent a single API Call
final class RMRequest {
    /// Base url, Endpoint, Path component, Query Param
    /// https://rickandmortyapi.com/api/
    
    
    /// API Constant
    private struct Constant {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: RMEndpoint
    
    /// Path componenet for API, if any
    private let pathComponents: [String]
    
    /// Query argument for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructor url for the api request in string format
    private var urlString: String {
        var string = Constant.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else{ return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        return string
    }
    
    /// the actual URL String that made form urlString connstructor
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Disired http method
    public let httpMethod = "GET"
    
    
    // MARK: Make it public
    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []) {
            self.endpoint = endpoint
            self.pathComponents = pathComponents
            self.queryParameters = queryParameters
        }
    
    ///"next": "https://rickandmortyapi.com/api/character/?page=2",
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constant.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constant.baseUrl+"/", with: "")
        /// trimmerd is =  character/?page=2",
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                // this going to be the endpoint exmple: character
                let endpointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemString = components[1] // page=2
                
                //value=name&value=name
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    
                    guard $0.contains("=") else {
                        return nil
                    }
                    
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}


extension RMRequest {
    static let listCharacterRequests = RMRequest(endpoint: .character)
}
