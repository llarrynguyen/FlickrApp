//
//  Throttler.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import Foundation

class Throttler {
    
    private let backgroundQueue = DispatchQueue.global(qos: .background)
    private var pendingWorkItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var lastJobDate: Date = Date.distantPast
    private var interval: Double
    
    init(seconds: Double) {
        self.interval = seconds
    }
    
    // MARK: - Method
    func throttle(block: @escaping () -> ()) {
        pendingWorkItem.cancel()
        pendingWorkItem = DispatchWorkItem() { [weak self] in
            self?.lastJobDate = Date()
            block()
        }
        let delay = Double(Date().timeIntervalSince(lastJobDate).rounded()) > interval ? 0 : interval
        backgroundQueue.asyncAfter(deadline: .now() + delay, execute: pendingWorkItem)
    }
}

