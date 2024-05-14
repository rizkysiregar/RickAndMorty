//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 26/04/24.
//

import UIKit

class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEposideData()
    }
    
    private func fetchEposideData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure:
                break
            }
        }
        
    }
    
}
