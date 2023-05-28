# UIKitView

[![CI Status](https://img.shields.io/travis/dankinsoid/UIKitView.svg?style=flat)](https://travis-ci.org/dankinsoid/UIKitView)
[![Version](https://img.shields.io/cocoapods/v/UIKitView.svg?style=flat)](https://cocoapods.org/pods/UIKitView)
[![License](https://img.shields.io/cocoapods/l/UIKitView.svg?style=flat)](https://cocoapods.org/pods/UIKitView)
[![Platform](https://img.shields.io/cocoapods/p/UIKitView.svg?style=flat)](https://cocoapods.org/pods/UIKitView)


## Description
This repository provides

## Example

```swift

```
## Usage

 
## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/UIKitView.git", from: "0.1.0")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["UIKitView"])
  ]
)
```
```ruby
$ swift build
```

2.  [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'UIKitView'
```
and run `pod update` from the podfile directory first.

## Author

dankinsoid, voidilov@gmail.com

## License

UIKitView is available under the MIT license. See the LICENSE file for more info.
