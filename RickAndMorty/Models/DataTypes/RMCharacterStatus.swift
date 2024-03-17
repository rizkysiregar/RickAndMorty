//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 14/03/24.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    //    The status of the character ('Alive', 'Dead' or 'unknown').
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"  
        }
    }
}
