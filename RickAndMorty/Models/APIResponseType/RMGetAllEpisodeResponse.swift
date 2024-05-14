//
//  RMGetAllEpisodeResponse.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 27/04/24.
//

import Foundation

struct RMGetAllEpisodeResponse : Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
}
