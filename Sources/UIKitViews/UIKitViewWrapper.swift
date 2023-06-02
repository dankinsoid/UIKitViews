import SwiftUI

final class UIKitViewWrapper<Content: UIView>: UIView {

	let content: Content
	var onUpdateSize: (CGSize?) -> Void = { _ in }

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
			updateSize()
		}
	}

	override var frame: CGRect {
		didSet {
			guard oldValue != frame else { return }
			content.frame = bounds
			content.layoutIfNeeded()
			guard oldValue.size != frame.size else { return }
			updateSize()
		}
	}

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

	func updateSize() {
		size = content.fittingSizeFor(
			width: selfSizedAxis.contains(.horizontal) ? nil : frame.width,
			height: selfSizedAxis.contains(.vertical) ? nil : frame.height
		)
	}
}
