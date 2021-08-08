//
//  BaseSearchViewController.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

class BaseSearchViewController: UIViewController {
    
    // MARK: - Private
    
    private weak var _searchController: UISearchController?
    private weak var _searchResultsViewController: FlickrSearchResultsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSearchControllers()
    }
    
    func initializeSearchControllers() {
        let searchResultsViewController = FlickrSearchResultsViewController()
        searchResultsViewController.viewModel = FlickrListViewModel(apiClient: APIClient())
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        _searchResultsViewController = searchResultsViewController
        _searchController = searchController
        let placeholderText = NSLocalizedString("Search Images", comment: "Search placeholder text")
        searchController.searchBar.placeholder = placeholderText
        searchController.searchResultsUpdater = self
        searchController.searchBar.customStyle()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

// MARK: - UISearchResultsUpdating

extension BaseSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsController = searchController.searchResultsController as? FlickrSearchResultsViewController else { return }
        guard let searchTerm = searchController.searchBar.text else { return }
        searchResultsController.viewModel.searchTerm = searchTerm
    }
}


