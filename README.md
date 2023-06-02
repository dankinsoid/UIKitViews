# UIKitViews

UIKitViews is a SwiftUI wrapper around `UIView` and `UIViewController`. It provides seamless integration of UIKit components with the SwiftUI framework. The UIKitView wrapper makes it incredibly easy to add and manipulate UIKit views and view controllers right from your SwiftUI views.\
UIKitViews is a part of [VDLayout](https://github.com/dankinsoid/VDLayout.git) library that provides a DSL syntaxis for UIKit views and view controllers.

## Features

- Straightforward implementation of UIKit components into SwiftUI environment.
- Supports environment variables by `UIView`/`UIViewController` keypathes.
- `HostingView`, an analogy of `UIHostingController` for UIView that supports updating by keypath.
- `SelfSizingHostingController` - `UIHostingController` that matches the root view size.
- Provides a `uiKitViewFixedSize()` method for dynamic self-sizing of the UIKit views.

## Usage

Using UIKitViews is as simple as placing the `UIView` or `UIViewController` you want within the `UIKitView` closure:

```swift
UIKitView {
    UILabel().chain
       .font(.systemFont(ofSize: 24)) // Constant properties
       .textColor(.black)
}
.text(title) // Updatable properties
```

UIKitView also supports environment variables by `UIView`/`UIViewController` keypathes:

```swift
VStack {
  UIKitView {
    UILabel()
  }
  UIKitView {
    UILabel()
  }
}
.uiKitViewEnvironment(\UILabel.font, .systemFont(ofSize: 24))
.uiKitViewFixedSize(.vertical)
```

If you need to access the environment, you can do it like this:

```swift
@Environment(\UILabel.font) var uiLabelFont
```
## Self-sizing with `uiKitViewFixedSize()`

The library includes a method `uiKitViewFixedSize()` that allows the UIKit view to adjust its size dynamically according to its content. You can specify the axis for self-sizing:

- For self-sizing in both dimensions:

```swift
.uiKitViewFixedSize()
```

- For self-sizing mostly in the vertical dimension:

```swift
.uiKitViewFixedSize(.vertical)
```

- For self-sizing mostly in the horizontal dimension:

```swift
.uiKitViewFixedSize(.horizontal)
```

**⚠️ Warning**: The behavior of this method may slightly differ between iOS 16+ and previous versions, it's recommended to test on different iOS versions.\
If you notice some undesirable differences, you can use the `uiKitViewUseWrapper(.always)` method to fix it.

## `HostingView` and `SelfSizingHostingController`

The repository contains two other key features:

- `HostingView`: This is an analogy of `UIHostingController` for `UIView`. It supports updating by keypath.
```swift
struct SomeView: View {

  var text: String
  // ...
}
// ...
let hosting = HostingView(SomeView())
hosting.text = "new text" // it will update the view
```
- `SelfSizingHostingController`: This is an `UIHostingController` that matches the View size, allowing your views to automatically adjust to the size of their content.

## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/UIKitViews.git", from: "1.1.0")
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
pod 'UIKitViews'
```
and run `pod update` from the podfile directory first.

## Author

dankinsoid, voidilov@gmail.com

## License

UIKitView is available under the MIT license. See the LICENSE file for more info.
 
