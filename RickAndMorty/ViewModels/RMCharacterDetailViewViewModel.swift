//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 17/03/24.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
