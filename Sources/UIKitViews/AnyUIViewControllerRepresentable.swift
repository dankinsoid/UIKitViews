import SwiftUI

public struct AnyUIViewControllerRepresentable<Content: UIViewController>: UIKitRepresentable {

	let make: () -> Content
	public var updater: (Content, UIKitRepresentableContext) -> Void = { _, _ in }
	public init(_ make: @escaping () -> Content) {
		self.make = make
	}

	public var body: some View {
		AnyUIRepresentableWrapper {
			AnyUIViewControllerRepresentableIOS13(make: make, updater: updater, expectedSize: $0, updateSize: $1)
		} iOS16: {
			AnyUIViewControllerRepresentableIOS16(make: make, updater: updater)
		}
	}
}

private struct AnyUIViewControllerRepresentableIOS16<Content: UIViewController>: UIViewControllerRepresentable {

	let make: () -> Content
	public var updater: (Content, UIKitRepresentableContext) -> Void = { _, _ in }
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis
	@Environment(\.uiKitViewContentMode) private var uiKitViewContentMode

	func makeUIViewController(context: Context) -> Content {
		make()
	}

	func updateUIViewController(_ uiViewController: Content, context: Context) {
        updater(uiViewController, UIKitRepresentableContext(transaction: context.transaction, environment: context.environment))
	}

	@available(iOS 16.0, tvOS 16.0, *)
	func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: Content, context: Context) -> CGSize? {
		uiViewController.view.fittingSizeFor(size: proposal, dimensions: selfSizedAxis, contentMode: uiKitViewContentMode)
	}
}

private struct AnyUIViewControllerRepresentableIOS13<Content: UIViewController>: UIViewControllerRepresentable {

	let make: () -> Content
	public var updater: (Content, UIKitRepresentableContext) -> Void = { _, _ in }
	let expectedSize: CGSize?
	let updateSize: (CGSize?) -> Void
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis
	@Environment(\.uiKitViewContentMode) private var uiKitViewContentMode

	func makeUIViewController(context: Context) -> UIKitViewControllerWrapper<Content> {
		UIKitViewControllerWrapper(make())
	}

	func updateUIViewController(_ uiViewController: UIKitViewControllerWrapper<Content>, context: Context) {
		updater(uiViewController.content, UIKitRepresentableContext(transaction: context.transaction, environment: context.environment))
		uiViewController.wrapper.onUpdateSize = updateSize
		uiViewController.wrapper.expectedSize = expectedSize
		uiViewController.wrapper.uiKitViewContentMode = uiKitViewContentMode
		uiViewController.wrapper.selfSizedAxis = selfSizedAxis
	}
}
