# UIKitViews

## Description

Easily use `UIView`s and `UIViewController`s in SwiftUI.
`UIKitViews` is based on [key paths chaining](https://github.com/dankinsoid/VDChain.git)

## Examples

```swift
import SwiftUI
import UIKitViews

struct SomeView: View {

    @State private var text = "Some text that"

    // Access to UIKitView environments
    @Environment(\UIView.tintColor) private var tintColor: UIColor?

    var body: some View {
        NavigationView {
            UILabel()§
                .text(text) // <- Use key paths chaining for updates.
                .font(.systemFont(ofSize: 23)
                .do { label in 
                    // some custom action on redraw
                }
        
            UIKitView { () -> UILabel in // <- Use `UKitView` directly where the `§` operator is not enough.
            	  let otherLabel = UILabel()
                otherLabel.setContentCompressionResistancePriority(.required, for: .vertical)
                return otherLabel   
            } update: { view, context in
                view.text = text
            }
        }
        .uiKitViewEnvironment(\UILabel.textColor, .green) // <- Set any UIKit view properties as an environment
    }
}
```

## Installation
1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/UIKitViews.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["UIKitViews"])
  ]
)
```
```ruby
$ swift build
```

## Author

dankinsoid, voidilov@gmail.com

## License

UIKitViews is available under the MIT license. See the LICENSE file for more info.
