import SwiftUI
import VDChain

extension Chain: View where Base: View {

	public var body: some View {
		base
			.chainApplier { content in
				base.apply(on: &content)
			}
	}
}

extension KeyPathChain: View where Base: View {

	public var body: some View {
		base
	}
}

extension ChainedChain: View where Base: View {

	public var body: some View {
		base
	}
}

extension DoChain: View where Base: View {

	public var body: some View {
		base
	}
}

extension ModifierChain: View where Base: View {

	public var body: some View {
		base
	}
}

enum UIKitViewChainKey<Content>: EnvironmentKey {

	static var defaultValue: (inout Content) -> Void { { _ in } }
}

private struct Key<K: EnvironmentKey>: Hashable {}

private extension EnvironmentValues {

	subscript<K: EnvironmentKey>(_: Key<K>) -> K.Value {
		get { self[K.self] }
		set { self[K.self] = newValue }
	}
}

extension Environment {

	init<K: EnvironmentKey>(_: K.Type) where K.Value == Value {
		self.init(\.[Key<K>()])
	}
}

extension View {

	func chainApplier<Content>(_ applier: @escaping (inout Content) -> Void) -> some View {
		environment(\.[Key<UIKitViewChainKey<Content>>()], applier)
	}
}
