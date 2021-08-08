//
//  UISearchBar+CustomStyle.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

extension UISearchBar {
    
    private func setTextFieldStyle() {
        guard let textField = value(forKey: "searchField") as? UITextField, let backgroundView = textField.subviews.first else { return }
        textField.textColor = UIColor.darkText
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.clipsToBounds = true
    }
    
    func customStyle() {
        tintColor = .white
        barTintColor = .white
        setTextFieldStyle()
    }
    
    
}
