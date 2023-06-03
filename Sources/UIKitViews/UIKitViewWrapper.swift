import SwiftUI

final class UIKitViewWrapper<Content: UIView>: UIView {

	let content: Content
	var onUpdateSize: (CGSize?) -> Void = { _ in }
	var expectedSize: CGSize? {
		didSet {
			guard oldValue != expectedSize else { return }
			if let expectedSize {
				updateSize(expectedSize)
			}
		}
	}

	var uiKitViewContentMode: UIKitViewContentMode = .fill {
		didSet {
			guard oldValue != uiKitViewContentMode else { return }
			if let expectedSize {
				updateSize(expectedSize)
			}
		}
	}

	var size: CGSize? {
		didSet {
			guard oldValue != size else { return }
			invalidateIntrinsicContentSize()
			DispatchQueue.main.async { [self] in
				onUpdateSize(size)
			}
		}
	}

	var selfSizedAxis: Axis.Set = [.vertical, .horizontal] {
		didSet {
			guard oldValue != selfSizedAxis else { return }
			updateSize(expectedSize ?? frame.size)
		}
	}

//	override var frame: CGRect {
//		didSet {
//			guard oldValue != frame else { return }
//			content.frame = bounds
//			content.layoutIfNeeded()
//			guard oldValue.size != frame.size else { return }
//			updateSize(frame.size)
//		}
//	}

	override var intrinsicContentSize: CGSize {
		guard let size else {
			return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
		}
		return CGSize(
			width: selfSizedAxis.contains(.horizontal) ? size.width : UIView.noIntrinsicMetric,
			height: selfSizedAxis.contains(.vertical) ? size.height : UIView.noIntrinsicMetric
		)
	}

	init(_ content: Content) {
		self.content = content
		super.init(frame: CGRect(origin: .zero, size: content.intrinsicContentSize))
		backgroundColor = .clear
		addSubview(content)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		content.frame = bounds
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	func updateSize(_ newValue: CGSize) {
		size = content.fittingSizeFor(
			width: selfSizedAxis.contains(.horizontal) ? nil : newValue.width,
			height: selfSizedAxis.contains(.vertical) ? nil : newValue.height,
			contentMode: uiKitViewContentMode
		)
	}
}
