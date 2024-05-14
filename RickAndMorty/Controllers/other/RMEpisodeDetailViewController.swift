//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 26/03/24.
//

import UIKit

class RMEpisodeDetailViewController: UIViewController {
    private let viewModel: RMEpisodeDetailViewViewModel
    
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
    
}
