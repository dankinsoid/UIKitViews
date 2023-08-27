import SwiftUI

public struct AnyUIViewRepresentable<Content: UIView>: UIKitRepresentable {

	let make: () -> Content
	public var updater: (Content, UIKitRepresentableContext) -> Void = { _, _ in }

	public init(_ make: @escaping () -> Content) {
		self.make = make
	}

	public var body: some View {
		AnyUIRepresentableWrapper {
			AnyUIViewRepresentableIOS13(make: make, updater: updater, expectedSize: $0, updateSize: $1)
		} iOS16: {
			AnyUIViewRepresentableIOS16(make: make, updater: updater)
		}
	}
}

private struct AnyUIViewRepresentableIOS16<Content: UIView>: UIViewRepresentable {

	let make: () -> Content
	let updater: (Content, UIKitRepresentableContext) -> Void
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis
	@Environment(\.uiKitViewContentMode) private var uiKitViewContentMode

	func makeUIView(context: Context) -> Content {
		make()
	}

	func updateUIView(_ uiView: Content, context: Context) {
		updater(uiView, UIKitRepresentableContext(transaction: context.transaction, environment: context.environment))
	}

	@available(iOS 16.0, tvOS 16.0, *)
	func sizeThatFits(_ proposal: ProposedViewSize, uiView: Content, context: Context) -> CGSize? {
		uiView.fittingSizeFor(size: proposal, dimensions: selfSizedAxis, contentMode: uiKitViewContentMode)
	}
}

private struct AnyUIViewRepresentableIOS13<Content: UIView>: UIViewRepresentable {

	let make: () -> Content
	let updater: (Content, UIKitRepresentableContext) -> Void
	let expectedSize: CGSize?
	let updateSize: (CGSize?) -> Void
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis
	@Environment(\.uiKitViewContentMode) private var uiKitViewContentMode

	func makeUIView(context: Context) -> UIKitViewWrapper<Content> {
		UIKitViewWrapper(make())
	}

	func updateUIView(_ uiView: UIKitViewWrapper<Content>, context: Context) {
		updater(uiView.content, UIKitRepresentableContext(transaction: context.transaction, environment: context.environment))
		uiView.onUpdateSize = updateSize
		uiView.expectedSize = expectedSize
		uiView.uiKitViewContentMode = uiKitViewContentMode
		uiView.selfSizedAxis = selfSizedAxis
	}
}
