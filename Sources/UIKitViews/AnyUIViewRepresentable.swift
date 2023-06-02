import SwiftUI

public struct AnyUIViewRepresentable<Content: UIView>: UIKitRepresentable {

	let make: () -> Content
	public var updater: (Content) -> Void = { _ in }

	public init(_ make: @escaping () -> Content) {
		self.make = make
	}

	public var body: some View {
		AnyUIRepresentableWrapper {
			AnyUIViewRepresentableIOS13(make: make, updater: updater, size: $0)
		} iOS16: {
			if #available(iOS 16.0, tvOS 16.0, *) {
				AnyUIViewRepresentableIOS16(make: make, updater: updater)
			}
		}
	}
}

@available(iOS 16.0, tvOS 16.0, *)
private struct AnyUIViewRepresentableIOS16<Content: UIView>: UIViewRepresentable {

	let make: () -> Content
	let updater: (Content) -> Void
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis

	func makeUIView(context: Context) -> Content {
		make()
	}

	func updateUIView(_ uiView: Content, context: Context) {
		updater(uiView)
	}

	func sizeThatFits(_ proposal: ProposedViewSize, uiView: Content, context: Context) -> CGSize? {
		uiView.fittingSizeFor(
			width: selfSizedAxis.contains(.horizontal) ? nil : proposal.width,
			height: selfSizedAxis.contains(.vertical) ? nil : proposal.height
		)
	}
}

private struct AnyUIViewRepresentableIOS13<Content: UIView>: UIViewRepresentable {

	let make: () -> Content
	let updater: (Content) -> Void
	let size: (CGSize?) -> Void
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis

	func makeUIView(context: Context) -> UIKitViewWrapper<Content> {
		UIKitViewWrapper(make())
	}

	func updateUIView(_ uiView: UIKitViewWrapper<Content>, context: Context) {
		updater(uiView.content)
		uiView.onUpdateSize = size
		uiView.selfSizedAxis = selfSizedAxis
	}
}
