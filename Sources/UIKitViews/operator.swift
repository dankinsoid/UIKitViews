import UIKit

postfix operator §

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public postfix func §<T: UIView>(_ lhs: @escaping @autoclosure () -> T) -> UIKitView<_UIViewView<T>> {
	UIKitView(lhs(), update: { _, _ in })
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public postfix func §<T: UIViewController>(_ lhs: @escaping @autoclosure () -> T) -> UIKitView<_UIViewControllerView<T>> {
    UIKitView(lhs(), update: { _, _ in })
}
