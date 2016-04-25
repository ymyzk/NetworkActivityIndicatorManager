# NetworkActivityIndicatorManager

[![Build Status](https://travis-ci.org/ymyzk/NetworkActivityIndicatorManager.svg?branch=master)](https://travis-ci.org/ymyzk/NetworkActivityIndicatorManager)
[![CocoaPods](https://img.shields.io/cocoapods/v/NetworkActivityIndicatorManager.svg?maxAge=2592000)](https://cocoapods.org/pods/NetworkActivityIndicatorManager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/ymyzk/NetworkActivityIndicatorManager)
[![Platform](https://img.shields.io/cocoapods/p/NetworkActivityIndicatorManager.svg?style=flat)](http://cocoadocs.org/docsets/NetworkActivityIndicatorManager)

**NetworkActivityIndicatorManager** is a manager library of the network activity indicator in the status bar.

## Install
### Carthage
Add `NetworkActivityIndicatorManager` to your `Cartfile` (package dependency) or `Cartfile.private` (development dependency):

```
github "ymyzk/NetworkActivityIndicatorManager"
```

### CocoaPods
Add `NetworkActivityIndicatorManager` to your `Podfile`.

```
use_frameworks!

pod 'NetworkActivityIndicatorManager', '~> 0.3'
```

## Usage
### Manually
```swift
import NetworkActivityIndicatorManager

let manager = NetworkActivityIndicatorManager.sharedManager

manager.increment()
// Some networking operations here
manager.decrement()
```

### Notifications
By sending notifications, you can increment/decrement the counter.

```swift
import NetworkActivityIndicatorManager

let manager = NetworkActivityIndicatorManager.sharedManager

let incrementNotification = "increment"
let decrementNotification = "decrement"

manager.registerForIncrementNotification(incrementNotification)
manager.registerForDecrementNotification(decrementNotification)

NSNotificationCenter.defaultCenter().postNotificationName(incrementNotification, object: nil)
// Some networking operations here
NSNotificationCenter.defaultCenter().postNotificationName(decrementNotification, object: nil)
```

Some libraries send notifications on start/end network activities.

#### AFNetworking
```swift
import AFNetworking
import NetworkActivityIndicatorManager

let manager = NetworkActivityIndicatorManager.sharedManager
manager.registerForIncrementNotification(AFNetworkingTaskDidResumeNotification
manager.registerForDecrementNotification(AFNetworkingTaskDidSuspendNotification)
manager.registerForDecrementNotification(AFNetworkingTaskDidCompleteNotification)
```

#### Alamofire
```swift
import Alamofire
import NetworkActivityIndicatorManager

let manager = NetworkActivityIndicatorManager.sharedManager
manager.registerForIncrementNotification(Notifications.Task.DidResume)
manager.registerForDecrementNotification(Notifications.Task.DidSuspend)
manager.registerForDecrementNotification(Notifications.Task.DidComplete)
```

#### SDWebImage
```swift
import NetworkActivityIndicatorManager
import SDWebImage

let manager = NetworkActivityIndicatorManager.sharedManager
manager.registerForIncrementNotification(SDWebImageDownloadStartNotification)
manager.registerForDecrementNotification(SDWebImageDownloadStopNotification)
```

## License
MIT License. See [LICENSE](LICENSE) for more information.
