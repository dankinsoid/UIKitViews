import SwiftUI
@_exported import VDChain

/// A `SwiftUI` view that represents a `UIKit` view (`UIView`, `UIViewController`).
///
///  - Overview:
/// Create a `UIKitView` object when you want to integrate `UIKit` views into a `SwiftUI` view hierarchy.
/// At creation time, specify an autoclosure that creates the `UIKit` view.
/// You can set view properties via method chaining and `uiKitViewEnvironment` modifier.
/// Use the `UIKitView` like you would any other view.
public typealias UIKitView<Content: UIKitRepresentable> = Chain<UIKitViewChain<Content>>

public protocol UIKitViewChaining<Root>: Chaining {
    
    associatedtype Body: View
    
    func body(values: ChainValues<Root>) -> Body
}

public struct UIKitViewChain<Representable: UIKitRepresentable>: UIKitViewChaining, UIKitRepresentableWrapper {
    
    public typealias Root = Representable.Content

	private let representable: Representable
	@Environment(\.uiKitView) private var environment

	public func body(values: ChainValues<Root>) -> Representable {
		var result = representable
		let updater = result.updater
		result.updater = {
			var view = $0
            var values = values
            values.transaction = $1.transaction
            values.environment = $1.environment
			updater(view, $1)
            values.apply(&view, values)
			environment.apply(for: view)
		}
		return result
	}

	init(_ representable: Representable) {
		self.representable = representable
	}
}

public extension ChainValues {
    
    var transaction: Transaction {
        get { get(\.transaction) ?? Transaction() }
        set { set(\.transaction, newValue) }
    }
}

public extension ChainValues {
    
    var environment: EnvironmentValues {
        get { get(\.environment) ?? EnvironmentValues() }
        set { set(\.environment, newValue) { _, new in new } }
    }
}
