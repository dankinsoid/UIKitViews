import SwiftUI

public extension View {

	/// `uiKitViewFixedSize(_:)` is an overloaded method that allows specifying the axis for self-sizing.
	///
	/// 1. Self-sizing in the vertical dimension:
	///   ```swift
	///   uiKitViewFixedSize(.vertical)
	///   ```
	/// 2. Self-sizing in the horizontal dimension:
	///   ```swift
	///   uiKitViewFixedSize(.horizontal)
	///   ```
	///   To create a view that fixes the view’s size in in both dimansions, see `uiKitViewFixedSize()`.
	/// - Warning: The behavior of this method may slightly differ between iOS 16+ and previous versions.
	///  If you notice some undesirable differences, you can use the `uiKitViewUseWrapper(.always)` method to fix it.
	///
	/// - Parameters:
	///   - axis: A parameter specifying the primary axes for self-sizing.
	///      - .vertical: The view predominantly self-sizes on the vertical axis.
	///      - .horizontal: The view predominantly self-sizes on the horizontal axis.
	func uiKitViewFixedSize(_ axis: Axis.Set) -> some View {
		environment(\.uiKitViewFixedSize, axis)
	}

	/// `uiKitViewFixedSize()` is a method that enables self-sizing of UIKit views within the SwiftUI environment.
	/// This function lets the view adjust its own size dynamically based on its content in both dimansions.
	///
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

	/// This method adjusts the content resizing behaviour of a UIView in dimensions where its size is not fixed.
	///
	/// - Parameter contentMode: A `UIKitViewContentMode` value that determines how the view should resize its content.
	///     - `.fill`: The UIView should resize to completely fill the view.
	///     - `.fit(Alignment)`: The UIView should resize to fit within the view while preserving its aspect ratio. The alignment determines how the UIView is positioned within the view if there is extra space.
	///
	/// - Usage:
	///     ```swift
	///     uiKitViewContentMode(.fill)
	///     uiKitViewContentMode(.fit(.center))
	///     ```
	///
	/// - Returns: A view that adjusts its content resizing behavior according to the specified `UIKitViewContentMode`.
	func uiKitViewContentMode(_ contentMode: UIKitViewContentMode) -> some View {
		environment(\.uiKitViewContentMode, contentMode)
	}
}

public enum UIKitViewWrapperPolicy: Equatable, CaseIterable {

	case upToIOS16
	case always
}

/// Enum that determines how a view should resize its content in dimensions where its size is not fixed.
///
public enum UIKitViewContentMode: Equatable {

	/// - `fit(Alignment)`: The UIView should resize to fit within the view while preserving its aspect ratio.
	/// The alignment determines how the UIView is positioned within the view if there is extra space.
	case fit(Alignment)

	/// - `fill`: The UIView should resize to completely fill the view.
	case fill

	public static var fit: UIKitViewContentMode {
		.fit(.center)
	}

	var alignment: Alignment {
		switch self {
		case let .fit(alignment):
			return alignment
		case .fill:
			return .center
		}
	}
}

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

	public var uiKitViewWrapperPolicy: UIKitViewWrapperPolicy {
		get {
			self[UIKitViewUseWrapperKey.self]
		}
		set {
			self[UIKitViewUseWrapperKey.self] = newValue
		}
	}
}

extension EnvironmentValues {

	private enum UIKitViewContentModeKey: EnvironmentKey {

		static var defaultValue: UIKitViewContentMode { .fill }
	}

	public var uiKitViewContentMode: UIKitViewContentMode {
		get {
			self[UIKitViewContentModeKey.self]
		}
		set {
			self[UIKitViewContentModeKey.self] = newValue
		}
	}
}
