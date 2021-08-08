//
//  Binder.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import Foundation

class Binder<T> {
    
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

