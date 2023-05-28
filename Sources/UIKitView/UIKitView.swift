import SwiftUI
import VDChain

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
			updater(view, $1)
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

public extension UIKitView {

	init<T>(
		_ make: @escaping () -> Base.Root
	) where Base == UIKitViewChaining<AnyUIViewRepresentable<T>> {
		self = UIKitViewChaining(AnyUIViewRepresentable(make)).wrap()
	}

	init<C: ValueChaining>(
		_ make: @escaping () -> Chain<C>
	) where Base == UIKitViewChaining<AnyUIViewRepresentable<C.Root>> {
		self.init {
			make().apply()
		}
	}

	init<T>(
		_ make: @escaping () -> Base.Root
	) where Base == UIKitViewChaining<AnyUIViewControllerRepresentable<T>> {
		self = UIKitViewChaining(AnyUIViewControllerRepresentable(make)).wrap()
	}

	init<C: ValueChaining>(
		_ make: @escaping () -> Chain<C>
	) where Base == UIKitViewChaining<AnyUIViewControllerRepresentable<C.Root>> {
		self.init {
			make().apply()
		}
	}
}

public protocol UIKitRepresentableWrapper {

	associatedtype Representable: UIKitRepresentable
}

public protocol UIKitRepresentable<Content>: View {

	associatedtype Content
	associatedtype ViewContext
	var updater: (Content, ViewContext) -> Void { get set }
	init(_ make: @escaping () -> Content)
}

public struct AnyUIViewRepresentable<Content: UIView>: UIKitRepresentable {

	let make: () -> Content
	public var updater: (Content, Context) -> Void = { _, _ in }

	public init(_ make: @escaping () -> Content) {
		self.make = make
	}
}

extension AnyUIViewRepresentable: UIViewRepresentable {

	public func makeUIView(context: Context) -> Content {
		make()
	}

	public func updateUIView(_ uiView: Content, context: Context) {
		updater(uiView, context)
	}

//	@available(iOS 16.0, *)
//	public func sizeThatFits(_ proposal: ProposedViewSize, uiView: Content, context: Context) -> CGSize? {
//		uiView.sizeThatFits(proposal.width, proposal.height)
//	}
}

public struct AnyUIViewControllerRepresentable<Content: UIViewController>: UIKitRepresentable {

	let make: () -> Content
	public var updater: (Content, Context) -> Void = { _, _ in }

	public init(_ make: @escaping () -> Content) {
		self.make = make
	}
}

extension AnyUIViewControllerRepresentable: UIViewControllerRepresentable {

	public func makeUIViewController(context: Context) -> Content {
		make()
	}

	public func updateUIViewController(_ uiViewController: Content, context: Context) {
		updater(uiViewController, context)
	}

//	@available(iOS 16.0, *)
//	public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: Content, context: Context) -> CGSize? {
//		uiViewController.view.sizeThatFits(proposal)
//	}
}

private extension UIView {

	func sizeThatFits(_ width: CGFloat?, _ height: CGFloat?) -> CGSize? {
		let intrinsicContentSize = intrinsicContentSize
		let targetSize = CGSize(
			width: width ?? intrinsicContentSize.width,
			height: height ?? intrinsicContentSize.height
		)
		guard targetSize.width != UIView.noIntrinsicMetric, targetSize.height != UIView.noIntrinsicMetric else {
			return nil
		}
		let horizontalPriority: UILayoutPriority = width == nil ? .defaultLow : .defaultHigh
		let verticalPriority: UILayoutPriority = height == nil ? .defaultLow : .defaultHigh
		return systemLayoutSizeFitting(
			targetSize,
			withHorizontalFittingPriority: horizontalPriority,
			verticalFittingPriority: verticalPriority
		)
	}
}
