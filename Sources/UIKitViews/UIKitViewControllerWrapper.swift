import SwiftUI

final class UIKitViewControllerWrapper<Content: UIViewController>: UIViewController {

	let content: Content
	lazy var wrapper = UIKitViewWrapper(content.view)

	init(_ content: Content) {
		self.content = content
		super.init(nibName: nil, bundle: nil)
		content.willMove(toParent: self)
		addChild(content)
		content.didMove(toParent: self)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	override func loadView() {
		view = wrapper
	}

	deinit {
		content.willMove(toParent: nil)
		content.removeFromParent()
		content.didMove(toParent: nil)
	}
}
