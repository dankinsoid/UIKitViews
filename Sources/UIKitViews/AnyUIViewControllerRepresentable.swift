import SwiftUI

public struct AnyUIViewControllerRepresentable<Content: UIViewController>: UIKitRepresentable {

	let make: () -> Content
	public var updater: (Content) -> Void = { _ in }
	public init(_ make: @escaping () -> Content) {
		self.make = make
	}

	public var body: some View {
		AnyUIRepresentableWrapper {
			AnyUIViewControllerRepresentableIOS13(make: make, updater: updater, size: $0)
		} iOS16: {
			AnyUIViewControllerRepresentableIOS16(make: make, updater: updater)
		}
	}
}

private struct AnyUIViewControllerRepresentableIOS16<Content: UIViewController>: UIViewControllerRepresentable {

	let make: () -> Content
	public var updater: (Content) -> Void = { _ in }
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis

	func makeUIViewController(context: Context) -> Content {
		make()
	}

	func updateUIViewController(_ uiViewController: Content, context: Context) {
		updater(uiViewController)
	}

	@available(iOS 16.0, tvOS 16.0, *)
	func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: Content, context: Context) -> CGSize? {
		uiViewController.view.fittingSizeFor(size: proposal, dimensions: selfSizedAxis)
	}
}

private struct AnyUIViewControllerRepresentableIOS13<Content: UIViewController>: UIViewControllerRepresentable {

	let make: () -> Content
	public var updater: (Content) -> Void = { _ in }
	let size: (CGSize?) -> Void
	@Environment(\.uiKitViewFixedSize) private var selfSizedAxis

	func makeUIViewController(context: Context) -> UIKitViewControllerWrapper<Content> {
		UIKitViewControllerWrapper(make())
	}

	func updateUIViewController(_ uiViewController: UIKitViewControllerWrapper<Content>, context: Context) {
		updater(uiViewController.content)
		uiViewController.wrapper.onUpdateSize = size
	}
}
