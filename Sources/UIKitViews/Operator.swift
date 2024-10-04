import SwiftUI

postfix operator §

/// An operator that creates a `UIKitView`.
///
/// ```swift
///  UILabel()§
///    .font(.systemFont(ofSize: 24))
///    .textColor(.black)
///    .text(title)
/// ```
///
///  - Overview:
/// Create a `UIKitView` object when you want to integrate `UIKit` views into a `SwiftUI` view hierarchy.
/// At creation time, specify an autoclosure that creates the `UIKit` view.
/// You can set view properties via method chaining and `uiKitViewEnvironment` modifier.
/// Use the `UIKitView` like you would any other view.
public postfix func §<T: UIView>(_ view: @escaping @autoclosure () -> T) -> UIKitView<AnyUIViewRepresentable<T>> {
	UIKitView(view)
}

/// An operator that creates a `UIKitView`.
///
/// ```swift
///  MyViewController()§
///    .title(title)
/// ```
///
///  - Overview:
/// Create a `UIKitView` object when you want to integrate `UIKit` views into a `SwiftUI` view hierarchy.
/// At creation time, specify an autoclosure that creates the `UIKit` view.
/// You can set view properties via method chaining and `uiKitViewEnvironment` modifier.
/// Use the `UIKitView` like you would any other view.
public postfix func §<T: UIViewController>(_ view: @escaping @autoclosure () -> T) -> UIKitView<AnyUIViewControllerRepresentable<T>> {
	UIKitView(view)
}

@ViewBuilder
func tt() -> some View {
	UILabel()§
		.text("Text")
}
