import SwiftUI

extension EnvironmentValues {

	private enum UIKitViewResizingKey: EnvironmentKey {

		static var defaultValue: Axis.Set { [] }
	}

	public var uiKitViewFixedSize: Axis.Set {
		get {
			self[UIKitViewResizingKey.self]
		}
		set {
			self[UIKitViewResizingKey.self] = newValue
		}
	}
}

extension EnvironmentValues {

	private enum UIKitViewUseWrapperKey: EnvironmentKey {

		static var defaultValue: UIKitViewWrapperPolicy { .upToIOS16 }
	}

	var uiKitViewWrapperPolicy: UIKitViewWrapperPolicy {
		get {
			self[UIKitViewUseWrapperKey.self]
		}
		set {
			self[UIKitViewUseWrapperKey.self] = newValue
		}
	}
}

public extension View {

	/// `uiKitViewFixedSize(_:)` is an overloaded method that allows specifying the primary axis for self-sizing.
	///
	/// - Parameter axis: A parameter specifying the primary axes for self-sizing.
	///      - .vertical: The view predominantly self-sizes on the vertical axis.
	///      - .horizontal: The view predominantly self-sizes on the horizontal axis.
	///
	/// - Usage:
	///   1. Self-sizing primarily in the vertical dimension:
	///      ```swift
	///      uiKitViewFixedSize(.vertical)
	///      ```
	///   2. Self-sizing primarily in the horizontal dimension:
	///      ```swift
	///      uiKitViewFixedSize(.horizontal)
	///      ```
	///   To create a view that fixes the view’s size in in both dimansions, see `uiKitViewFixedSize()`.
	/// - Warning: The behavior of this method may slightly differ between iOS 16+ and previous versions.
	///  If you notice some undesirable differences, you can use the `uiKitViewUseWrapper(.always)` method to fix it.
	func uiKitViewFixedSize(_ axis: Axis.Set) -> some View {
		environment(\.uiKitViewFixedSize, axis)
	}

	/// `uiKitViewFixedSize()` is a method that enables self-sizing of UIKit views within the SwiftUI environment.
	/// This function lets the view adjust its own size dynamically based on its content in both dimansions.
	///
	/// - Usage:
	///    ```swift
	///    uiKitViewFixedSize()
	///    ```
	///   To create a view that fixes the view’s size in either the horizontal or vertical dimensions, see `uiKitViewFixedSize(_ axis: Axis.Set)`.
	/// - Warning: The behavior of this method may slightly differ between iOS 16+ and previous versions.
	///  If you notice some undesirable differences, you can use the `uiKitViewUseWrapper(.always)` method to fix it.
	func uiKitViewFixedSize() -> some View {
		uiKitViewFixedSize([.vertical, .horizontal])
	}

	///
	/// This method can be used to address certain behaviors that may differ between iOS versions, particularly if you notice discrepancies in view sizing behavior between iOS 16+ and previous versions.
	///
	/// - Parameter policy: The policy determines when the UIKitView wrapper should be used. Default is `.upToIOS16`
	///
	/// - Usage:
	///    ```swift
	///    uiKitViewUseWrapper(.always)
	///    ```
	///    - `.always`: Always use `UIView` wrapper in `UIKitView` views.
	///    - `.upToIOS16`: Use the `UIView` wrapper only for iOS versions below 16.
	func uiKitViewUseWrapper(_ policy: UIKitViewWrapperPolicy) -> some View {
		environment(\.uiKitViewWrapperPolicy, policy)
	}
}

public enum UIKitViewWrapperPolicy: Equatable, CaseIterable {

	case upToIOS16
	case always
}
