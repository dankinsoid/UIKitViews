import SwiftUI
@_exported import VDChain

/// A `SwiftUI` view that represents a `UIKit` view (`UIView`, `UIViewController`).
///
///  - Overview:
/// Create a `UIKitView` object when you want to integrate `UIKit` views into a `SwiftUI` view hierarchy.
/// At creation time, specify an autoclosure that creates the `UIKit` view.
/// You can set view properties via method chaining and `uiKitViewEnvironment` modifier.
/// Use the `UIKitView` like you would any other view.
public typealias UIKitView<Content: UIKitRepresentable> = Chain<UIKitViewChaining<Content>>

public struct UIKitViewChaining<Representable: UIKitRepresentable>: View, Chaining, UIKitRepresentableWrapper {

	private let representable: Representable
	@Environment(\.uiKitView) private var environment
	@Environment(UIKitViewChainKey<Representable.Content>.self) private var applier

	public var body: some View {
		var result = representable
		let updater = result.updater
		result.updater = {
			var view = $0
			updater(view)
			applier(&view)
			environment.apply(for: view)
		}
		return result
	}

	init(_ representable: Representable) {
		self.representable = representable
	}

	public func apply(on root: inout Representable.Content) {}
}
