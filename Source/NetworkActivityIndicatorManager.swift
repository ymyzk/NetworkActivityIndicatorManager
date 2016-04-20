//
//  NetworkActivityIndicatorManager.swift
//  NetworkActivityIndicatorManager
//
//  Copyright © 2016 Yusuke Miyazaki. All rights reserved.
//

import Foundation
import UIKit

public class NetworkActivityIndicatorManager {
    // MARK: Life cycle

    public static let sharedManager = NetworkActivityIndicatorManager()

    private init() {}

    deinit {
        let center = NSNotificationCenter.defaultCenter()
        for name in incrementNotificationNames {
            center.removeObserver(self, name: name, object: nil)
        }
        for name in decrementNotificationNames {
            center.removeObserver(self, name: name, object: nil)
        }
    }

    // MARK: Counter

    public private(set) var counter = 0
    public private(set) var isNetworkActivityIndicatorVisible = false
    private let lockQueue = dispatch_queue_create("com.ymyzk.NetworkActivityIndicatorManager.LockQueue", DISPATCH_QUEUE_SERIAL)

    /**
     Run a block in serial queue for locking
     */
    private func runInLockQueue(block: dispatch_block_t) {
        dispatch_sync(lockQueue, block)
    }

    /**
     Run a block in serial queue for locking & update network activity indicator
     */
    private func runAndUpdateIndicatorInLockQueue(block: dispatch_block_t) {
        self.runInLockQueue() {
            block()
            self.updateNetworkActivityIndicator()
        }
    }

    /**
     Increment counter & update network activity indicator
     */
    @objc public func increment() {
        runAndUpdateIndicatorInLockQueue() {
            self.counter += 1
        }
    }

    /**
     Decrement counter & update network activity indicator
     */
    @objc public func decrement() {
        runAndUpdateIndicatorInLockQueue() {
            self.counter = max(self.counter - 1, 0)
        }
    }

    /**
     Reset counter & update network activity indicator
     */
    public func reset() {
        runAndUpdateIndicatorInLockQueue() {
            self.counter = 0
        }
    }

    // MARK: Notifications

    private var incrementNotificationNames = Set<String>()
    private var decrementNotificationNames = Set<String>()

    public func addIncrementObserver(name: String) {
        guard !incrementNotificationNames.contains(name) else { return }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(increment), name: name, object: nil)
        incrementNotificationNames.insert(name)
    }

    public func addDecrementObserver(name: String) {
        guard !decrementNotificationNames.contains(name) else { return }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(decrement), name: name, object: nil)
        decrementNotificationNames.insert(name)
    }

    public func removeIncrementObserver(name: String) {
        guard incrementNotificationNames.contains(name) else { return }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: name, object: nil)
        incrementNotificationNames.remove(name)
    }

    public func removeDecrementObserver(name: String) {
        guard decrementNotificationNames.contains(name) else { return }
        NSNotificationCenter.defaultCenter().removeObserver(self, name: name, object: nil)
        decrementNotificationNames.remove(name)
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
