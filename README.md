# ${NAME}

[![CI Status](https://img.shields.io/travis/dankinsoid/${NAME}.svg?style=flat)](https://travis-ci.org/dankinsoid/${NAME})
[![Version](https://img.shields.io/cocoapods/v/${NAME}.svg?style=flat)](https://cocoapods.org/pods/${NAME})
[![License](https://img.shields.io/cocoapods/l/${NAME}.svg?style=flat)](https://cocoapods.org/pods/${NAME})
[![Platform](https://img.shields.io/cocoapods/p/${NAME}.svg?style=flat)](https://cocoapods.org/pods/${NAME})


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
    .package(url: "https://github.com/dankinsoid/${NAME}.git", from: "0.0.1")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["${NAME}"])
  ]
)
```
```ruby
$ swift build
```

2.  [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod '${NAME}'
```
and run `pod update` from the podfile directory first.

## Author

dankinsoid, voidilov@gmail.com

## License

${NAME} is available under the MIT license. See the LICENSE file for more info.
