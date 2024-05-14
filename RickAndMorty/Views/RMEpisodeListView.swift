//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 27/04/24.
//

import UIKit

/// protocol the handle when item character is clicked and send it to the RMEpisodeListViewController
protocol RMEpisodelistViewDelegate: AnyObject {
    func rmEpisodeListView(
        _ episodeListView: RMEpisodeListView,
        didSelectEpisode episode: RMEpisode
    )
}

/// View that handles showing list of characters, loader, etc
final class RMEpisodeListView: UIView {
    
    public weak var delegate: RMEpisodelistViewDelegate?
    private let  viewModel = RMEpisodeListViewViewModel()
    
    /// spinner is loading indicator
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        
        // footer loading view || when there is more item to load
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView,spinner)
        
        addConstraint()
        spinner.startAnimating()
        
        viewModel.delegate = self
        viewModel.fetchEpisodes()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self,didSelectEpisode: episode)
    }
    
    func didLoadInitialEpisode() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // initial fetch
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisode(newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
}

