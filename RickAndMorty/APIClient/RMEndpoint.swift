//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 14/03/24.
//

import Foundation


/// Represent unique API endpoint
@frozen enum Endpoint: String {
    ///  Endpoint to get characher info
    case character
    ///  Endpoint to get location info
    case location
    ///  Endpoint to get episode info
    case episode
}
