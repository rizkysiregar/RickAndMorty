//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 14/03/24.
//

import UIKit

final class RMEpisodeViewController: UIViewController, RMEpisodelistViewDelegate {
    
    private let episodeListView = RMEpisodeListView() // get the list of views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        
        view.addSubview(episodeListView)
        setupView()
    }
    
    func setupView() {
        episodeListView.delegate = self
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
    
    // MARK: Delegate implementation // override - RMEpisodeViewDelegate
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
