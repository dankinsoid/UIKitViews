import SwiftUI

public extension View {

	/// Set the `UIKitView` environment value of the specified key path with the given value
	func uiKitViewEnvironment<T: UIView, Value>(
		_ keyPath: ReferenceWritableKeyPath<T, Value>,
		_ value: @escaping @autoclosure () -> Value
	) -> some View {
		transformEnvironment(\.uiKitView) {
			$0.set(keyPath: keyPath, value: value)
		}
	}

	/// Set the `UIKitView` environment value of the specified key path with the given value
	func uiKitViewEnvironment<T: UIViewController, Value>(
		_ keyPath: ReferenceWritableKeyPath<T, Value>,
		_ value: @escaping @autoclosure () -> Value
	) -> some View {
		transformEnvironment(\.uiKitView) {
			$0.set(keyPath: keyPath, value: value)
		}
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	func uiKitViewBind<T: UIView, A, B>(
		environment keyPath: KeyPath<EnvironmentValues, A>,
		to viewKeyPath: ReferenceWritableKeyPath<T, B>,
		transform: @escaping (A) -> B
	) -> some View {
		transformEnvironment(\.uiKitView) {
			$0.set(keyPath: viewKeyPath) {
				transform(Environment(keyPath).wrappedValue)
			}
		}
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	func uiKitViewBind<T: UIView, A>(
		environment keyPath: KeyPath<EnvironmentValues, A>,
		to viewKeyPath: ReferenceWritableKeyPath<T, A>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { $0 }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	func uiKitViewBind<T: UIView, A>(
		environment keyPath: KeyPath<EnvironmentValues, A>,
		to viewKeyPath: ReferenceWritableKeyPath<T, A?>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { $0 }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	@available(iOS 14.0, tvOS 14.0, *)
	func uiKitViewBind<T: UIView>(
		environment keyPath: KeyPath<EnvironmentValues, Color>,
		to viewKeyPath: ReferenceWritableKeyPath<T, UIColor>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { UIColor($0) }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	@available(iOS 14.0, tvOS 14.0, *)
	func uiKitViewBind<T: UIView>(
		environment keyPath: KeyPath<EnvironmentValues, Color>,
		to viewKeyPath: ReferenceWritableKeyPath<T, UIColor?>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { UIColor($0) }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	func uiKitViewBind<T: UIViewController, A, B>(
		environment keyPath: KeyPath<EnvironmentValues, A>,
		to viewKeyPath: ReferenceWritableKeyPath<T, B>,
		transform: @escaping (A) -> B
	) -> some View {
		transformEnvironment(\.uiKitView) {
			$0.set(keyPath: viewKeyPath) {
				transform(Environment(keyPath).wrappedValue)
			}
		}
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	func uiKitViewBind<T: UIViewController, A>(
		environment keyPath: KeyPath<EnvironmentValues, A>,
		to viewKeyPath: ReferenceWritableKeyPath<T, A>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { $0 }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	func uiKitViewBind<T: UIViewController, A>(
		environment keyPath: KeyPath<EnvironmentValues, A>,
		to viewKeyPath: ReferenceWritableKeyPath<T, A?>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { $0 }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	@available(iOS 14.0, tvOS 14.0, *)
	func uiKitViewBind<T: UIViewController>(
		environment keyPath: KeyPath<EnvironmentValues, Color>,
		to viewKeyPath: ReferenceWritableKeyPath<T, UIColor>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { UIColor($0) }
	}

	/// Binds SwiftUI environment to `UIKitView` environment
	@available(iOS 14.0, tvOS 14.0, *)
	func uiKitViewBind<T: UIViewController>(
		environment keyPath: KeyPath<EnvironmentValues, Color>,
		to viewKeyPath: ReferenceWritableKeyPath<T, UIColor?>
	) -> some View {
		uiKitViewBind(environment: keyPath, to: viewKeyPath) { UIColor($0) }
	}
}

extension EnvironmentValues {

	var uiKitView: UIKitViewEnvironment {
		get { self[UIKitKey.self] }
		set { self[UIKitKey.self] = newValue }
	}

	private enum UIKitKey: EnvironmentKey {

		static var defaultValue: UIKitViewEnvironment { .init() }
	}
}

struct UIKitViewEnvironment {

	private var values: [AnyKeyPath: ValueAndSetter] = [:]

	func apply<T>(for element: T) {
		values.values.forEach {
			$0.setter(element)
		}
	}

	mutating func set<Base, Value>(keyPath: ReferenceWritableKeyPath<Base, Value>, value: @escaping () -> Value) {
		values[keyPath] = ValueAndSetter(value: value) {
			($0 as? Base)?[keyPath: keyPath] = value()
		}
	}

	subscript<Base, Value>(_ keyPath: ReferenceWritableKeyPath<Base, Value>) -> Value? {
		values[keyPath]?.value() as? Value
	}

	private struct ValueAndSetter {

		var value: () -> Any
		var setter: (Any) -> Void
	}
}

public extension Environment {

	init<Base, T>(_ keyPath: ReferenceWritableKeyPath<Base, T>) where T? == Value {
		self.init(\.uiKitView[keyPath])
	}
}
