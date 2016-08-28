//
//  NetworkActivityIndicatorManager.swift
//  NetworkActivityIndicatorManager
//
//  Copyright © 2016 Yusuke Miyazaki.
//

import Foundation
import UIKit

open class NetworkActivityIndicatorManager {
    // MARK: Life cycle

    /// The shared NetworkActivityIndicatorManager
    open static let sharedManager = NetworkActivityIndicatorManager()

    fileprivate init() {}

    deinit {
        unregisterForAllNotifications()
    }

    /// Whether the network activity indicator is currently visible
    open fileprivate(set) var isNetworkActivityIndicatorVisible: Bool = false {
        didSet {
            guard isNetworkActivityIndicatorVisible != oldValue else { return }

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isNetworkActivityIndicatorVisible
            }
        }
    }

    // MARK: Counter

    /// Number of running activities
    open fileprivate(set) var counter = 0
    fileprivate let lock = NSLock()

    /// Increment counter & update network activity indicator
    open func increment() {
        lock.lock()
        defer { lock.unlock() }

        self.counter += 1
        self.updateNetworkActivityIndicator()
    }

    /// Decrement counter & update network activity indicator
    open func decrement() {
        lock.lock()
        defer { lock.unlock() }

        self.counter = max(self.counter - 1, 0)
        self.updateNetworkActivityIndicator()
    }

    /// Reset counter & update network activity indicator
    open func reset() {
        lock.lock()
        defer { lock.unlock() }

        self.counter = 0
        self.updateNetworkActivityIndicator()
    }

    fileprivate func updateNetworkActivityIndicator() {
        // Ensure lock is locked
        guard !lock.try() else {
            lock.unlock()
            fatalError("not locked")
        }
        self.isNetworkActivityIndicatorVisible = self.counter > 0
    }

    // MARK: Notifications

    /// Register a notification to increment the counter
    open func registerForIncrementNotification(_ name: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(incrementForNotification), name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Register a notification to decrement the counter
    open func registerForDecrementNotification(_ name: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(decrementForNotification), name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Unregister a notification to increment the counter
    open func unregisterForIncrementNotification(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Unregister a notification to decrement the counter
    open func unregisterForDecrementNotification(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Unregister all notifications
    fileprivate func unregisterForAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc fileprivate func incrementForNotification() {
        increment()
    }

    @objc fileprivate func decrementForNotification() {
        decrement()
    }
}
