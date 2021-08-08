//
//  AppNavigationWorker.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

class AppNavigationWorker: NavigationWorker {
    
    var navigationController: UINavigationController
    var childCoordinators: [NavigationWorker] = []
    
    var appNavigationWorker: AppNavigationWorker?
    
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func begin() {
        showHomeViewController()
    }
    
    func showHomeViewController() {
        let homeViewController = HomeViewController()
        homeViewController.title = NSLocalizedString("Flickr Findr", comment: "title")
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    func showDetailViewController(viewModel: FlickrImage) {
        let detailViewController = FlickrDetailViewController()
        detailViewController.viewModel = viewModel
        detailViewController.title = NSLocalizedString("About", comment: " detail title")
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
}

extension UIViewController {
    weak var appCoordinator: AppNavigationWorker? {
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            return sd.appNavigationWorker
        }
        return nil
    }
}

