# NetworkActivityIndicatorManager

[![Build Status](https://travis-ci.org/ymyzk/NetworkActivityIndicatorManager.svg?branch=master)](https://travis-ci.org/ymyzk/NetworkActivityIndicatorManager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/ymyzk/NetworkActivityIndicatorManager)

**NetworkActivityIndicatorManager** is a manager library of the network activity indicator in the status bar.

## Install
### Carthage
Add `NetworkActivityIndicatorManager` to your `Cartfile` (package dependency) or `Cartfile.private` (development dependency):

```
github "ymyzk/NetworkActivityIndicatorManager"
```

## Usage
```swift
import NetworkActivityIndicatorManager

let manager = NetworkActivityIndicatorManager.sharedManager

manager.increment()
// Some networking operations here
manager.decrement()
```

## License
MIT License. See [LICENSE](LICENSE) for more information.