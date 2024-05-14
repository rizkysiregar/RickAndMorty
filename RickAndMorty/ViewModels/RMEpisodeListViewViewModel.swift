//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 27/04/24.
//

import UIKit


protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisode()
    func didLoadMoreEpisode(newIndexPath: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

/// View model to handle character list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url)
                )
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllEpisodeResponse.Info? = nil
    private var isLoadingMoreEpisodes = false
    /// fetch initial set of episode [20]
    public func fetchEpisodes() {
        RMService.shared.execute(.listEpisodeRequests, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                
                // tell with delegate that data is change
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisode()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// paginate if additional episode  are needed
    /// "next": "https://rickandmortyapi.com/api/character/?page=2"
    public func fetchAdditionalEpisode(url: URL) {
        
        guard !isLoadingMoreEpisodes else {
            return
        }
        
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            /// to avoid null save || optional ex: self?.characters
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                let originalCount = strongSelf.episodes.count
                let newCount = moreResult.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                 IndexPath(row: $0, section: 0)
                })
                print(indexPathToAdd)
                /// append the episode not replace it
                strongSelf.episodes.append(contentsOf: moreResult)
                
                
                /// tell with delegate that data is change
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisode(
                        newIndexPath: indexPathToAdd
                    )
                    strongSelf.isLoadingMoreEpisodes = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreEpisodes = false
            }
        }
        
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
}

// MARK: - CollectionView
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// note to my self: use the unique method signature for call the override function AKA protocol/interface
    /// example type numberOfItemsInSection, cellForItemAt, sizeFormatItemAt
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    /// for handle footter loader in lisview character
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
             
        
        //        guard kind == UICollectionView.elementKindSectionFooter else {
        //            fatalError("Unsupported")
        //        }
        //
        //        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath)
        //
        //        return footer
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(
            width: collectionView.frame.width, height: 100
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width, height: width * 0.8
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
}


// MARK: Scrollview
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false){ [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
//                print("should start fetching more characters")
                self?.fetchAdditionalEpisode(url: url)
            }
            t.invalidate()
        }
        
        
    }
}
