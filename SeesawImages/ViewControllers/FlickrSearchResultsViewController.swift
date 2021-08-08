//
//  FlickrSearchResultsViewController.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//


import UIKit

class FlickrSearchResultsViewController: UIViewController {
    
    var viewModel: FlickrListViewModel!
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupConstraints()
        registerSearchCells()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.needsRefresh.bind { [weak self] needsRefresh in
            if needsRefresh {
                mainQueue{
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: setup
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 8.0
        collectionView.contentInset.left = 8.0
        collectionView.contentInset.right = 8.0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    func registerSearchCells() {
        collectionView.register(FlickrResultCell.self, forCellWithReuseIdentifier: FlickrResultCell.cellId)
        collectionView.register(UINib(nibName: FlickrResultCell.cellId, bundle: nil), forCellWithReuseIdentifier: FlickrResultCell.cellId)
    }
    
    func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        NSLayoutConstraint.activate(constraints)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = UIScreen.main.bounds.height
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        if endScrolling >= scrollView.contentSize.height - offset {
            viewModel.loadMoreResults{
                photos in
            }
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension FlickrSearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchResultViewModel = viewModel.flickrImages[indexPath.row]
        appCoordinator?.showDetailViewController(viewModel: searchResultViewModel)
    }
}

extension FlickrSearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.flickrImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchResultCell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrResultCell.cellId, for: indexPath) as! FlickrResultCell
        let childViewModel = viewModel?.flickrImages[indexPath.row]
        searchResultCell.viewModel = childViewModel
        return searchResultCell
    }
}

extension FlickrSearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscape = UIApplication.shared.statusBarOrientation.isLandscape
        let cellPadding: CGFloat = 16.0
        let cellWidth = (isLandscape ? (collectionView.frame.size.width / 5.0) : (collectionView.frame.size.width / 2.0)) - cellPadding
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
}



