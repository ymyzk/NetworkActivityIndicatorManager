//
//  NetworkActivityIndicatorManagerTests.swift
//  NetworkActivityIndicatorManagerTests
//
//  Copyright © 2016 Yusuke Miyazaki.
//

import XCTest
import Nimble
@testable import NetworkActivityIndicatorManager

class NetworkActivityIndicatorManagerTests: XCTestCase {
    private let manager = NetworkActivityIndicatorManager.sharedManager

    override func setUp() {
        super.setUp()

        self.manager.reset()
    }

    func testGetCounter() {
        expect(self.manager.counter) == 0
    }

    func testIncrement() {
        self.manager.increment()
        expect(self.manager.counter) == 1
        self.manager.increment()
        expect(self.manager.counter) == 2
    }

    func testDecrement() {
        for _ in 0..<10 {
            self.manager.increment()
        }
        expect(self.manager.counter) == 10

        self.manager.decrement()
        expect(self.manager.counter) == 9

        for _ in 0..<9 {
            self.manager.decrement()
        }
        expect(self.manager.counter) == 0

        self.manager.decrement()
        expect(self.manager.counter) == 0
    }

    func testIsNetworkActivityIndicatorVisible() {
        expect(self.manager.isNetworkActivityIndicatorVisible) == false
        self.manager.increment()
        expect(self.manager.isNetworkActivityIndicatorVisible) == true
        self.manager.decrement()
        expect(self.manager.isNetworkActivityIndicatorVisible) == false
    }

    func testConcurrentExample() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

        for _ in 0..<5000 {
            dispatch_async(queue) {
                self.manager.increment()
            }
        }

        for _ in 0..<2000 {
            dispatch_async(queue) {
                self.manager.decrement()
            }
        }

        expect(self.manager.counter).toEventually(equal(3000))
    }

    func testSerialPerformanceExample() {
        self.measureBlock {
            for _ in 0..<5000 {
                self.manager.increment()
            }

            for _ in 0..<5000 {
                self.manager.decrement()
            }

            expect(self.manager.counter) == 0
        }
    }

    func testIncrementObserver() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let notificationName = "com.ymyzk.NetworkActivityIndicatorManager.IncrementNotification"
        self.manager.registerForIncrementNotification(notificationName)
        expect(self.manager.counter) == 0
        notificationCenter.postNotificationName(notificationName, object: nil)
        expect(self.manager.counter) == 1
        self.manager.unregisterForIncrementNotification(notificationName)
        notificationCenter.postNotificationName(notificationName, object: nil)
        expect(self.manager.counter) == 1
    }

    func testDecrementObserver() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let notificationName = "com.ymyzk.NetworkActivityIndicatorManager.DecrementNotification"
        self.manager.increment()
        self.manager.increment()
        expect(self.manager.counter) == 2
        self.manager.registerForDecrementNotification(notificationName)
        notificationCenter.postNotificationName(notificationName, object: nil)
        expect(self.manager.counter) == 1
        self.manager.unregisterForDecrementNotification(notificationName)
        notificationCenter.postNotificationName(notificationName, object: nil)
        expect(self.manager.counter) == 1
    }
}
