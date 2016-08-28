//
//  NetworkActivityIndicatorManager.swift
//  NetworkActivityIndicatorManager
//
//  Copyright © 2016 Yusuke Miyazaki.
//

import Foundation
import UIKit

public class NetworkActivityIndicatorManager {
    // MARK: Life cycle

    /// The shared NetworkActivityIndicatorManager
    public static let sharedManager = NetworkActivityIndicatorManager()

    private init() {}

    deinit {
        unregisterForAllNotifications()
    }

    /// Whether the network activity indicator is currently visible
    public private(set) var isNetworkActivityIndicatorVisible: Bool = false {
        didSet {
            guard isNetworkActivityIndicatorVisible != oldValue else { return }

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isNetworkActivityIndicatorVisible
            }
        }
    }

    // MARK: Counter

    /// Number of running activities
    public private(set) var counter = 0
    private let lock = NSLock()

    /// Increment counter & update network activity indicator
    public func increment() {
        lock.lock()
        defer { lock.unlock() }

        self.counter += 1
        self.updateNetworkActivityIndicator()
    }

    /// Decrement counter & update network activity indicator
    public func decrement() {
        lock.lock()
        defer { lock.unlock() }

        self.counter = max(self.counter - 1, 0)
        self.updateNetworkActivityIndicator()
    }

    /// Reset counter & update network activity indicator
    public func reset() {
        lock.lock()
        defer { lock.unlock() }

        self.counter = 0
        self.updateNetworkActivityIndicator()
    }

    private func updateNetworkActivityIndicator() {
        // Ensure lock is locked
        guard !lock.try() else {
            lock.unlock()
            fatalError("not locked")
        }
        self.isNetworkActivityIndicatorVisible = self.counter > 0
    }

    // MARK: Notifications

    /// Register a notification to increment the counter
    public func registerForIncrementNotification(_ name: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(incrementForNotification), name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Register a notification to decrement the counter
    public func registerForDecrementNotification(_ name: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(decrementForNotification), name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Unregister a notification to increment the counter
    public func unregisterForIncrementNotification(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Unregister a notification to decrement the counter
    public func unregisterForDecrementNotification(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }

    /// Unregister all notifications
    private func unregisterForAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func incrementForNotification() {
        increment()
    }

    @objc private func decrementForNotification() {
        decrement()
    }
}
