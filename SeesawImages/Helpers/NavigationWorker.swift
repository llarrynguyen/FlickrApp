//
//  NavigationWorker.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

protocol NavigationWorker: class {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [NavigationWorker] { get set }
    func begin()
}

extension NavigationWorker {
    func addCoordinator(_ coordinator: NavigationWorker) {
        childCoordinators.append(coordinator)
    }
    
    func removeCoordinator(_ coordinator: NavigationWorker) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func removeAllCoordinators() {
        childCoordinators.removeAll()
    }
}


