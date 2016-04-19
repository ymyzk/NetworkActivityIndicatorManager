//
//  NetworkActivityIndicatorManager.swift
//  NetworkActivityIndicatorManager
//
//  Copyright © 2016 Yusuke Miyazaki. All rights reserved.
//

import Foundation
import UIKit

public class NetworkActivityIndicatorManager {
    private init() {}
    public static let sharedManager = NetworkActivityIndicatorManager()

    public private(set) var counter = 0
    public private(set) var isNetworkActivityIndicatorVisible = false
    private let lockQueue = dispatch_queue_create("com.ymyzk.NetworkActivityIndicatorManager.LockQueue", nil)

    public func increment() {
        dispatch_sync(lockQueue) {
            self.counter += 1
            self.updateNetworkActivityIndicator()
        }
    }

    public func decrement() {
        dispatch_sync(lockQueue) {
            self.counter = max(self.counter - 1, 0)
            self.updateNetworkActivityIndicator()
        }
    }

    public func reset() {
        dispatch_sync(lockQueue) {
            self.counter = 0
            self.updateNetworkActivityIndicator()
        }
    }

    // 必ず lockQueue で実行すること
    private func updateNetworkActivityIndicator() {
        let isVisible = self.counter > 0
        self.isNetworkActivityIndicatorVisible = isVisible
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = isVisible
        }
    }
}
