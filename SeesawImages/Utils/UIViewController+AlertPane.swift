//
//  UIViewController+AlertPane.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

extension UIViewController {
    func presentAlert(with error: Error?) {
        guard let error = error else { return }
        let errorTitle = NSLocalizedString("We're sorry, Please try again later.", comment: "Error alert ")
        let alert = UIAlertController(title: errorTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
