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
    private let lock = NSLock()

    /**
     Increment counter & update network activity indicator
     */
    @objc public func increment() {
        lock.lock()
        defer { lock.unlock() }

        self.counter += 1
        self.updateNetworkActivityIndicator()
    }

    /**
     Decrement counter & update network activity indicator
     */
    @objc public func decrement() {
        lock.lock()
        defer { lock.unlock() }

        self.counter = max(self.counter - 1, 0)
        self.updateNetworkActivityIndicator()
    }

    /**
     Reset counter & update network activity indicator
     */
    public func reset() {
        lock.lock()
        defer { lock.unlock() }

        self.counter = 0
        self.updateNetworkActivityIndicator()
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

    private func updateNetworkActivityIndicator() {
        // Ensure lock is locked
        guard !lock.tryLock() else {
            lock.unlock()
            fatalError("not locked")
        }
        let isVisible = self.counter > 0
        self.isNetworkActivityIndicatorVisible = isVisible
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = isVisible
        }
    }
}
