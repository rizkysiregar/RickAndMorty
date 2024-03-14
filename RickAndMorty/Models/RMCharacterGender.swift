//
//  RMCharacterGender.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 14/03/24.
//

import Foundation

enum RMCharacterGender: String, Codable {
    ///The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case `unknown` = "unknown"
}
