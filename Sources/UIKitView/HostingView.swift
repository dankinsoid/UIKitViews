import SwiftUI

@dynamicMemberLookup
open class HostingView<RootView: View>: UIView {

	open var rootView: RootView {
		get { hostingController.rootView }
		set {
			hostingController.rootView = newValue
			hostingController.view.invalidateIntrinsicContentSize()
			invalidateIntrinsicContentSize()
		}
	}

	override open var intrinsicContentSize: CGSize {
		hostingController.view.intrinsicContentSize
	}

	private let hostingController: UIHostingController<RootView>

	public init(_ rootView: RootView) {
		hostingController = SelfSizingHostingController(rootView: rootView)
		super.init(frame: .zero)
		afterInit()
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public subscript<T>(dynamicMember member: WritableKeyPath<RootView, T>) -> T {
		get {
			rootView[keyPath: member]
		}
		set {
			rootView[keyPath: member] = newValue
		}
	}

	private func afterInit() {
		addSubview(hostingController.view)
		hostingController.view.backgroundColor = .clear
		hostingController.view.translatesAutoresizingMaskIntoConstraints = false

		hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		hostingController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
		hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	override open func didMoveToWindow() {
		super.didMoveToWindow()
		guard let controller else { return }
		hostingController.willMove(toParent: controller)
		controller.addChild(hostingController)
	}
}

private extension UIView {

	var controller: UIViewController? {
		(next as? UIViewController) ?? superview?.controller
	}
}
